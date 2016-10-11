#!/bin/sh
### BEGIN INIT INFO
# Provides:          THIN_FAYE
# Required-Start:    $all
# Required-Stop:     $network $local_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start the THIN_FAYE unicorns at boot
# Description:       Enable THIN_FAYE at boot time.
### END INIT INFO
set -e
set -u

TIMEOUT=${TIMEOUT-60}
APP_ROOT=/root/chowbrowser
PID=$APP_ROOT/tmp/pids/thin.pid
CMD="thin -C config/private_pub_thin.yml -d start"
action="$1"

old_pid="$PID.oldbin"

cd $APP_ROOT || exit 1

sig () {
	test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
	test -s $old_pid && kill -$1 `cat $old_pid`
}

case $action in
start)
	sig 0 && echo >&2 "Already running" && exit 0
	su -c "$CMD" - www-data
	;;
stop)
	sig QUIT && exit 0
	echo >&2 "Not running"
	;;
force-stop)
	sig TERM && exit 0
	echo >&2 "Not running"
	;;
restart|reload|force-reload)
	sig HUP && echo reloaded OK && exit 0
	echo >&2 "Couldn't reload, starting '$CMD' instead"
	su -c "$CMD" - www-data
	;;
upgrade)
	if sig USR2 && sleep 2 && sig 0 && oldsig QUIT
	then
		n=$TIMEOUT
		while test -s $old_pid && test $n -ge 0
		do
			printf '.' && sleep 1 && n=$(( $n - 1 ))
		done
		echo

		if test $n -lt 0 && test -s $old_pid
		then
			echo >&2 "$old_pid still exists after $TIMEOUT seconds"
			exit 1
		fi
		exit 0
	fi
	echo >&2 "Couldn't upgrade, starting '$CMD' instead"
	su -c "$CMD" - www-data
	;;
reopen-logs)
	sig USR1
	;;
*)
	echo >&2 "Usage: $0 <start|stop|restart|reload|force-reload|upgrade|force-stop|reopen-logs>"
	exit 1
	;;
esac