#!/bin/sh
#
# Custom launcher script for weston.
#
# We want to support different configs related to backends, remote desktop, etc
# and unforunately some of the parameters to configure those modes need to be
# set on the command line in the system service definition, while others need
# to be set inside the weston.ini file.  Since we want multiple configs without
# needing to modify the systemd service definition, we will wrap all that
# complexity in this script.
#

. /etc/default/weston

CERT_CN="colibri-imx6"
CLI_EXTRA_PARMS=""

case ${WESTON_MODE} in
    vnc-virtual )
        CLI_EXTRA_PARMS="${CLI_EXTRA_PARMS} --vnc-tls-cert=/etc/keys/vnc-tls.crt --vnc-tls-key=/etc/keys/vnc-tls.key"
        INI_FILE="weston-vnc-virtual-screen.ini"
        if [ ! -e /etc/keys/vnc-tls.crt ]; then
            mkdir -p /etc/keys
            openssl req -x509 -newkey rsa:2048 -nodes \
                -keyout /etc/keys/vnc-tls.key \
                -out /etc/keys/vnc-tls.crt \
                -days 365 -subj "/CN=${CERT_CN}"
            chown weston:weston /etc/keys/vnc-tls.key /etc/keys/vnc-tls.crt
        fi
        WESTON_USER="weston"
        ;;
    rdp-virtual )
        CLI_EXTRA_PARMS="${CLI_EXTRA_PARMS} --rdp-tls-cert=/etc/keys/rdp-tls.crt --rdp-tls-key=/etc/keys/rdp-tls.key"
        INI_FILE="weston-rdp-virtual-screen.ini"
        if [ ! -e /etc/keys/rpd-tls.crt ]; then
            mkdir -p /etc/keys
            openssl req -x509 -newkey rsa:2048 -nodes \
                -keyout /etc/keys/rdp-tls.key \
                -out /etc/keys/rdp-tls.crt \
                -days 365 -subj "/CN=${CERT_CN}"
            chown weston:weston /etc/keys/rdp-tls.key /etc/keys/rdp-tls.crt
        fi
        WESTON_USER="root"
        ;;
    * )
        INI_FILE="weston.ini"
        WESTON_USER="root"
        ;;
esac

chown ${WESTON_USER} /tmp/weston.log >/dev/null 2>&1 || true

if [ "${WESTON_USER}" = "root" ]; then
    exec /usr/bin/weston --modules=systemd-notify.so --log=/tmp/weston.log --config=${INI_FILE} ${CLI_EXTRA_PARMS}
else
    install -d -m 0700 -o $(id -u ${WESTON_USER}) -g $(id -g ${WESTON_USER}) /run/user/$(id -u ${WESTON_USER})
    su -l ${WESTON_USER} -c "/usr/bin/weston-user.sh --modules=systemd-notify.so --log=/tmp/weston.log --config=${INI_FILE} ${CLI_EXTRA_PARMS}"
fi
