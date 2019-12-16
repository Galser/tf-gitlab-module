output "public_ips" {
  value = "${module.gitlab.public_ips}"
}

output "public_dns" {
  value = "${module.gitlab.public_dns}"
}

