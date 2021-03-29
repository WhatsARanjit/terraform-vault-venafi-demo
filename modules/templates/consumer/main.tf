data "template_file" "user_data" {
  template = "${file("${path.module}/consumer_install.sh.tpl")}"

  vars = {
    vault_addr  = "${var.vault_addr}"
    certificate = "${var.certificate}"
    privatekey  = "${var.privatekey}"
    index_page  = "${file("files/index.html")}"
    stylesheet  = "${file("files/styles.css")}"
    nginxconf   = "${file("files/00-default")}"
  }
}
