simple-puppet-vagrant
=====================
!!

Very basic puppet &amp; vagrant examples

The basic idea is that you can use this as a simple "template" when doing 
puppet development.


To build a new machine, just type 'vagrant up' in the directory where the Vagrant file 
lives.  Currently the Vagrantfile specifies a CentOS image, but there's an Ubuntu 
image that can be uncommented if you'd rather use that distribution.

To blow away the machine, type 'vagrant destroy'(again in the directory where the
Vagrant file lives).
