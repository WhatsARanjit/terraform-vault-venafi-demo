#!/bin/bash
 
apt-get install --yes jq

VAULT_ADDR=http://${vault_addr}:8200
PKCS7=$(curl http://169.254.169.254/latest/dynamic/instance-identity/pkcs7)

echo "{
        \"role\": \"aws-demo-role-ec2\",
        \"pkcs7\": \"$PKCS7\",
        \"nonce\": \"1234\" 
}" > payload.json


VAULT_TOKEN=$(curl \
    --request POST \
    --data @payload.json \
    $VAULT_ADDR/v1/auth/aws/login | jq -r .auth.client_token)

SECRET=$(curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    $VAULT_ADDR/v1/kv1/aws_demo | jq -r .data.value)

echo "Secret retrieved from Vault: $SECRET"


# NGINX app stuff
apt-get update --yes
apt-get install --yes nginx
mkdir -p /var/www
echo -e "${nginxconf}" > /etc/nginx/sites-enabled/default
echo -e "${index_page}" >> /var/www/index.html
echo "$SECRET" >> /var/www/index.html
echo -e "${stylesheet}" >> /var/www/styles.css
mkdir -p /etc/nginx/ssl
echo -e "${certificate}" >> /etc/nginx/ssl/certificate.pem
echo -e "${privatekey}" >> /etc/nginx/ssl/privatekey.pem
service nginx restart
service nginx restart
