# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "raring"
  config.vm.box_url = "http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg-vagrant-amd64-disk1.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080

  # Salt configuration
  config.vm.synced_folder "salt/roots/", "/srv/salt/"

  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    vb.gui = true

    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  # Provision with salt
  config.vm.provision :salt do |salt|

    salt.minion_config = "salt/minion"
    salt.run_highstate = true

  end

end