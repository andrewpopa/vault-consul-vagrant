# -*- mode: ruby -*-
# vi: set ft=ruby :

vagrant_assets = File.dirname(__FILE__) + "/"

Vagrant.configure("2") do |config|
  (1..3).each do |i|
    config.vm.define vm_name="consul#{i}" do |node|
      node.vm.box = "apopa/bionic64"
      node.vm.hostname = vm_name
      node.vm.network "public_network", ip: "192.168.178.3#{i}"
      node.vm.provision "shell", path: "#{vagrant_assets}/scripts/consul_server.sh", privileged: true
    end
  end
  config.vm.define vm_name="vault" do |node|
    node.vm.box = "apopa/bionic64"
    node.vm.hostname = vm_name
    node.vm.network "public_network", ip: "192.168.178.40"
    node.vm.provision "shell", path: "#{vagrant_assets}/scripts/consul_client.sh", privileged: true
    node.vm.provision "shell", path: "#{vagrant_assets}/scripts/vault_server.sh", privileged: true
  end
end

