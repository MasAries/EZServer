#!/bin/sh
rm -rf cfvz ezserver_backup_setting.tar
tar cfvz ezserver_backup_setting.tar ezserver_config.txt channel_definition.xml auto_ezserver.sh users/user_profile.xml ch_config/group_definition.xml
