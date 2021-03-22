locals {
  devices = try(var.secondary.enabled, false) ? ["pri", "sec"] : ["pri"]
  metro_codes = try(var.secondary.enabled, false) ? {
    "pri" = var.metro_code
    "sec" = var.secondary.metro_code
    } : {
    "pri" = var.metro_code
  }
  account_numbers = {
    "pri" = try(var.account_number, 0)
    "sec" = try(var.secondary.account_number, 0)
  }
  metro_accounts = {
    for device in local.devices :
    device => local.account_numbers[device] > 0 ? local.account_numbers[device] : data.equinix_network_account.this[local.metro_codes[device]].number
  }
}

data "equinix_network_account" "this" {
  for_each   = toset(values(local.metro_codes))
  metro_code = each.key
  status     = "Active"
}

data "equinix_network_device_type" "this" {
  category    = "SDWAN"
  vendor      = "VERSA Networks"
  metro_codes = values(local.metro_codes)
}

data "equinix_network_device_platform" "this" {
  device_type = data.equinix_network_device_type.this.code
  flavor      = var.platform
}

data "equinix_network_device_software" "this" {
  device_type = data.equinix_network_device_type.this.code
  packages    = [var.software_package]
  stable      = true
  most_recent = true
}

resource "equinix_network_device" "this" {
  lifecycle {
    ignore_changes = [version, core_count]
  }
  self_managed         = true
  byol                 = true
  name                 = var.name
  type_code            = data.equinix_network_device_type.this.code
  package_code         = var.software_package
  version              = data.equinix_network_device_software.this.version
  core_count           = data.equinix_network_device_platform.this.core_count
  metro_code           = var.metro_code
  account_number       = local.metro_accounts["pri"]
  term_length          = var.term_length
  notifications        = var.notifications
  acl_template_id      = var.acl_template_id
  additional_bandwidth = var.additional_bandwidth > 0 ? var.additional_bandwidth : null
  interface_count      = var.interface_count > 0 ? var.interface_count : null
  vendor_configuration = {
    controller1  = var.controller_1_ip
    controller2  = var.controller_2_ip
    localId      = var.local_id
    remoteId     = var.remote_id
    serialNumber = var.serial_number
  }
  dynamic "secondary_device" {
    for_each = try(var.secondary.enabled, false) ? [1] : []
    content {
      name                 = "${var.name}-secondary"
      metro_code           = var.secondary.metro_code
      account_number       = local.metro_accounts["sec"]
      notifications        = var.notifications
      acl_template_id      = var.secondary.acl_template_id
      additional_bandwidth = try(var.secondary.additional_bandwidth, null)
      vendor_configuration = {
        controller1  = var.secondary.controller_1_ip
        controller2  = var.secondary.controller_2_ip
        localId      = var.secondary.local_id
        remoteId     = var.secondary.remote_id
        serialNumber = var.secondary.serial_number
      }
    }
  }
}
