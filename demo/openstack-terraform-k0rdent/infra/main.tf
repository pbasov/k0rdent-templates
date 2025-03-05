# Infrastructure creation
terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

provider "openstack" {
  # Configure through environment variables
}

provider "random" {}


# Network resources
resource "openstack_networking_network_v2" "network" {
  name           = var.network_name
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "subnet" {
  name            = "${var.network_name}-subnet"
  network_id      = openstack_networking_network_v2.network.id
  cidr            = var.subnet_cidr
  ip_version      = 4
  dns_nameservers = var.dns_servers
}

data "openstack_networking_network_v2" "external_network" {
  name = var.external_network_name
}

resource "openstack_networking_router_v2" "router" {
  name                = "${var.network_name}-router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.external_network.id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

# Security group
resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = "${var.network_name}-secgroup"
  description = "Security group for ${var.network_name} instances"
}

# Security group rules
resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_internal_traffic" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.secgroup.id
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_podcidr" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "10.244.0.0/16"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_k8s" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9443
  port_range_max    = 9443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_k8s_ext" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

# Create network ports for instances
resource "openstack_networking_port_v2" "instance_ports" {
  count          = var.vm_count
  name           = "${var.vm_name_prefix}-port-${count.index}"
  network_id     = openstack_networking_network_v2.network.id
  admin_state_up = true

  security_group_ids = [openstack_networking_secgroup_v2.secgroup.id]

  allowed_address_pairs {
    ip_address = "0.0.0.0/0"
  }

  depends_on = [
    openstack_networking_subnet_v2.subnet,
    openstack_networking_router_interface_v2.router_interface
  ]
}

# VM instances
resource "openstack_compute_keypair_v2" "k0rdent_key" {
  name       = "k0rdent-key"
  public_key = var.ssh_public_key
}

# Get image ID for boot volume
data "openstack_images_image_v2" "vm_image" {
  name = var.vm_image_name
  most_recent = true
}

resource "openstack_compute_instance_v2" "instances" {
  count           = var.vm_count
  name            = "${var.vm_name_prefix}-${count.index}"
  flavor_name     = var.vm_flavor_name
  key_pair        = var.ssh_public_key != "" ? openstack_compute_keypair_v2.k0rdent_key.name : (var.vm_key_pair != "" ? var.vm_key_pair : null)
  security_groups = [openstack_networking_secgroup_v2.secgroup.name]

  block_device {
    uuid                  = data.openstack_images_image_v2.vm_image.id
    source_type           = "image"
    volume_size           = var.vm_volume_size
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
    volume_type           = var.vm_volume_type
  }

  network {
    port = openstack_networking_port_v2.instance_ports[count.index].id
  }

  depends_on = [
    openstack_networking_port_v2.instance_ports
  ]
}

# Floating IPs
resource "openstack_networking_floatingip_v2" "floating_ips" {
  count    = var.vm_count
  pool     = data.openstack_networking_network_v2.external_network.name
}

resource "openstack_networking_floatingip_associate_v2" "floating_ip_associations" {
  count       = var.vm_count
  floating_ip = openstack_networking_floatingip_v2.floating_ips[count.index].address
  port_id     = openstack_compute_instance_v2.instances[count.index].network.0.port

  depends_on = [
    openstack_compute_instance_v2.instances,
    openstack_networking_network_v2.network,
    openstack_networking_subnet_v2.subnet,
    openstack_networking_router_interface_v2.router_interface
  ]
}

# Generate k0sctl.yaml file
resource "local_file" "k0sctl_config" {
  content = templatefile("${path.module}/../k0sctl.yaml.tftpl", {
    instance_names = [for instance in openstack_compute_instance_v2.instances : instance.name]
    private_ips    = {for instance in openstack_compute_instance_v2.instances : instance.name => instance.access_ip_v4}
    floating_ips   = {for i, floating_ip in openstack_networking_floatingip_v2.floating_ips :
                      openstack_compute_instance_v2.instances[i].name => floating_ip.address}
  })
  filename = "${path.module}/../k0sctl.yaml"
}

# Outputs
output "network_id" {
  value = openstack_networking_network_v2.network.id
}

output "instance_ips" {
  value = {
    for i, instance in openstack_compute_instance_v2.instances :
    instance.name => instance.access_ip_v4
  }
}

output "floating_ips" {
  value = {
    for i, floating_ip in openstack_networking_floatingip_v2.floating_ips :
    openstack_compute_instance_v2.instances[i].name => floating_ip.address
  }
}

output "instance_ports" {
  value = {
    for i, instance in openstack_compute_instance_v2.instances :
    instance.name => instance.network[*].port
  }
}
