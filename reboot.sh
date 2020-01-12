cd /vagrant/azDNA
#pull latest changesi
git pull
python3 main.py > server_output.log 2>&1 &
echo "Server now alive at :9000!"