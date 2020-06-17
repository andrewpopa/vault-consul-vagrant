# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  # my home network is 192.168.178.0
  # so I am using public_network
  
  # change to your lan ip, or change to private_network
  
  (1..3).each do |i|
    config.vm.define vm_name="consul#{i}" do |node|
      node.vm.box = "apopa/bionic64"
      node.vm.hostname = vm_name
      node.vm.network "public_network", ip: "192.168.178.#{30+i}", bridge: "wlp0s20f3"
      node.vm.provision "shell", path: "scripts/consul_server.sh"
    end
  end
  
  config.vm.define vm_name="vault" do |node|
    node.vm.box = "apopa/bionic64"
    node.vm.hostname = vm_name
    node.vm.network "public_network", ip: "192.168.178.40", bridge: "wlp0s20f3"
    node.vm.provision "shell", path: "scripts/consul_client.sh"
    node.vm.provision "shell", path: "scripts/vault_server.sh"
    node.vm.provision "shell", path: "scripts/vault_unseal.sh", privileged: false
  end
  
end

