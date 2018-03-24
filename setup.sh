#!/bin/sh
chmod 777 *.*
chmod 777 *
echo 2062780 > /proc/sys/kernel/threads-max
if ! which killall; then
echo "killall command not found, please install it"
exit 0
fi
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
sysctl -p
fi
ezgetconfig_image="./ezgetconfig"
#
# 1. Type network interface
#
network_interface_str="network_interface"
network_interface_value=$("$ezgetconfig_image"  $network_interface_str)
rm -rf serial_number.txt
echo "Network Interface:"
ifconfig
echo "Current Network Interface is " $network_interface_value
read  -p "1. Please select one Network Interface( eth0, venet0:0,...)? " ni
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
read  -p "2. Please type new panel port no. ("$http_base_port"): " new_http_base_port
if test -z $new_http_base_port; then
new_http_base_port=$http_base_port
fi
http_base_port_keyword_with_value="http_base_port="$http_base_port
new_http_base_port_keyword_with_value="http_base_port="$new_http_base_port
sedcmd='s/'$http_base_port_keyword_with_value'/'$new_http_base_port_keyword_with_value'/g'
sed -i $sedcmd ezserver_config.txt
echo "Set Panel Port No. to "$new_http_base_port
#
# 3. Type HTTP Video Streaming Port
#
http_port_str="http_port"
http_port=$("$ezgetconfig_image"  $http_port_str)
read  -p "3. Please type new http streaming port no. for players ("$http_port"): " new_http_port
if test -z $new_http_port; then
new_http_port=$http_port
fi
http_port_keyword_with_value="httpport="$http_port
new_http_port_keyword_with_value="httpport="$new_http_port
sedcmd='s/'$http_port_keyword_with_value'/'$new_http_port_keyword_with_value'/g'
sed -i $sedcmd ezserver_config.txt
echo "Set Streaming HTTP Port No. to "$new_http_port
#
# 4. Setup Auto Start
#
ezserver_folder="$PWD"
read  -p "4. Do you want to setup auto_start mode?(y/n) " yn
if test -z $yn; then
yn="y"
fi
if [ "$yn" != "Y" ] && [ "$yn" != "y" ]; then
echo "auto_start mode is disabled..."
else
if ! cat /etc/crontab | grep -v grep | grep -c checkezserver.sh > /dev/null; then
sed -i '2d' checkezserver.sh
sed -i '1a\''export EZSERVER_DIR="'"$ezserver_folder"'"' checkezserver.sh
sed -i '$a\'"*/3 * * * * root ""$ezserver_folder""/checkezserver.sh" /etc/crontab
fi
echo "auto_start mode is enabled..."
fi
#
killall -9 ezserver
nohup ./ezserver &

echo "5. Setup successfully..."
echo "6. Edited by maxdata755 *CRACKED* version..."
echo " "
