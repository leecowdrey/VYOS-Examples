#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

if [ -z "$1" ] ; then
  MODE="stop"
else
  MODE="${1}"
fi

case "${MODE,,}" in
  backup|fault|stop)
configure
run disconnect interface pppoe0
set interfaces bonding bond0 vif 100 pppoe 0 disable
commit
save
exit
;;
  master)
configure
delete interfaces bonding bond0 vif 100 pppoe 0 disable
commit
save
run connect interface pppoe0
exit
;;
esac

exit
