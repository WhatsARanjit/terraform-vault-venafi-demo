#!/bin/bash

# Vault variable defaults
export VERSION="0.11.6"
#export URL=https://releases.hashicorp.com/vault/0.10.3/vault_0.10.3_linux_amd64.zip
export GROUP=vault
export USER=vault
export COMMENT=Vault
export HOME="/srv/vault"
export VAULT_ADDR="http://0.0.0.0:8200"
export VAULT_SKIP_VERIFY=true
export VAULT_TOKEN=root

curl https://raw.githubusercontent.com/hashicorp/guides-configuration/master/shared/scripts/base.sh | bash
curl https://raw.githubusercontent.com/hashicorp/guides-configuration/master/shared/scripts/setup-user.sh | bash

sudo apt-get install unzip
curl https://raw.githubusercontent.com/hashicorp/guides-configuration/master/vault/scripts/install-vault.sh | bash

# Since this is dev mode, Vault starts unsealed. DO NOT USE IN PRODUCTION!
nohup /usr/local/bin/vault server -dev \
  -dev-root-token-id="root" \
  -dev-listen-address="0.0.0.0:8200" &

# Enable AWS auth
vault auth enable aws
vault write -f auth/aws/config/client

vault write auth/aws/role/aws-demo-role-ec2 \
  auth_type=ec2 \
  bound_ami_id=${ami_id} \
  policies=aws-demo-policy \
  max_ttl=500h

# Enable secret mount and write secret
echo "path \"kv1/aws_demo\" { 
    capabilities = [\"create\", \"read\", \"update\", \"delete\"]
    }" | vault policy write aws-demo-policy -

vault secrets enable -path=kv1 -version=1 kv

vault write kv1/aws_demo value=${supersecret}
