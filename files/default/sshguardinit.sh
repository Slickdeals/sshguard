#
# chkconfig:    2345 56 24
# description:  SshGuard daemon
#
# processname:  sshguard
# pidfile: /var/run/sshguard.pid

# source function library
. /etc/rc.d/init.d/functions

# Read configuration variable file if it is present
[ -r /etc/default/sshguard ] && . /etc/default/sshguard

RETVAL=0

exec=/usr/local/sbin/sshguard
prog=sshguard
lockfile=/var/lock/subsys/$prog
pidfile=/var/run/$prog.pid
DAEMON_ARGS=

# Add logfiles to be monitored to list passed to daemon
LOGS=0
for logfile in $LOGFILES; do [ -r "$logfile" ] && DAEMON_ARGS="$DAEMON_ARGS -l $logfile" && LOGS=$((LOGS+1)); done
[ $LOGS = 0 ] && echo "No valid logs to scan by $NAME, exiting" && exit 0

# Added whitelist file and other options

DAEMON_ARGS="$DAEMON_ARGS -w $WHITELIST $ARGS"



#
# Function that enables firewall
#
do_enable_firewall()
{
    # creating sshguard chain
    iptables -N sshguard 2> /dev/null
    ip6tables -N sshguard 2> /dev/null
    # block traffic from abusers
    iptables -I INPUT -j sshguard 2> /dev/null
    ip6tables -I INPUT -j sshguard 2> /dev/null
}
#
# Function that disables firewall
#
do_disable_firewall()
{
    # flushes list of abusers
    iptables -F sshguard 2> /dev/null
    ip6tables -F sshguard 2> /dev/null
    # removes sshguard firewall rules
    iptables -D INPUT -j sshguard 2> /dev/null
    ip6tables -D INPUT -j sshguard 2> /dev/null
    # removing sshguard chain
    iptables -X sshguard 2> /dev/null
    ip6tables -X sshguard 2> /dev/null
}



start()
{
    echo -n $"Starting $prog: "
    if [ "$ENABLE_FIREWALL" = "1" ]; then
        do_enable_firewall
    fi
    [ -x $exec ] || {
        failure $"$base startup"
        echo
        echo "Cannot find executable: $exec" >&2
        exit 5
    }

    [ -r ${pidfile} ] && {
        pid=$(cat ${pidfile})
        checkpid $pid && {
            failure $"$base startup"
            echo
            echo "sshguard already started: PID=$pid" >&2
            exit -1
        }
    }

    $exec $DAEMON_ARGS &>/dev/null &
    echo $! > ${pidfile}
    success $"$base startup"
    echo 
    return 0
}

stop()
{
    if [ "$ENABLE_FIREWALL" = "1" ]; then
        do_disable_firewall
    fi
    echo -n $"Stopping $prog: "
    killproc -p ${pidfile} $prog
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

restart() {
    stop
    start
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status -p ${pidfile} ${prog}
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart|status}"
        RETVAL=2
esac
exit $RETVAL