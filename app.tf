# Setup Venafi target
provider "venafi" {
  url  = var.tpp_url
  zone = var.policy_folder
}

# Pull certificate from Venafi
resource "venafi_certificate" "nginx" {
  common_name = "${var.app_name}.${var.certificate_san}"
  san_dns     = [
    "ubuntu.${var.certificate_san}"
  ]
}

module "consumer_config" {
  source      = "./modules/templates/consumer"
  vault_addr  = module.vault.ip
  certificate = venafi_certificate.nginx.certificate
  privatekey  = venafi_certificate.nginx.private_key_pem
}

module "consumer-ec2" {
  source        = "./modules/ec2"
  aws_region    = var.aws_region
  name_prefix   = "vault-consumer"
  ssh_key_name  = var.ssh_key_name
  owner_tag     = var.owner_tag
  ttl_tag       = var.ttl_tag
  ami_id        = var.ami_id
  instance_type = var.instance_type
  user_data     = module.consumer_config.user_data
}

output "app_ip" {
  value = module.consumer-ec2.ip
}

output "app_url" {
  value = "https://${module.consumer-ec2.ip}"
}
