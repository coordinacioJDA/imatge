export LDAP_SERVER_IP="ldap://192.168.0.16"
export BASE_DN="dc=jda,dc=ins"
export UTILITYS="ldap-utils libpam-ldap libnss-ldapd nscd nslcd"


cat> debconf-ldap-preseed.txt <<EOF
libnss-ldapd:amd64	libnss-ldapd/clean_nsswitch	boolean	false
libnss-ldapd:amd64	libnss-ldapd/nsswitch	multiselect	passwd, group, shadow
libnss-ldapd	libnss-ldapd/clean_nsswitch	boolean	false
libnss-ldapd	libnss-ldapd/nsswitch	multiselect	passwd, group, shadow
ldap-auth-config    ldap-auth-config/ldapns/ldap-server    string    ${LDAP_SERVER_IP}
ldap-auth-config    ldap-auth-config/ldapns/base-dn    string     ${BASE_DN}
ldap-auth-config    ldap-auth-config/ldapns/ldap_version    select    3 
ldap-auth-config    ldap-auth-config/dbrootlogin    boolean    false 
ldap-auth-config    ldap-auth-config/dblogin    boolean    false 
nslcd   nslcd/ldap-uris string  ${LDAP_SERVER_IP} 
nslcd   nslcd/ldap-base string  ${BASE_DN}
EOF


## corregit els permissos a l'hora de crear el directori privat drwx------ (0077)
if [ -f debconf-ldap-preseed.txt ] ;then
    
	cat debconf-ldap-preseed.txt |debconf-set-selections
	apt-get install -y ${UTILITYS}
	auth-client-config -t nss -p lac_ldap
	sed -i '$ i\session required pam_mkhomedir.so skel=/etc/skel umask=0077\' /etc/pam.d/common-session
	update-rc.d nslcd enable
	/etc/init.d/nslcd restart
else  
	echo -e "Where the debconf-ldap-preseed.txt ??\n"
	echo -e "Where the debconf-ldap-preseed.txt ??\n" >> /root/manifest2

fi

## fi ldap -------------------------------------------------

## fer que no apareguen els comptes a la pantalla d'entrada
# +++++++ també evita els missatges d'error
sed -i "s/enabled=1/enabled=0/g" /etc/default/apport
# 
mkdir /etc/lightdm/lightdm.conf.d
# update
wget http://192.168.0.12/coord/50-ubuntu.conf -O /etc/lightdm/lightdm.conf.d/50-override.ubuntu.conf

