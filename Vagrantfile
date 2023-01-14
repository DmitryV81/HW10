# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  #config.vm.box = "generic/centos8s"
  #config.vm.box_version = "v4.2.4"
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
  end
  #config.vm.network "public_network", ip: "192.168.56.10"
  #config.vm.network "forwarded_port", guest:80, host:8080
  config.vm.define "server" do |server|
    #server.vm.network "forwarded_port", guest:80, host:8080
    server.vm.network "private_network", ip: "192.168.50.10",
    virtualbox__intnet: "int1"
    server.vm.hostname = "web"
    #nfss.vm.provision "shell", path: "rpm.sh"
  end
  #config.vm.define "client" do |client|
    #client.vm.network "private_network", ip: "192.168.50.11",
    #virtualbox__intnet: "int1"
    #client.vm.hostname = "client"
  #end
end
