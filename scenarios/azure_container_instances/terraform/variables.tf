# variables.tfvars

variable "ssh_keys" {
  type        = string
  description = "SSH public keys"
  validation {
    condition     = can(regex("^(ssh-rsa|ssh-ed25519) [A-Za-z0-9+/]+[=]{0,3}( [^@]+@[^@]+)?$", var.ssh_keys))
    error_message = "ssh_keys must be a valid SSH public key"
  }
}

variable "git_user_name" {
  type        = string
  description = "Git user name"
  validation {
    # in condition regex space is allowed
    condition     = can(regex("^[a-zA-Z0-9_ ]+$", var.git_user_name))
    error_message = "git_user_name must be a valid username"
  }
}

variable "git_user_email" {
  type        = string
  description = "Git user email"
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.git_user_email))
    error_message = "git_user_email must be a valid email address"
  }
}
