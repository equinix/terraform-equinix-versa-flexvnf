provider "equinix" {
  client_id     = var.equinix_client_id
  client_secret = var.equinix_client_secret
}

module "versa-flexvnf" {
  source               = "equinix/versa-flexvnf/equinix"
  name                 = "tf-versa"
  metro_code           = var.metro_code_primary
  platform             = "large"
  software_package     = "FLEX_VNF_6"
  term_length          = 1
  notifications        = ["test@test.com"]
  interface_count      = 16
  additional_bandwidth = 100
  acl_template_id      = equinix_network_acl_template.versa-pri.id
  controller_1_ip      = "23.53.61.5"
  controller_2_ip      = "123.53.66.34"
  local_id             = "sdwan@versa.com"
  remote_id            = "controller-01@versa.com"
  serial_number        = "Test1"
  secondary = {
    enabled              = true
    metro_code           = var.metro_code_secondary
    additional_bandwidth = 150
    acl_template_id      = equinix_network_acl_template.versa-sec.id
    controller_1_ip      = "23.53.61.5"
    controller_2_ip      = "123.53.66.34"
    local_id             = "sdwan@versa.com"
    remote_id            = "controller-01@versa.com"
    serial_number        = "Test1"
  }
}

resource "equinix_network_acl_template" "versa-pri" {
  name        = "tf-versa-pri"
  description = "Primary Versa FlexVNF ACL template"
  metro_code  = var.metro_code_primary
  inbound_rule {
    subnets  = ["193.39.0.0/16", "12.16.103.0/24"]
    protocol = "TCP"
    src_port = "any"
    dst_port = "22"
  }
}

resource "equinix_network_acl_template" "versa-sec" {
  name        = "tf-versa-sec"
  description = "Secondary Versa FlexVNF ACL template"
  metro_code  = var.metro_code_secondary
  inbound_rule {
    subnets  = ["193.39.0.0/16", "12.16.103.0/24"]
    protocol = "TCP"
    src_port = "any"
    dst_port = "22"
  }
}
