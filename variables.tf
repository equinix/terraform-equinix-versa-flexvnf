variable "metro_code" {
  description = "Device location metro code"
  type        = string
  validation {
    condition     = can(regex("^[A-Z]{2}$", var.metro_code))
    error_message = "Valid metro code consits of two capital leters, i.e. SV, DC."
  }
}

variable "account_number" {
  description = "Billing account number for a device"
  type        = string
  default     = 0
}

variable "platform" {
  description = "Device platform flavor that determines number of CPU cores and memory"
  type        = string
  validation {
    condition     = can(regex("^(small|medium|large|xlarge)$", var.platform))
    error_message = "One of following platform flavors are supported: small, medium, large, xlarge."
  }
}

variable "software_package" {
  description = "Device software package"
  type        = string
  validation {
    condition     = can(regex("^(FLEX_VNF_2|FLEX_VNF_4|FLEX_VNF_6|FLEX_VNF_16)$", var.software_package))
    error_message = "One of following software packages are supported: FLEX_VNF_2, FLEX_VNF_4, FLEX_VNF_6, FLEX_VNF_16."
  }
}

variable "name" {
  description = "Device name"
  type        = string
  validation {
    condition     = length(var.name) >= 2 && length(var.name) <= 50
    error_message = "Device name should consist of 2 to 50 characters."
  }
}

variable "term_length" {
  description = "Term length in months"
  type        = number
  validation {
    condition     = can(regex("^(1|12|24|36)$", var.term_length))
    error_message = "One of following term lengths are available: 1, 12, 24, 36 months."
  }
}

variable "notifications" {
  description = "List of email addresses that will receive device status notifications"
  type        = list(string)
  validation {
    condition     = length(var.notifications) > 0
    error_message = "Notification list cannot be empty."
  }
}

variable "acl_template_id" {
  description = "Identifier of an ACL template that will be applied on a device"
  type        = string
  validation {
    condition     = length(var.acl_template_id) > 0
    error_message = "ACL template identifier has to be an non empty string."
  }
}

variable "additional_bandwidth" {
  description = "Additional internet bandwidth for a device"
  type        = number
  default     = 0
  validation {
    condition     = var.additional_bandwidth == 0 || (var.additional_bandwidth >= 25 && var.additional_bandwidth <= 2001)
    error_message = "Additional internet bandwidth should be between 25 and 2001 Mbps."
  }
}

variable "controller_1_ip" {
  description = "IP address for SDWAN controller 1"
  type        = string
  validation {
    condition     = length(var.controller_1_ip) > 0
    error_message = "Controller 1 IP has to be an non empty string."
  }
}

variable "controller_2_ip" {
  description = "IP address for SDWAN controller 2"
  type        = string
  validation {
    condition     = length(var.controller_2_ip) > 0
    error_message = "Controller 2 IP has to be an non empty string."
  }
}

variable "local_id" {
  description = "Local identifier from Versa configuration in email format"
  type        = string
  validation {
    condition     = length(var.local_id) > 0
    error_message = "Local ID has to be an non empty string."
  }
}

variable "remote_id" {
  description = "Remote identifier from Versa configuration in email fromat"
  type        = string
  validation {
    condition     = length(var.remote_id) > 0
    error_message = "Remote ID has to be an non empty string."
  }
}

variable "serial_number" {
  description = "Device serial number"
  type        = string
  validation {
    condition     = length(var.serial_number) > 0
    error_message = "Serial number has to be an non empty string."
  }
}

variable "interface_count" {
  description = "Number of network interfaces on a device"
  type        = number
  default     = 0
  validation {
    condition     = var.interface_count == 0 || var.interface_count == 10 || var.interface_count == 16
    error_message = "Device interface count has to be either 10 or 16."
  }
}

variable "secondary" {
  description = "Secondary device attributes"
  type        = map(any)
  default     = { enabled = false }
  validation {
    condition     = can(var.secondary.enabled)
    error_message = "Key 'enabled' has to be defined for secondary device."
  }
  validation {
    condition     = !try(var.secondary.enabled, false) || can(regex("^[A-Z]{2}$", var.secondary.metro_code))
    error_message = "Key 'metro_code' has to be defined for secondary device. Valid metro code consits of two capital leters, i.e. SV, DC."
  }
  validation {
    condition     = !try(var.secondary.enabled, false) || try(length(var.secondary.acl_template_id) > 0, false)
    error_message = "Key 'acl_template_id' has to be defined for secondary device. Valid ACL template identifier has to be an non empty string."
  }
  validation {
    condition     = !try(var.secondary.enabled, false) || try(var.secondary.additional_bandwidth >= 25 && var.secondary.additional_bandwidth <= 2001, true)
    error_message = "Key 'additional_bandwidth' has to be between 25 and 2001 Mbps."
  }
  validation {
    condition     = !try(var.secondary.enabled, false) || try(length(var.secondary.controller_1_ip) > 0, false)
    error_message = "Key 'controller_1_ip' has to be defined for secondary device. Valid Controller 1 IP has to be an non empty string."
  }
  validation {
    condition     = !try(var.secondary.enabled, false) || try(length(var.secondary.controller_2_ip) > 0, false)
    error_message = "Key 'controller_2_ip' has to be defined for secondary device. Valid Controller 2 IP has to be an non empty string."
  }
  validation {
    condition     = !try(var.secondary.enabled, false) || try(length(var.secondary.local_id) > 0, false)
    error_message = "Key 'local_id' has to be defined for secondary device. Valid Local ID has to be an non empty string."
  }
  validation {
    condition     = !try(var.secondary.enabled, false) || try(length(var.secondary.remote_id) > 0, false)
    error_message = "Key 'remote_id' has to be defined for secondary device. Valid Remote ID has to be an non empty string."
  }
  validation {
    condition     = !try(var.secondary.enabled, false) || try(length(var.secondary.serial_number) > 0, false)
    error_message = "Key 'serial_number' has to be defined for secondary device. Valid Serial Number has to be an non empty string."
  }
}
