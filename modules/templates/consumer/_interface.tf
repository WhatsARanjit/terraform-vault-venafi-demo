variable "vault_addr" {}

variable "certificate" {}
variable "privatekey" {}

output "user_data" {
  value = data.template_file.user_data.rendered
}
