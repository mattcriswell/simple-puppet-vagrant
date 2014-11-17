simple-puppet-vagrant
=====================

This branch is a PoC of a Vagrant based development environment.  The Vagrantfile will build a CentOS 7 image and then kick off puppet.  Puppet then builds a an Apache + wsgi environment and installs python-flask from EPEL.  files/app/demo.wsgi in this repo is shared to the environment so you can develop on your local environment and see the changes on the dev environment.  127.0.0.1:8080 is mapped to port 80 on the dev environment.  The name of the Vhost is wsgi.example.com so be sure you provide a Host header in curl or update your hosts file if you want to test with a browser.


