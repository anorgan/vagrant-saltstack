# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

boxes = [
  { :name => :web,   :ip => '192.168.33.10', :ssh_port => 2201, :http_fwd => 9980, :cpus => 1, :memory => 256, :shares => true },
  { :name => :db,    :ip => '192.168.33.20', :ssh_port => 2202, :mysql_fwd => 9936, :cpus => 1, :memory => 256 },
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Defaults
  config.vm.box     = "centos"
  # config.vm.box_url = "http://cloud-images.ubuntu.com/quantal/current/quantal-server-cloudimg-vagrant-i386-disk1.box"
  # config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130427.box"

  # Salt configuration - add ", :nfs => true" for NFS mount
  config.vm.synced_folder "salt/roots/", "/srv/salt/"

  boxes.each do |box|
    config.vm.define box[:name]  do |config|
      config.vm.provider "virtualbox" do |vb|
        vb.gui = true
        vb.customize ["modifyvm", :id, "--memory", box[:memory]] if box[:memory]
        vb.customize ["modifyvm", :id, "--cpus", box[:cpus]] if box[:cpus]
      end

      config.vm.network "forwarded_port", guest: 80, host: box[:http_fwd] if box[:http_fwd]
      config.vm.network "forwarded_port", guest: 22, host: box[:ssh_port]
      config.vm.network "private_network", ip: box[:ip]
      config.vm.host_name ="%s.anorgan.dev" % box[:name].to_s

      # Provision with salt
      config.vm.provision :salt do |salt|

        salt.minion_config  = "salt/minion"
        salt.run_highstate  = true

        # Debug provisioner
        # salt.verbose        = true

      end
    end
  end
end