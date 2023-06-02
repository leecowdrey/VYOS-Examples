#!/bin/bash
RETVAL=1
PING_INTERFACE="pppoe0"
PING_TARGET="208.67.220.220"
PING_OPTIONS="-q -n -i 2 -c 2 -W 5"

if [ -f /proc/net/pppoe ] ; then
  EXISTS=$(cat /proc/net/pppoe|grep bond0.100|wc -l)
  if [ ${EXISTS} -eq 0 ] ; then
    exit ${RETVAL}
  fi
  /bin/ping -I ${PING_INTERFACE} ${PING_OPTIONS} ${PING_TARGET} &> /dev/null
  RETVAL=$?
else
  /bin/ping ${PING_OPTIONS} ${PING_TARGET} &> /dev/null
  RETVAL=$?
fi

exit ${RETVAL}
