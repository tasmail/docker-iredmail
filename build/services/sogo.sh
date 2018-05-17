#!/bin/sh

trap_hup_signal() {
    echo "Reloading (from SIGHUP)"
    /etc/init.d/sogo reload
}

trap_term_signal() {
    echo "Stopping (from SIGTERM)"
    /etc/init.d/sogo stop
    sleep 2
    exit 0
}

trap "trap_hup_signal" HUP
trap "trap_term_signal" TERM

rm -rf /run/sogo/sogo.pid
/etc/init.d/sogo start

while [ ! -f /run/sogo/sogo.pid ]
do
    sleep 1
done

pid=$(cat /run/sogo/sogo.pid)

