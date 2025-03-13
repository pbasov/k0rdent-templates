# Network variables
variable "network_name" {
  description = "Name of the network to create"
  type        = string
  default     = "kcm-net"
}

variable "subnet_cidr" {
  description = "CIDR for the subnet"
  type        = string
  default     = "192.168.1.0/24"
}

variable "external_network_name" {
  description = "Name of the external network to connect to"
  type        = string
  default     = "Public_Net_Vlan_3102"
}

variable "dns_servers" {
  description = "List of DNS servers for the subnet"
  type        = list(string)
  default     = ["100.64.8.120", "100.64.8.121", "100.64.8.122"]
}

# VM variables
variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 3
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
  default     = "kcm"
}

variable "vm_image_name" {
  description = "Name of the image to use for VMs"
  type        = string
  default     = "ubuntu-noble-server-amd64"
}

variable "vm_flavor_name" {
  description = "Name of the flavor to use for VMs"
  type        = string
  default     = "m1.medium"
}

variable "vm_key_pair" {
  description = "Name of the key pair to use for VMs (if not creating a new one)"
  type        = string
  default     = ""
}

variable "ssh_public_key" {
  description = "SSH public key to use for VM access (will create a new keypair if provided)"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBtnx44tKnvr3PWwLBqh2C/lLwHPxjS0POnV+8A3Mg8k"
}

# Volume variables
variable "vm_volume_size" {
  description = "Size of the boot volume in GB"
  type        = number
  default     = 64
}

variable "vm_volume_type" {
  description = "Type of volume to use for VMs"
  type        = string
  default     = "netapp-nvme"
}

# Application Credential variables
variable "app_cred_name" {
  description = "Name of the application credential to create"
  type        = string
  default     = "k0rdent-app-cred"
}

variable "app_cred_description" {
  description = "Description of the application credential"
  type        = string
  default     = "Application credential for K0rdent OpenStack infrastructure"
}

variable "app_cred_roles" {
  description = "List of roles to assign to the application credential"
  type        = list(string)
  default     = ["member"]
}

variable "app_cred_expiration" {
  description = "Expiration time for the application credential (RFC3339 format, e.g., 2025-12-31T23:59:59Z)"
  type        = string
  default     = null
}

variable "app_cred_unrestricted" {
  description = "Whether the application credential has unrestricted access"
  type        = bool
  default     = false
}
