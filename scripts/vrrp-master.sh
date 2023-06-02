#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

configure
run connect interface pppoe0
exit

exit
