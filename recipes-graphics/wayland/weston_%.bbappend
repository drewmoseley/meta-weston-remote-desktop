FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://0001-backend-vnc-Allow-running-as-different-user.patch \
	file://weston-systemd-service-override.conf \
	file://weston-launcher.sh \
"
PACKAGECONFIG:append = " vnc rdp "

# Add neatvnc and aml runtime dependencies (required for the VNC plugin)
RDEPENDS:${PN} += " neatvnc aml"
