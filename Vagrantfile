# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-9"

  config.vm.define "caishen" do |node|
    node.vm.hostname = "caishen"
    node.vm.network "private_network", ip: "10.5.10.10"
    node.vm.synced_folder "caishen/", "/vagrant"
  end

  config.vm.define "kubera" do |node|
    node.vm.hostname = "kubera"
    node.vm.network "private_network", ip: "10.5.10.20"
    node.vm.synced_folder "kubera/", "/vagrant"

    node.vm.provision :ansible do |ansible|
      ansible.limit = "all"
      ansible.playbook = "provisioning/playbook.yml"
      ansible.compatibility_mode = "2.0"
    end
  end
end
