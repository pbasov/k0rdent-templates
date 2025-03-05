# Tenant and user creation
terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "openstack" {
  # Configure through environment variables
}

provider "random" {}

resource "random_password" "user_password" {
  length           = var.password_length
  special          = var.password_special
  override_special = var.password_override_special
}

resource "openstack_identity_project_v3" "tenant" {
  name        = var.project_name
  description = var.project_description
}

resource "openstack_identity_user_v3" "user" {
  name               = var.user_name
  default_project_id = openstack_identity_project_v3.tenant.id
  password           = random_password.user_password.result
}

data "openstack_identity_role_v3" "admin" {
  name = "admin"
}

resource "openstack_identity_role_assignment_v3" "user_role" {
  project_id = openstack_identity_project_v3.tenant.id
  user_id    = openstack_identity_user_v3.user.id
  role_id    = data.openstack_identity_role_v3.admin.id
}

output "user_password" {
  value     = random_password.user_password.result
  sensitive = false
}

output "project_id" {
  value = openstack_identity_project_v3.tenant.id
}

output "user_id" {
  value = openstack_identity_user_v3.user.id
}
