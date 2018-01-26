# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-9"
  config.ssh.forward_agent = true

  config.vm.define "ewallet" do |node|
    node.vm.hostname = "ewallet"
    node.vm.network "private_network", ip: "10.5.10.10"
    node.vm.synced_folder "ewallet/", "/vagrant"

    node.vm.provision :ansible do |ansible|
      ansible.limit = "all"
      ansible.playbook = "provisioning/playbook.yml"
      ansible.compatibility_mode = "2.0"
      ansible.host_vars = {
        "ewallet" => {"private_ipv4" => "10.5.10.10"},
      }
    end
  end
end
