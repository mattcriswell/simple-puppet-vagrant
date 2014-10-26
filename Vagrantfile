# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|


  config.vm.provider "virtualbox" do |v|
        v.memory = 1024
    end

  config.vm.define "testnode01" do |testnode|
    #testnode.vm.box = "ubuntu1404-puppet37dm"
    testnode.vm.box = "CentOS-6.4-x86_64-v20131103"
    testnode.vm.hostname = "test-node-01"
    testnode.vm.network "private_network", ip: "192.168.50.10"
    #testnode.vm.box_url = "https://s3.amazonaws.com/dm.vagrantfiles/trusty-server-amd64-puppet-3-7.box"
    testnode.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20131103.box"
    testnode.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "site.pp"
      puppet.module_path = ["puppet/modules"]
      #uncomment if you want/need hiera in your life
      #puppet.hiera_config_path = "puppet/hiera.yaml"
      end
    end
end
