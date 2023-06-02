#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

configure
run disconnect interface pppoe0
exit

exit
