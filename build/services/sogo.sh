#!/bin/sh

trap_hup_signal() {
    echo "Reloading (from SIGHUP)"
    /etc/init.d/sogo reload
}

trap_term_signal() {
    echo "Stopping (from SIGTERM)"
    kill -3 $pid
    while cat /proc/"$pid"/status | grep State: | grep -q zombie; test $? -gt 0
    do
        sleep 1
    done
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

while kill -0 $pid 2>/dev/null
do
    sleep 1
done
