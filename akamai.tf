terraform {
  required_version = "0.14.7"
  required_providers {
    akamai = {
      source = "akamai/akamai"
      version = "1.8.0"
    }
  }
}

locals {
  azure_devops_australiaeast = jsondecode(file("azure_cidr_ranges.json")).azure_cidr_ranges["AzureCloud.australiaeast"].all
}


provider "akamai" {
 edgerc = "~/.edgerc"
 config_section = var.section
}

// define data source to query group details where resources are to be managed
data "akamai_contract" "default" {
 group_name = var.group_name
}

// define data element to querycontract details where resources are to be managed
data "akamai_group" "default" {
    contract_id = data.akamai_contract.default.id
    group_name = var.group_name
}

//Create or update network list
resource "akamai_networklist_network_list" "network_list_DJ" {
  name = var.netListName
  type = var.type
  description = "network list created from terraform"
  list = local.azure_devops_australiaeast
  mode = var.mode
  contract_id = replace(data.akamai_contract.default.id,"ctr_","")
  group_id = replace (data.akamai_group.default.id,"grp_","")
}

//define data element for network list - needed to activate network list
data "akamai_networklist_network_lists" "network_lists" {
  name = var.netListName
  type = var.type
  depends_on = [
       akamai_networklist_network_list.network_list_DJ
    ]
}

//activate network list
resource "akamai_networklist_activations" "activation" {
  network_list_id = data.akamai_networklist_network_lists.network_lists.list[0]
  network = var.env
  notes  = "${var.netListName} - Activated via. terraform at ${timestamp()}"
  notification_emails = var.email
  depends_on = [
       akamai_networklist_network_list.network_list_DJ
    ]
}
