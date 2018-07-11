#Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
#Dóna accés denegat

#Simple Screen Recorder
add-apt-repository -y ppa:maarten-baert/simplescreenrecorder
apt update
#Cal en Ubuntu 18.04??
apt-get -y purge aisleriot gnome-sudoku gnome-mines gnome-mahjongg

apt-get install -y  wireshark audacity lame libmp3lame0 blender p7zip-full p7zip-rar
#wireshark pregunta si usuaris nonsudo poden capturar paquets ..resposta es yes pero ja no és silent
apt-get install -y  codeblocks dia epoptes-client fritzing dmidecode libxml-simple-perl libcompress-raw-zlib-perl 
apt-get install -y  libnet-ip-perl libwww-perl libdigest-md5-perl libnet-ssleay-perl  libcrypt-ssleay-perl libnet-snmp-perl libproc-pid-file-perl libproc-daemon-perl
apt-get install -y  net-tools libsys-syslog-perl pciutils smartmontools read-edid nmap  geany gimp
#postfix configuration demana quin correu usar local o internet
apt-get install -y  inkscape keymon mingw32 nmap shutter vim-gnome rst2pdf scribus ntp traceroute
#ningw32 no troba
apt-get install -y  python-virtualenv byobu virtualbox git kdenlive kexi python-pip vim docutils-common
###FINS AQUí PROVAT

##PacketTracer
wget http://192.168.0.12/coord/PacketTracer70_64bit_linux.tar.gz -O /tmp/PacketTracer70_64bit_linux.tar.gz
tar xvzf /tmp/PacketTracer70_64bit_linux.tar.gz
## desempaquetar
sed -i 's/read input/input=Y/g' PacketTracer70/install 
sed -i 's/read cont//g' PacketTracer70/install 
sed -i 's/read -p/echo/g' PacketTracer70/install 
sed -i 's/`dirname $_`/PacketTracer70/g' PacketTracer70/install 
PacketTracer70/install

## #23 netbeans
## descàrrega de les respostes de l'instalador
wget https://goo.gl/oGuAxQ -O state.xml
wget http://download.netbeans.org/netbeans/8.0.2/final/bundles/netbeans-8.0.2-linux.sh -O netbeans.sh
chmod a+x netbeans.sh
./netbeans.sh --silent --state state.xml



## chrome (2017)
apt-get install -y google-chrome-stable 
## #40 wireshark

echo "wireshark-common	wireshark-common/install-setuid	boolean	false" | debconf-set-selections
apt-get install -q -y wireshark-common
groupadd wireshark
## (LDAP matter) sudo usermod -a -G wireshark YOUR_USER_NAME
chgrp wireshark /usr/bin/dumpcap
chmod 750 /usr/bin/dumpcap
setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
getcap /usr/bin/dumpcap

# vagrant
##wget https://releases.hashicorp.com/vagrant/1.8.5/vagrant_1.8.5_x86_64.deb -O /tmp/vagrant_1.8.5_x86_64.deb
wget http://192.168.0.12/coord/vagrant_1.8.5_x86_64.deb -O /tmp/vagrant_1.8.5_x86_64.deb
dpkg -i /tmp/vagrant_1.8.5_x86_64.deb

#sublime
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3
sudo apt-get -y install sublime-text-installer



## cron
echo "15 22 * * * /sbin/shutdown -h now" >> /var/spool/cron/crontabs/root


##post: neteja
apt-get clean | tee -a ${LOG}
apt-get -y autoremove | tee -a ${LOG}

## mod-01
apt-get autoclean | tee -a ${LOG}

##corregir problema repositori google
sed -i 's/^deb/#deb/g' /etc/apt/sources.list.d/google.list

# create debconf answer file
sudo debconf-set-selections <<\EOF
ubridge	ubridge/install-setuid	boolean	true
EOF

sudo add-apt-repository -y ppa:gns3/ppa
sudo apt-get -y update
sudo apt-get -y install gns3-gui

sudo sh -c 'sudo echo "*;*;*;Al0000-2400;audio,cdrom,dialout,floppy,sambashare,vboxusers,xampp,wireshark" >> /etc/security/group.conf'

sudo sh -c 'printf "[Seat:*]\nallow-guest=true\n" >/etc/lightdm/lightdm.conf.d/40-enable-guest.conf'
# Sync and reboot
sync
sleep 3
echo "Tha's all folks"
##reboot


