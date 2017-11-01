# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-9"
  config.ssh.forward_agent = true

  config.vm.define "caishen" do |node|
    node.vm.hostname = "caishen"
    node.vm.network "private_network", ip: "10.5.10.10"
    node.vm.synced_folder "caishen/", "/vagrant"
  end

  config.vm.define "kubera" do |node|
    node.vm.hostname = "kubera"
    node.vm.network "private_network", ip: "10.5.10.20"
    node.vm.synced_folder "kubera/", "/vagrant"
  end

  config.vm.define "pokedex" do |node|
    node.vm.hostname = "pokedex"
    node.vm.network "private_network", ip: "10.5.10.100"
    config.vm.synced_folder ".", "/vagrant", disabled: true

    node.vm.provision :ansible do |ansible|
      ansible.limit = "all"
      ansible.playbook = "provisioning/playbook.yml"
      ansible.compatibility_mode = "2.0"
      ansible.host_vars = {
        "caishen" => {"private_ipv4" => "10.5.10.10"},
        "kubera"  => {"private_ipv4" => "10.5.10.20"},
        "pokedex" => {"private_ipv4" => "10.5.10.100"},
      }
    end
  end
end
