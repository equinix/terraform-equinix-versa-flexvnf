# Equinix Network Edge example: VERSA Networks FlexVNF SD-WAN Edge device

This example shows how to create redundant VERSA Networks FlexVNF SD-WAN edge devices
on Platform Equinix using Equinix Versa FlexVNF SD-WAN Terraform module and
Equinix Terraform provider.

In addition to pair of Versa FlexVNF devices, following resources are being created
in this example:

* two ACL templates, one for each of the device

The devices are created in self managed, bring your own license modes.
Remaining parameters include:

* large hardware platform (8CPU cores, 16GB of memory)
* FLEX_VNF_6 software package
* 16 network interfaces on each device
* remote controllers IP addresses
* local and remote identifiers
* device serial numbers
* 100 Mbps of additional internet bandwidth on each device
