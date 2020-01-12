Vagrant.configure("2") do |config|
	config.vm.define "azDNA"
	config.vm.provision :shell, path: "provision.sh"
	config.vm.provision :shell, path: "reboot.sh", run: 'always'
	config.vm.box = "ubuntu/xenial64"
	config.vm.network "forwarded_port", guest: 3306, host: 3306
	config.vm.network "forwarded_port", guest: 9000, host: 9000
	config.vm.provider "virtualbox" do |v|
		v.memory = 1024
		v.cpus = 2
		v.name = "azDNA_test"
	end
end