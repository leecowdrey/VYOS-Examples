#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

configure
delete interfaces bonding bond0 vif 100 pppoe 0 disable
commit
save
run connect interface pppoe0
exit

exit