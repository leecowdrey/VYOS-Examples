#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

configure
run disconnect interface pppoe0
set interfaces bonding bond0 vif 100 pppoe 0 disable
commit
save
exit

exit