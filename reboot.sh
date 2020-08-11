cd /vagrant/oxdna-web
#pull latest changes
git pull
pwd
#python3 main.py > server_output.log 2>&1 &
sh vagrant_restart.sh
echo "Server now ready at :9000!"
#echo "do vagrant ssh; cd /vagrant/oxdna-web; ./vagrant_restart.sh; to start the server" 
