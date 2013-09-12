# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box     = "centos"
  # config.vm.box_url = "http://cloud-images.ubuntu.com/quantal/current/quantal-server-cloudimg-vagrant-i386-disk1.box"
  # config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130427.box"

  # Host localhost:8080 translates to guest localhost:80
  config.vm.network "forwarded_port", guest: 80, host: 8080
  
  # To access virtual box through its own IP, also needed for NFS (host needs to support NFS)
  config.vm.network "private_network", ip: "192.168.56.10"
  
  # IP via DHCP
  # config.vm.network "public_network"

  # Bernie MAC
  # config.vm.base_mac = "080027FB619F"

  config.vm.host_name = "anorgan.dev"

  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    # vb.gui = true

    # vb.customize ["modifyvm", :id, "--memory", "512"]
  end


  # Salt configuration - add ", :nfs => true" for NFS mount
  config.vm.synced_folder "salt/roots/", "/srv/salt/"

  # Provision with salt
  config.vm.provision :salt do |salt|

    salt.minion_config  = "salt/minion"
    salt.run_highstate  = true

    # Debug provisioner
     salt.verbose        = true

  end

end