# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vbguest.auto_update = false
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["setextradata", :id, "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled", 0]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  config.vm.define "frontend" do |server|
    server.vm.network "private_network", ip: "192.168.33.21"
    server.vm.synced_folder "./frontend", "/home/vagrant/approot"
    server.vm.provision :shell,
      inline: "sudo -iu vagrant mkdir -p /home/vagrant/mount_point/node_modules"
      server.vm.provision :shell,
      inline: "mount --bind /home/vagrant/mount_point/node_modules /home/vagrant/approot/node_modules -o uid=1000,gid=1000",
      run: "always"
    server.vm.provision :shell, path: "./vagrant/frontend.sh"
  end
  config.vm.define "frontend_old", primary: false do |server|
    server.vm.network "private_network", ip: "192.168.33.21"
    server.vm.synced_folder "./frontend_old", "/home/vagrant/approot"
    server.vm.provision :shell,
      inline: "sudo -iu vagrant mkdir -p /home/vagrant/mount_point/node_modules"
      server.vm.provision :shell,
      inline: "mount --bind /home/vagrant/mount_point/node_modules /home/vagrant/approot/node_modules -o uid=1000,gid=1000",
      run: "always"
    server.vm.provision :shell, path: "./vagrant/frontend.sh"
  end
  config.vm.define "backend" do |server|
    server.vm.network "private_network", ip: "192.168.33.22"
    server.vm.synced_folder "./backend", "/home/vagrant/approot"
    server.vm.provision :shell, path: "./vagrant/backend.sh"
  end
end
