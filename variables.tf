variable "env" {
  type = string
  description = "a variable to hold akamai network name"
  default = "staging"
}
variable "section" {
  type = string
  description = "a variable to hold edgerc section name"
}
variable "netListName" {
  type = string
  description = "a variable to hold netlist name"
}
variable "email" {
  type = list
  default = ["djha@akamai.com"]
}
variable "type" {
  type = string
  description = "a variable to hold netlist type"
}
variable "group_name" {
  type = string
  description = "a variable to hold netlist type"
}
variable "mode" {
  type = string
  description = <<-EOT
                            mode can be APPEND (the addresses or locations listed in [list] will be added to the network list),
                             REPLACE (the addresses or locations listed in [list] will overwrite the current contents of the network list)
                             or REMOVE(the addresses or locations listed in [list] will be removed from the network list)
                  EOT
}
variable "list" {
  type = list
  description = "a variable to hold netlist IP or GEO"
}
