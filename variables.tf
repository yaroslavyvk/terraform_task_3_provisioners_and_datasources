variable "prefix" {
  type = string
}

variable "admin_username" {
  description = "Admin username for SSH access to the VM"
  type        = string
}

variable "admin_password" { # I have set an environment variable before running Terraform commands export TF_VAR_admin_password=""
  description = "Admin password for SSH access to the VM"
  type        = string
  sensitive   = true
}
