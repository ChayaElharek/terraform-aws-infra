variable "project_name"      { type = string }
variable "environment"       { type = string }
variable "instance_type"     { type = string }
variable "ami_id"            { type = string }
variable "subnet_ids"        { type = list(string) }
variable "security_group_id" { type = string }
variable "instance_count"    { type = number; default = 2 }
variable "key_name"          { type = string; default = "" }
