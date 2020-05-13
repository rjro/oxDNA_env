cd /vagrant/azDNA
#pull latest changes
git pull
pwd
#python3 main.py > server_output.log 2>&1 &
echo "Server now ready at :9000!"
echo "do vagrant ssh; cd /vagrant/azDNA; ./vagrant_restart.sh; to start the server" 
