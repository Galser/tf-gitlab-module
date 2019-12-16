variable "name" {
  type        = string
  description = "Name for tags and etc"
}
variable "ami" {}
variable "subnet_id" {}
variable "instance_type" {
  default = "m5.large" // ? maybe m5.xlarge
}
variable "security_groups" {}
variable "max_servers" {
  default = "1"
}
# SSL settings
#variable "cert_private_key_pem" {}
#variable "cert_pem" {}
#variable "cert_bundle" {}
# URL where we should send requests

variable "external_url" {
  description = "FQDN for the server, corresponds to EXTERNAL_URL of GtLab"
}

variable "key_name" {
  type        = string
  description = "SSH Key ID  , stored in AWS"
}
variable "key_path" {
  description = "Local SSH key path (private part)"
}
