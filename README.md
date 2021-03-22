# Equinix Network Edge: VERSA Networks FlexVNF SD-WAN edge device

A Terraform module to create VERSA Networks FlexVNF SD-WAN network edge device
on the Equinix platform.

![Terraform status](https://github.com/equinix/terraform-equinix-versa-flexvnf/workflows/Terraform/badge.svg)
![License](https://img.shields.io/github/license/equinix/terraform-equinix-versa-flexvnf)

Supported device modes:

| Management Mode | License mode | Notes |
|-----------------|--------------|-------|
| Self managed    | Bring your own license | - |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| equinix/equinix | >= 1.1.0 |

## Providers

| Name | Version |
|---------|----------|
| equinix/equinix | >= 1.1.0 |

## Assumptions

* if `account_number` is not provided, then `Active` account within given metro
will be used
* most recent, stable version of a device software for a given `software_package`
will be used
* secondary device name will be same as primary with `-secondary` suffix added
* secondary device notification list will be same as for primary
* secondary device interface count will be always same as primary interface count

## Example usage

```hcl
provider equinix {
  client_id     = var.equinix_client_id
  client_secret = var.equinix_client_secret
}

module "versa-flexvnf" {
  source            = "equinix/versa-flexvnf/equinix"
  metro_code        = "SV"
  platform          = "large"
  software_package  = "FLEX_VNF_6"
  name              = "tf-tst-versa"
  term_length       = 1
  notifications     = ["test@test.com"]
  acl_tempalte_id   = "2e365e34-8f38-46e1-9f57-94b075d5dc09"
  interface_count   = 16
  controller_1_ip   = "23.53.61.5"
  controller_2_ip   = "123.53.66.34"
  local_id          = "sdwan@versa.com"
  remote_id         = "controller-01@versa.com"
  serial_number     = "Test1"
  secondary = {
    enabled           = true
    metro_code        = "DC"
    acl_tempalte_id   = "81a90c41-8a22-4724-997c-bdc07f401387"
    controller_1_ip   = "23.53.61.5"
    controller_2_ip   = "123.53.66.34"
    local_id          = "sdwan@versa.com"
    remote_id         = "controller-01@versa.com"
    serial_number     = "Test2"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
|metro_code|Two-letter device location's metro code|`string`|`""`|yes|
|account_number|Billing account number for a device. If not provided, active account for a device metro code will be used|`string`|`0`|no|
|platform|Device hardware platform flavor: `small`, `medium`, `large`|`string`|`""`|yes|
|software_package|Device software package: `FLEX_VNF_2`, `FLEX_VNF_4`, `FLEX_VNF_6`, `FLEX_VNF_16`|`string`|`""`|yes|
|name|Device name|`string`|`""`|yes|
|term_length|Term length in months: `1`, `12`, `24`, `36`|`number`|`0`|yes|
|notifications|List of email addresses that will receive notifications about device|`list(string)`|n/a|yes|
|site_id|Site identifier|`string`|`""`|yes|
|system_ip_address|System IP address|`string`|`""`|yes|
|acl_template_id|Identifier of a network ACL template that will be applied on a device|`string`|`""`|yes|
|additional_bandwidth|Amount of additional internet bandwidth for a device, in Mbps|`number`|`0`|no|
|interface_count|Device interface count: either `10` or `16`|`number`|`10`|no|
|controller_1_ip|IP address for SDWAN controller 1|`string`|`""`|yes
|controller_2_ip|IP address for SDWAN controller 2|`string`|`""`|yes
|local_id|Local identifier from Versa configuration in email format"|`string`|`""`|yes
|remote_id|Remote identifier from Versa configuration in email format"|`string`|`""`|yes
|serial_number|Device serial number"|`string`|`""`|yes
|secondary|Map of secondary device attributes in redundant setup|`map`|N/A|no|

Secondary device map attributes:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
|enabled|Value that determines if secondary device shall be created|`bool`|`false`|no|
|metro_code|Two-letter secondary device location's metro code|`string`|`""`|yes|
|account_number|Billing account number for a device. If not provided, active account for a device metro code will be used|`string`|`0`|no|
|license_file|Path to the device license configuration fil|`string`|`""`|yes|
|site_id|Site identifier|`string`|`""`|yes|
|system_ip_address|System IP address|`string`|`""`|yes|
|acl_template_id|Identifier of a network ACL template that will be applied on a secondary device|`string`|`""`|yes|
|additional_bandwidth|Amount of additional internet bandwidth for a secondary device, in Mbps|`number`|`0`|no|
|controller_1_ip|IP address for SDWAN controller 1|`string`|`""`|yes
|controller_2_ip|IP address for SDWAN controller 2|`string`|`""`|yes
|local_id|Local identifier from Versa configuration in email format"|`string`|`""`|yes
|remote_id|Remote identifier from Versa configuration in email format"|`string`|`""`|yes
|serial_number|Device serial number"|`string`|`""`|yes

## Outputs

| Name | Description |
|------|-------------|
|id|Device identifier|
|status|Device provisioning status|
|license_status|Device license status|
|account_number|Device billing account number|
|cpu_count|Number of device CPU cores|
|memory|Amount of device memory|
|software_version|Device software version|
|region|Device region|
|ibx|Device IBX center code|
|ssh_ip_address|Device SSH interface IP address|
|ssh_ip_fqdn|Device SSH interface FQDN|
|interfaces|List of network interfaces present on a device|
|secondary|Secondary device outputs (same as for primary). Present when secondary device was enabled|
