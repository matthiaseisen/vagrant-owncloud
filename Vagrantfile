# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, :path => "mysql.sh", :args => ["owncloud", "owncloud"]
  config.vm.provision :shell, :path => "owncloud.sh"
  config.vm.network "forwarded_port", guest: 80, host: 8031
  config.vm.synced_folder ".", "/vagrant", id: "vagrant-root",
    owner: "vagrant",
    group: "vagrant"
end
