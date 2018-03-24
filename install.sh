#!/bin/sh
sudo apt-get update && apt-get upgrade -y && apt-get install htop -y
sudo apt-get update && sudo apt-get install vlc vlc-plugin-* -y && sudo apt-get install vlc browser-plugin-vlc -y
sudo apt-get install psmisc
sudo apt-get install unzip
sudo apt-get install unrar
wget https://github.com/MasAries/EZServer/archive/master.zip
sudo unzip EZserver_Nulled_ReConfig_by_MasAries.zip
rm EZserver_Nulled_ReConfig_by_MasAries.zip
cd ezserver
chmod 777 *.*
chmod 777 *
echo 2062780 > /proc/sys/kernel/threads-max
if ! cat /etc/sysctl.conf | grep -v grep | grep -c 1677721600 > /dev/null; then 
echo 'net.core.wmem_max= 1677721600' >> /etc/sysctl.conf
echo 'net.core.rmem_max= 1677721600' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_rmem= 1024000 8738000 1677721600' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_wmem= 1024000 8738000 1677721600' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_window_scaling = 1' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_timestamps = 1' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_sack = 1' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_no_metrics_save = 1' >> /etc/sysctl.conf
echo 'net.core.netdev_max_backlog = 5000' >> /etc/sysctl.conf
echo 'net.ipv4.route.flush=1' >> /etc/sysctl.conf
echo 'fs.file-max=65536' >> /etc/sysctl.conf
sysctl -p
fi
ezgetconfig_image="./ezgetconfig"
#
# 1. Type network interface
#
network_interface_str="network_interface"
network_interface_value=$("$ezgetconfig_image"  $network_interface_str)
rm -rf serial_number.txt
echo "1. Please select network interface (current setting is "$network_interface_value"):"
ifconfig -a -s|cut -d' ' -f1|tail -n +2
read  -p "--> " ni
if test -z $ni; then
ni=$network_interface_value
fi
sedcmd='s/'$network_interface_value'/'$ni'/g'
sed -i $sedcmd ezserver_config.txt
echo "Set Network Interface to "$ni
#
# 2. Type Panel Port
#
http_base_port_str="http_base_port"
http_base_port=$("$ezgetconfig_image"  $http_base_port_str)
#if iptables -L | grep -c "tcp dpt:"$http_base_port > /dev/null; then
#iptables -D INPUT -p tcp --dport $http_base_port -j ACCEPT
#fi
read  -p "2. Please type new panel port no. ("$http_base_port"): " new_http_base_port
if test -z $new_http_base_port; then
new_http_base_port=$http_base_port
fi
http_base_port_keyword_with_value="http_base_port="$http_base_port
new_http_base_port_keyword_with_value="http_base_port="$new_http_base_port
sedcmd='s/'$http_base_port_keyword_with_value'/'$new_http_base_port_keyword_with_value'/g'
sed -i $sedcmd ezserver_config.txt
echo "Set Panel Port No. to "$new_http_base_port
#iptables -I INPUT -p tcp --dport $new_http_base_port -j ACCEPT
#
# 3. Type HTTP Video Streaming Port
#
http_port_str="http_port"
http_port=$("$ezgetconfig_image"  $http_port_str)
#if iptables -L | grep -c "tcp dpt:"$http_port > /dev/null; then
#iptables -D INPUT -p tcp --dport $http_port -j ACCEPT
#fi
read  -p "3. Please type new http streaming port no. for players ("$http_port"): " new_http_port
if test -z $new_http_port; then
new_http_port=$http_port
fi
http_port_keyword_with_value="httpport="$http_port
new_http_port_keyword_with_value="httpport="$new_http_port
sedcmd='s/'$http_port_keyword_with_value'/'$new_http_port_keyword_with_value'/g'
sed -i $sedcmd ezserver_config.txt
echo "Set Streaming HTTP Port No. to "$new_http_port
#iptables -I INPUT -p tcp --dport $new_http_port -j ACCEPT
ezserver_folder="$PWD"
sed -i '3d' monitor.sh
sed -i '2a\''export EZSERVER_DIR="'"$ezserver_folder"'"' monitor.sh

# download testing links
rm -f channel_definition.xml
testing_url='http://www.ezhometech.com/download/channel_definition.xml'
wget -O channel_definition.xml $testing_url
echo "4. Ezserver installation successfully..."

read  -p "Install Ezhometech web player(?(y/n) " yn
if test -z $yn; then
yn="y"
fi
if [ "$yn" != "Y" ] && [ "$yn" != "y" ]; then
echo 'Type "cd ezserver" , then "./setup.sh" to start Ezserver...'
echo " "
exit 0
fi

rm online.zip
rm -rf online

standard_url='http://www.ezhometech.com/download_player/web_player/online.zip'
wget -O online.zip $standard_url
if [ -s online.zip ]; then
	echo "Ezhometech Web Player downloaded..."
	unzip online.zip
	rm online.zip
else
	echo "Ezhometech Web Player file not Found..."
fi
echo 'Type "cd ezserver" , then "./setup.sh" to start Ezserver...'
echo " "

