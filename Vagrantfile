# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|


  config.vm.provider "virtualbox" do |v|
        v.memory = 1024
    end

  config.vm.define "testnode01" do |testnode|
    testnode.vm.box = "CentOS7"
    testnode.vm.hostname = "test-node-01"
    testnode.vm.box_url = "https://dl.dropboxusercontent.com/s/srw2tqh58507wik/CentOS7.box"
    testnode.vm.network "forwarded_port", guest: 80, host: 8080
    #testnode.vm.share_folder "PuppetFiles", "/etc/puppet/files", "./files"
    testnode.vm.synced_folder "files/", "/etc/puppet/files"
    testnode.vm.provision "puppet" do |puppet|
      puppet.options = ["--fileserverconfig=/vagrant/fileserver.conf"]
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "site.pp"
      puppet.module_path = ["puppet/modules"]
      #uncomment if you want/need hiera in your life
      #puppet.hiera_config_path = "puppet/hiera.yaml"
      end
    end
end
