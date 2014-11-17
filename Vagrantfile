# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|


config.ssh.username = "vagrant"
config.ssh.password = "vagrant"

  config.vm.provider "virtualbox" do |v|
        v.memory = 1024
    end

  config.vm.define "testnode01" do |testnode|
    testnode.vm.box = "centos7"
    testnode.vm.hostname = "test-node-01"
    ###testnode.vm.box_url = "https://dl.dropboxusercontent.com/s/srw2tqh58507wik/CentOS7.box"
    testnode.vm.box_url = "http://6567e92ad9ed2a5ed39c-eb00062de860fb2c65c43e08c9f3c4e7.r27.cf2.rackcdn.com/centos7.box"
    testnode.vm.network "forwarded_port", guest: 80, host: 8080
    testnode.vm.synced_folder "files/app/", "/var/www/pythonapp/"
    testnode.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "site.pp"
      puppet.module_path = ["puppet/modules"]
      #uncomment if you want/need hiera in your life
      #puppet.hiera_config_path = "puppet/hiera.yaml"
      end
    end
end
