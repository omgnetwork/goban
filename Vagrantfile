# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# Configurations
#

cfg_file = File.join(Dir.pwd, ".git", "goban", "config")
cfg      = {}

if File.exists?(cfg_file)
  File.readlines(cfg_file).each do |line|
    key, value = line.split('=', 2)
    cfg[key]   = value
  end
end

VAGRANT_NFS          = ENV["VAGRANT_NFS"] || cfg["VAGRANT_NFS"]
VAGRANT_VNC_PASSWORD = ENV["VAGRANT_VNC_PASSWORD"] || cfg["VAGRANT_VNC_PASSWORD"]


#
# Vagrant boxes
#

synced_folder_args = {}

if (VAGRANT_NFS =~ /^(1|y|t)/) != nil
  synced_folder_args[:type]          = "nfs"
  synced_folder_args[:mount_options] = ["actimeo=2"]
end

Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-9"
  config.ssh.forward_agent = true

  config.vm.define "ewallet" do |node|
    node.vm.hostname = "ewallet"
    node.vm.network "private_network", ip: "10.5.10.10"
    node.vm.synced_folder "ewallet/", "/vagrant", synced_folder_args

    node.vm.provision :ansible do |ansible|
      ansible.limit              = "all"
      ansible.config_file        = "provisioning/ansible.cfg"
      ansible.playbook           = "provisioning/playbook.yml"
      ansible.playbook_command   = ENV["ANSIBLE_CMD"] || "ansible-playbook"
      ansible.skip_tags          = ENV["ANSIBLE_SKIP"]&.split
      ansible.tags               = ENV["ANSIBLE_TAGS"]&.split
      ansible.compatibility_mode = "2.0"
      ansible.host_vars          = {
        "ewallet" => {"private_ipv4" => "10.5.10.10"},
      }
    end
  end

  config.vm.provider "virtualbox" do |vb|
    unless VAGRANT_VNC_PASSWORD.nil?
      vb.customize [
        "modifyvm",
        :id,
        "--vrdeproperty",
        "VNCPassword=#{VAGRANT_VNC_PASSWORD}"
      ]
    end
  end
end
