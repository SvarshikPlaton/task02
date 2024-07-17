# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  
  config.vm.define "oracle-linux" do |oracle|
    oracle.vm.box = "generic/oracle9"
    oracle.vm.hostname = "oracle-linux1"
    oracle.vm.network "private_network", ip: "192.168.56.103"
    oracle.vm.network "forwarded_port", guest: 81, host: 81
    oracle.vm.provision "shell", path: "./nginx_script.sh"
  end

  config.vm.define "oracle-linux-copy1" do |oracle|
    oracle.vm.box = "generic/oracle9"
    oracle.vm.hostname = "oracle-linux2" 
    oracle.vm.network "private_network", ip: "192.168.56.101"
    oracle.vm.provision "shell", path: "./apache_script.sh"
  end

  config.vm.define "oracle-linux-copy2" do |oracle|
    oracle.vm.box = "generic/oracle9"
    oracle.vm.hostname = "oracle-linux3" 
    oracle.vm.network "private_network", ip: "192.168.56.102"
    oracle.vm.provision "shell", path: "./apache_script.sh"
  end

end
