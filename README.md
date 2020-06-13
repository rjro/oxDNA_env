# azDNA_env
Welcome, this repository sets up a  developer environment for working on [azDNA](https://github.com/rjro/azDNA). This developer environment is provisioned into a containerized VirtualBox by using [Vagrant](https://www.vagrantup.com/). If you are familiar with Vagrant, clone, vagrant up, and you're good to go. 

Important files to take a look at would be
- [Vagrantfile](/Vagrantfile): the file which will be used to setup the Vagrant box
- [provision.sh](/provision.sh): a script for installing all libraries and frameworks upon first launch
- [sql_setup.sql](/sql_setup.sql): a SQL script used to initialize the MySQL database running on the server

# Setup
In order to get setup, follow these steps:

1. Installl [Vagrant](https://www.vagrantup.com/downloads)

	> Vagrant is a "wrapper" around virtualization providers like VirtualBox to make provisioning VMs easier. We will be using Vagrant and Virtualbox to create a sandboxed ubuntu machine to host the azDNA application. 
2. Install Virtualbox (https://www.virtualbox.org/wiki/Downloads)
	> Virtualbox will be used to actually containerize the application. Please ensure that the hardware you will using supports virtualization. On Intel, this is typically VT-d or VT-x, on, AMD, this is AMD-V. [You may need to enable this in your BIOS.](https://docs.fedoraproject.org/en-US/Fedora/13/html/Virtualization_Guide/sect-Virtualization-Troubleshooting-Enabling_Intel_VT_and_AMD_V_virtualization_hardware_extensions_in_BIOS.html)
	> Virtualbox will be used to actually containerize the application. Please ensure that the hardwar you will using supports virtualization. On Intel this is typically a setting called [You may need to enable these in your BIOS.]

3. Go to the directory you would like to keep the project in, and clone the repository.  
	> ```git clone https://github.com/rjro/azDNA_env ```

4. Go to the newly-cloned azDNA_env directory, and use vagrant to start up the machine. Vagrant will parse the "Vagrantfile" in the directory and use that to provision the machine.
	> ```cd azDNA_env; vagrant up```

5. Give the machine a few minutes to finish provisioning. It needs to download an extensive set of libraries and frameworks. Once it's done, you will see a message in your terminal to indicate that server has launched.
	> azDNA: Server now ready at :9000!

6. You can now visit http://localhost:9000 and use the server as desired.

### NOTE: Binding to port 9000 is default behavior, but does not allow you to use nginx (which runs on port 80). [See below](#why-cant-i-see-simulation-outputs) for how to bind to port 80.

# FAQ

## Why can't I see simulation outputs?

This is because simulation outputs, and static files, are supposed to be served by [Nginx](https://www.nginx.com/). The nginx configuration can be found in [nginx.conf](nginx.conf). Let's take a look at a few lines from the file.

```
...

27:         server 127.0.0.1:9000;

...

38: 	        listen 80;

...

40:		location ^~ /userfiles/ {
41:			alias /users/;
42:			#autoindex on;
43:		}

...

46:        location ^~ /static/  {
47:            root /vagrant/azDNA/;
48:     }

...
```

Nginx is being used to forward port 80 to port 9000, which is the port which python3 (or in production: [gunicorn](https://gunicorn.org/)) will be serving the Python application on. 

Nginx forwards *most* requests to port 9000, besides requests for ```/userfiles/``` and ```/static/```. These file paths are intercepted and resolved by nginx, because nginx is better at serving large files than gunicorn. 

Nginx runs on port 80, but Vagrant can't directly expose port 80 to your base machine, unless you run the Virtualbox as root. There are security issues surrounding this, and it's not recommended. 

Instead, you can use SSH to create a tunnel to the machine and forward port 80 from your machine to the Vagrant box. See below for how to do this.

```bash 
#use the vagrant SSH command directly
vagrant ssh -- -gNL 80:localhost:80

#OR

#use the helper script 
sh forward_port_80.sh
```

## How do I actually make code changes?

The [azDNA repository](https://github.com/rjro/azDNA) will be cloned into the azDNA directory. You can open up this folder in your favorite editor and begin making changes, there is no need to make any modifications from within the Vagrant box. 

This is because the ```/vagrant``` folder within the Vagrant box is actually the ```azDNA_env``` folder on your computer. This directory is forwarded by Vagrant automatically.

## How do I observe changes I make to the server?
When you launch the server by default, it will start listening on port 9000. If you make changes to server-side logic, you will have to restart the server to observe them.

You will need to use SSH into the server, kill the python3 listener, and restart the server. This can be done as follows:

```bash
#Go to the root directory of azDNA_env
cd azDNA_env

#Use this vagrant helper command to SSH into the vagrant box
vagrant ssh 

#Kill the server, we can use pkill to kill any python3 processes, the server should be one of these.
pkill python3

#If the server still didn't die, let's kill whatever is on port 9000
lsof -t -i tcp:9000 | xargs kill

#Navigate to where the code for the azDNA application is held
cd /vagrant/azDNA

#Start the application
python3 main.py
```