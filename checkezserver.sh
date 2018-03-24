#!/bin/sh
export EZSERVER_DIR="/usr/local/bin/ezserver"
ezserver_image="$EZSERVER_DIR""/ezserver"
ezgetconfig_image="$EZSERVER_DIR""/ezgetconfig"
http_base_port_str="http_base_port"
http_base_port=$("$ezgetconfig_image"  $http_base_port_str)
panelurl="http://127.0.0.1:""$http_base_port""/version.xml"
if wget -O- $panelurl
then
echo "ezserver in running"
else
echo "ezserver is not running"
killall -9 ezserver
"$ezserver_image"
fi
