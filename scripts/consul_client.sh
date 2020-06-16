#!/usr/bin/env bash

set -x

which curl wget unzip jq &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install --no-install-recommends -y curl wget unzip jq
}

CONSUL=$(curl -sL https://releases.hashicorp.com/consul/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)

which consul &>/dev/null || {
  echo Installing vault ${CONSUL}
  wget https://releases.hashicorp.com/consul/${CONSUL}/consul_${CONSUL}_linux_amd64.zip
  unzip consul_${CONSUL}_linux_amd64.zip
  chown root:root consul
  mv consul /usr/local/bin
  consul -autocomplete-install
  complete -C /usr/local/bin/consul consul
  useradd --system --home /etc/consul.d --shell /bin/false consul
  mkdir --parents /opt/consul
  chown --recursive consul:consul /opt/consul
  cp /vagrant/conf/consul_client.service /etc/systemd/system/consul.service
  mkdir --parents /etc/consul.d
  cp /vagrant/conf/consul_client.hcl /etc/consul.d/consul.hcl
  chown --recursive consul:consul /etc/consul.d
  chmod 640 /etc/consul.d/consul.hcl
  systemctl enable consul
  systemctl start consul
  systemctl status consul
}
