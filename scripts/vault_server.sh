#!/usr/bin/env bash

set -x

which curl wget unzip jq &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo pt-get install --no-install-recommends -y curl wget unzip jq
}

VAULT=$(curl -sL https://releases.hashicorp.com/vault/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)

which vault &>/dev/null || {

  which curl wget unzip jq &>/dev/null || {
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get update
    sudo apt-get install --no-install-recommends -y curl wget unzip jq
  }

  echo Installing vault ${VAULT}
  wget https://releases.hashicorp.com/vault/${VAULT}/vault_${VAULT}_linux_amd64.zip
  unzip vault_${VAULT}_linux_amd64.zip
  sudo mv vault /usr/local/bin/
  vault -autocomplete-install
  sudo setcap cap_ipc_lock=+ep /usr/local/bin/vault
  sudo useradd --system --home /etc/vault.d --shell /bin/false vault
  sudo cp /vagrant/conf/vault.service /etc/systemd/system/vault.service
  sudo mkdir -p /etc/vault
  sudo cp /vagrant/conf/vault_server.hcl /etc/vault/vault_server.hcl
  sudo sed -i "s/localhost/$(hostname -I | awk '{print $2}')/g" /etc/vault/vault_server.hcl
  sudo systemctl enable vault
  sudo systemctl start vault
  export VAULT_ADDR=http://127.0.0.1:8200
  vault status
}
