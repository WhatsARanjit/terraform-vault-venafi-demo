data "template_file" "vault_init_config" {
  template = "${file("${path.module}/vault_init_config.sh.tpl")}"
}
