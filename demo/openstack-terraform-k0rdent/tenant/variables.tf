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

variable "password_override_special" {
  description = "Special characters to use in password"
  type        = string
  default     = "_%@"
}
