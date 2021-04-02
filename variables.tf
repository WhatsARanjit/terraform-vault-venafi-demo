## AWS stuff
variable "aws_region" {
  default = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS account id required for Vault IAM policy"
}

variable "ssh_key_name" {
  description = "Existing aws key to be associated with Vault and consumer instances"
}

variable "owner_tag" {
  description = "Tag identifying instance owner"
  default     = "vault-aws-test"
}

variable "ttl_tag" {
  description = "TTL tracking tag for custom management"
  default     = "24h"
}

variable "ami_id" {
  description = "ID of the AMI to provision. Default is Ubuntu 14.04 Base Image"
  default     = "ami-2e1ef954"
}

variable "instance_type" {
  description = "type of EC2 instance to provision."
  default     = "t2.micro"
}

variable "vault_iam" {
  default = "vault"
}

## Venafi settings
# Auth information
variable "tpp_url" {
  description = "Venafi Trust Protection Platform URL (e.g. https://tpp.venafi.example:443/vedsdk)"
}

variable "policy_folder" {
  description = "Zone ID for Venafi Cloud or policy folder for Venafi Platform"
}

# App information
variable "app_name" {
  description = "The name of the NGINX application to deploy"
}

variable "certificate_san" {
  description = "The domain of the certificate SAN"
  default     = "venafidemo.com"
}

## Vault secrets
# Secret
variable "supersecret" {
  description = "Secret to be displayed on the home page of app"
  default     = "this_is_secret"
}
