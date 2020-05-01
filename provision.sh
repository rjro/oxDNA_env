#!/bin/bash
export DEBIAN_FRONTEND="noninteractive"

#for now, we're not going to install mysql with a password
#debconf-set-selections <<< 'mysql-server mysql-server/root_password password mysqlpass' 
#debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password mysqlpass'

apt-get update
apt-get -y install cmake python3-pip build-essential slurm-llnl mysql-server

#install oxdna
cd /opt
mkdir oxdna-cpu-only && cd oxdna-cpu-only
wget -O oxdna.tgz https://sourceforge.net/projects/oxdna/files/latest/download
tar -xvzf oxdna.tgz
rm oxdna.tgz
cd oxDNA
mkdir build && cd build
cmake ..
make -j4

#setup slurm
cd /vagrant
cp slurm.conf /etc/slurm-llnl
slurmd
slurmctld


#setup mysql
#need to be in /vagrant path for sql_setup.sql
cd /vagrant
echo "[mysqld]" >> /etc/mysql/my.cnf
echo "bind-address = 0.0.0.0" >> /etc/mysql/my.cnf
service mysql restart

echo "now setting mySQL authentication"
mysql -Bse "USE mysql; UPDATE user SET plugin='mysql_native_password' WHERE User='root'; FLUSH PRIVILEGES;"
mysql -Bse "CREATE USER 'root'@'%'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'; FLUSH PRIVILEGES";
#mysql -Bse "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'; FLUSH PRIVILEGES;"
mysql -Bse "CREATE DATABASE azdna CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mysql -Bse "source sql_setup.sql"
service mysql restart

#install python dependencies
pip3 install mysql-connector bcrypt flask biopython pathos yagmail

cd /vagrant
git clone https://github.com/rjro/azDNA.git
git clone https://github.com/sulcgroup/oxdna_analysis_tools
cd azDNA

#create admin account
#python3 Provision.py

mkdir /users
