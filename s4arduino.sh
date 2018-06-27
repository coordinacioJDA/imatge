#Arduino i Scratch
cd
#wget http://192.168.2.94/sources.list
#sudo cp sources.list /etc/apt
#sudo apt-get update
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y libasound2:i386 libsm6:i386 libice6:i386 libpulse-dev:i386
sudo usermod -a -G dialout tecno
sudo usermod -a -G dialout ramon.giraldo
wget http://vps34736.ovh.net/S4A/S4A16.deb
wget http://vps34736.ovh.net/S4A/S4AFirmware15.ino
sudo mv  S4AFirmware15.ino /
sudo chmod a+r S4AFirmware15.ino
wget https://downloads.arduino.cc/arduino-1.8.5-linux64.tar.xz -O arduino.tar.xz
sudo dpkg -i --force-architecture S4A16.deb 
tar -xvf arduino.tar.xz 
sudo mv arduino-1.8.5 /opt
cd /opt/arduino-1.8.5
sudo ./install.sh
