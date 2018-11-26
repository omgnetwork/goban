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
# Vagrant box
#

synced_folder_args = {}

if (VAGRANT_NFS =~ /^(1|y|t)/) != nil
  synced_folder_args[:type]          = "nfs"
  synced_folder_args[:mount_options] = ["actimeo=2"]
end

Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-9"
  config.vm.hostname = "ewallet"
  config.vm.network "private_network", ip: "10.5.10.10"

  # In case ewallet/ is a link, we want to /vagrant/ewallet to be available
  # as an actual folder rather than a link. We also do not want to expose
  # .vagrant/.git/etc. in Vagrant.
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "ewallet", "/vagrant/ewallet", synced_folder_args

  config.vm.provision :shell, privileged: true, path: "provisioning/bootstrap.sh"
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
