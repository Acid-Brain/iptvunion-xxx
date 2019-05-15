#!/bin/bash
sudo apt install -y --force-yes lsb-core 
clear
sleep 1
echo -e "$(tput setaf 6)Welcome to IPTVUnion Installation$(tput sgr0)"
echo -e "$(tput setaf 5)www.iptvunion.tv$(tput sgr0)"
sleep 3
osname=$(lsb_release -si)
osrelease=$(lsb_release -sr)
oscodename=$(lsb_release -sc) 
osDisc=$(lsb_release -sd)
arch=$(uname -m)
File=/etc/apt/sources.list
echo -e "$(tput setaf 1)Your System is $osname $osrelease - $arch $(tput sgr0)"
echo ""
##############################################################################
read -p "Please enter a password for your MySQL : " mysqlpassword
(mysql -uroot -p$mysqlpassword -e "CREATE DATABASE iptvunion"  2> /dev/null);
echo -n "1. [password for your MySQL:] "
echo -n " [############"
RESULT=`mysqlshow --user=root --password=$mysqlpassword mysql | grep -v Wildcard | grep -o mysql `
if [ "$RESULT" == "mysql" ]; then 
echo -e "]$(tput setaf 2)Successful$(tput sgr0)"
sleep 2
##############################################################################
echo -n "2. [Distribution Detection:] "
echo -n "  [############"
if [ "$osname" == "Ubuntu"  ]; then
echo -e "]$(tput setaf 2)Successful$(tput sgr0)"
else
echo -e "]$(tput setaf 1)Failed$(tput sgr0)"
exit 3
fi
sleep 2
##############################################################################
echo -n "3. [Arch Detection: ] "
echo -n "         [############"
if [ "$arch" == "x86_64"  ]; then
echo -e "]$(tput setaf 2)Successful$(tput sgr0)"
else
echo -e "]$(tput setaf 1)Failed$(tput sgr0)"
exit 3
fi
sleep 2
##############################################################################
echo -n "4. [Installing needed files:] "
echo -n " [#"
(apt-get install -y --force-yes update > /dev/null 2>&1);
echo -n "#";  
(apt-get install -y --force-yes dist-upgrade > /dev/null 2>&1);
echo -n "#";
(apt-get install -y --force-yes libxslt1-dev git > /dev/null 2>&1);
echo -n "#";
(apt-get install -y libmcrypt-dev > /dev/null 2>&1);
echo -n "#";
(apt-get install -y --force-yes libmcrypt-dev > /dev/null 2>&1);
echo -n "#";
(apt-get install -y libjpeg8 > /dev/null 2>&1);
echo -n "#";
(apt-get install -y --force-yes libcurl4-openssl-dev > /dev/null 2>&1);
echo -n "#";
(apt-get install -y --force-yes libssh2-1-dev > /dev/null 2>&1);
echo -n "#";
(apt-get install -y --force-yes libpq-dev > /dev/null 2>&1);
echo -n "#";
echo -n "#";
(apt-get install -y --force-yes nload > /dev/null 2>&1);
echo -n "#";
echo -e "]$(tput setaf 2)Successful$(tput sgr0)"
sleep 2
##############################################################################
echo -n "5. [IPTVUnion Installation:] "
echo -n "  [#"
sleep 2
(killall -9 php-fpm-iptvunion nginx-iptvunion > /dev/null 2>&1)
(/usr/sbin/userdel -f iptvunion  2> /dev/null);
echo -n "#";
(/bin/rm -r /home/iptvunion > /dev/null 2>&1)
echo -n "#";
(/usr/sbin/useradd -s /sbin/nologin -U -d /home/iptvunion -m iptvunion 2> /dev/null);
echo -n "#";
(wget http://host/iptvunion.tar.gz -P /home/iptvunion > /dev/null 2>&1)
(tar -zxvf /home/iptvunion/iptvunion.tar.gz -C /home/iptvunion/ > /dev/null 2>&1);
echo -n "#";
(rm -r  /home/iptvunion/iptvunion.tar.gz); 
echo -n "#";
echo -n "#";
sed -i 's/xxx/'$mysqlpassword'/g' /home/iptvunion/www/controllers/config.php 
echo -n "#";
#mysql -u uroot -p -D iptvunion -e "DROP DATABASE iptvunion"
#mysql -uroot -p$mysqlpassword -e "CREATE DATABASE iptvunion"
echo -n "#";
mysql -uroot -p$mysqlpassword iptvunion < /home/iptvunion/iptvunion.sql > /dev/null 2>&1
echo -n "#";
( chmod 755 /home/iptvunion/iptvunion /dev/null 2>&1  )
(mv /home/iptvunion/iptvunion  /etc/init.d/ )
( chmod 755  /etc/init.d/iptvunion )
( update-rc.d iptvunion defaults > /dev/null 2>&1 )
echo -n "#";
(rm -r  /home/iptvunion/iptvunion.sql); 
echo -n "#";
(service iptvunion restart > /dev/null 2>&1 );
echo -e "]$(tput setaf 2)Successful$(tput sgr0)"
echo ""
echo "$(tput setaf 6)[+] ##################################################[+]$(tput sgr0)"
echo  "$(tput setaf 5)IPTVUNION Installed.. $(tput sgr0)"
echo ""
echo  "$(tput setaf 6)Login: http://host:9821'$(tput sgr0)"
echo  "$(tput setaf 2)Username: admin$(tput sgr0)"
echo  "$(tput setaf 2)Password: admin $(tput sgr0)"
echo ""
echo  "$(tput setaf 3)Stop  Panel : service iptvunion stop $(tput sgr0)"
echo  "$(tput setaf 3)Start Panel : service iptvunion start $(tput sgr0)"
echo  "$(tput setaf 1)IMPORTANT: After you logged in, go to settings and check your host. $(tput sgr0)   "
echo "$(tput setaf 6)[+] ##################################################[+]$(tput sgr0)"
echo ""
else
echo -e "]$(tput setaf 1)The Password is incorrect$(tput sgr0)"
sleep 5
./iptvunion.sh
fi
exit 3