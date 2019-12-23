Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.define :mariadb_local do |web_config|
    web_config.vm.network "private_network", ip: "192.168.10.46"
    web_config.vm.provision :shell, :inline => 'sudo apt-get update && sudo apt-get install -y puppet'
    web_config.vm.provision :puppet do |puppet|
      puppet.manifest_file = "web.pp"
    end
  end
  config.vm.provider :virtualbox do |vb|
    vb.memory = 2048
    vb.cpus = 2
    vb.name = "mariadb-local"
  end
end