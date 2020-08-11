Vagrant.configure("2") do |config|
	config.vm.define "oxdna-web"
	config.vm.provision :shell, path: "provision.sh"
	config.vm.provision :shell, path: "reboot.sh", run: 'always'
	config.vm.box = "ubuntu/xenial64"
	# config.vm.network "forwarded_port", guest: 80, host: 80
	config.vm.network "forwarded_port", guest: 3306, host: 3306
	config.vm.network "forwarded_port", guest: 9000, host: 9000
	config.vm.network "forwarded_port", guest: 9001, host: 9001
	config.vm.provider "virtualbox" do |v|
		v.memory = 1024
		v.cpus = 2
		v.name = "oxdna-web_test"
	end
end