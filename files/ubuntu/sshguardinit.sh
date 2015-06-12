#! /bin/sh
### BEGIN INIT INFO
# Provides:          sshguard
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:     $remote_fs $network $syslog
# Should-Start:      sshd
# Should-Stop:       sshd
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: SSHGuard Server
# Description:       Sshguard is a log monitor. It protects networked hosts
#                    from the today's widespread brute force attacks against services,
#                    most notably SSH. It detects such attacks and blocks
#                    the author's address with a firewall rule.
### END INIT INFO

# Author: Eugene San <eugenesan@gmail.com>
# Modify by Julián Moreno Patiño <darkjunix@gmail.com>
# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="SSHGuard Server"
NAME=sshguard
DAEMON=/usr/sbin/$NAME
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
DAEMON_ARGS="-i $PIDFILE"
OS=$(uname)

# Exit if the package is not installed
[ ! -x "$DAEMON" ] && log_warning_msg "No valid daemon $DAEMON for $NAME, exiting" && exit 0

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.0-6) to ensure that this file is present.
. /lib/lsb/init-functions

# Add logfiles to be monitored to list passed to daemon
LOGS=0
for logfile in $LOGFILES; do [ -r "$logfile" ] && DAEMON_ARGS="$DAEMON_ARGS -l $logfile" && LOGS=$((LOGS+1)); done
[ $LOGS = 0 ] && log_warning_msg "No valid logs to scan by $NAME, exiting" && exit 0

# Added whitelist file and other options

DAEMON_ARGS="$DAEMON_ARGS -w $WHITELIST $ARGS"

#
# Function that check if sshguard is enabled
#

if [ "$OS" = "Linux" ]; then
	#
	# Function that enables firewall
	#
	do_enable_firewall()
	{
		log_progress_msg "enabling firewall"
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
		log_progress_msg "disabling firewall"
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
else
	# KfreeBSD code
	#
	# Function that enables firewall
	#
	do_enable_firewall()
	{
		log_progress_msg "enabling firewall"
		# create sshguard firewall rules
		PF_AVAILABLE=$(lsmod |grep pf.ko |awk {'print $5'})
		if [ "$PF_AVAILABLE" != "pf.ko" ]; then
			kldload pf
		fi
		pfctl -e 2> /dev/null # Enable PF
		# Loading sshguard table and rules
		pfctl -f /etc/sshguard/sshguard.conf 2> /dev/null
	}
	#
	# Function that disables firewall
	#
	do_disable_firewall()
	{
		log_progress_msg "disabling firewall"
		# flushes list of abusers
		pfctl -Tflush -t sshguard 2> /dev/null
		# removes sshguard firewall rules
		pfctl -Tdel -t sshguard 2> /dev/null
		# removing sshguard table
		pfctl -Tkill -t sshguard 2> /dev/null
	}
fi


case "$1" in
	start)
	log_daemon_msg "Starting $DESC" "$NAME"
        if [ "$ENABLE_FIREWALL" = "1" ]; then
            do_enable_firewall
        fi
	if start-stop-daemon --start --quiet --oknodo --pidfile $PIDFILE --exec $DAEMON --background -- $DAEMON_ARGS; then
		log_end_msg 0
	else
		log_end_msg 1
	fi
	;;
	stop)
	log_daemon_msg "Stopping $DESC" "$NAME"
	if start-stop-daemon --stop --quiet --oknodo --pidfile $PIDFILE; then
		ret=0
	else
		ret=1
	fi
        if [ "$ENABLE_FIREWALL" = "1" ]; then
            do_disable_firewall
        fi
        log_end_msg $ret
	;;
	restart|force-reload)
	log_daemon_msg "Restarting $DESC" "$NAME"
	start-stop-daemon --stop --quiet --oknodo --retry 30 --pidfile $PIDFILE
        if [ "$ENABLE_FIREWALL" = "1" ]; then
            do_disable_firewall
            do_enable_firewall
        fi
	if start-stop-daemon --start --quiet --oknodo --pidfile $PIDFILE --exec $DAEMON --background -- $DAEMON_ARGS; then
		log_end_msg 0
	else
		log_end_msg 1
	fi
	;;
	status)
		status_of_proc -p "$PIDFILE" "$DAEMON" "$NAME" && exit 0 || exit $?
	;;

	*)
	log_action_msg "Usage: $SCRIPTNAME {start|stop|force-reload|restart|status}"
	exit 3
	;;
esac