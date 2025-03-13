variable "project_name" {
  description = "Name of the OpenStack project/tenant"
  type        = string
  default     = "k0rdent"
}

variable "project_description" {
  description = "Description of the OpenStack project/tenant"
  type        = string
  default     = "k0rdent base tenant"
}

variable "user_name" {
  description = "Name of the user to create"
  type        = string
  default     = "k0rdent"
}

variable "password_length" {
  description = "Length of the generated password"
  type        = number
  default     = 16
}

variable "password_special" {
  description = "Include special characters in password"
  type        = bool
  default     = false
}

variable "cloud_name" {
  description = "Name of the cloud in clouds.yaml"
  type        = string
  default     = "openstack"
}

variable "auth_url" {
  description = "Authentication URL for OpenStack"
  type        = string
}

variable "user_domain_name" {
  description = "User domain name in OpenStack"
  type        = string
  default     = "Default"
}

variable "project_domain_name" {
  description = "Project domain name in OpenStack"
  type        = string
  default     = "Default"
}

variable "region_name" {
  description = "Region name in OpenStack"
  type        = string
  default     = "RegionOne"
}

variable "password_override_special" {
  description = "Special characters to use in password"
  type        = string
  default     = "_%@"
}
