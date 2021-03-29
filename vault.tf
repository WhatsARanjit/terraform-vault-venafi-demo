terraform {
  required_version = ">= 0.11.0"
}

provider "aws" {
  region = "${var.aws_region}"
}

module "vault_config" {
  source         = "./modules/templates/vault"
  aws_account_id = "${var.aws_account_id}"
}

module "vault" {
  source        = "./modules/ec2"
  aws_region    = "${var.aws_region}"
  name_prefix   = "vault-server"
  ssh_key_name  = "${var.ssh_key_name}"
  owner_tag     = "${var.owner_tag}"
  ttl_tag       = "${var.ttl_tag}"
  ami_id        = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  user_data     = "${module.vault_config.vault_user_data}"

  iam_instance_profile_name = "${var.vault_iam}"
}

output "vault_ip" {
  value = "export VAULT_ADDR=http://${module.vault.ip}:8200"
}
