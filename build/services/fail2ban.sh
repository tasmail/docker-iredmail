#!/bin/sh

trap_term_signal() {
    echo "Stopping (from SIGTERM)"
    /etc/init.d/fail2ban stop
    exit 0
}

trap "trap_term_signal" TERM

rm -rf /var/run/fail2ban/fail2ban.pid

while [ ! -f /var/log/mail.log ]
do
    sleep 1
done

while [ ! -f /var/log/dovecot.log ]
do
    sleep 1
done

/etc/init.d/fail2ban start

while [ ! -f /var/run/fail2ban/fail2ban.pid ]
do
    sleep 1
done

pid=$(cat /var/run/fail2ban/fail2ban.pid)

while kill -0 $pid 2>/dev/null
do
    sleep 1
done
