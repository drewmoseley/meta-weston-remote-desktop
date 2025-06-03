FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
RDEPENDS:${PN}:append = " openssl "

SRC_URI:append = " \
    file://weston-vnc-virtual-screen.ini \
    file://weston-rdp-virtual-screen.ini \
    file://weston-systemd-service-override.conf \
    file://weston-launcher.sh \
"

# Note that the encrypted password is generated with the following command:
# $ printf "%q" $(mkpasswd -m sha256crypt supersecretpassword)
WESTON_USER_ENCRYPTED_PASSWORD = "\$5\$gOQess7xm/.lFxPs\$Bzu6NbtD4/nduTNzm9JCm/Mrjpz4/RDQ3l8b08ayRR9"
USERADD_PARAM:${PN} = "--home /home/weston --shell /bin/sh --user-group -G video,input,render,wayland -p '${WESTON_USER_ENCRYPTED_PASSWORD}' weston"

do_install:append() {
	install -d -m 0755 ${D}${sysconfdir}/systemd/system/weston.service.d/
	install -m 0644 ${WORKDIR}/weston-systemd-service-override.conf ${D}${sysconfdir}/systemd/system/weston.service.d/override.conf
	install -m 0644 ${WORKDIR}/weston-vnc-virtual-screen.ini ${D}${sysconfdir}/xdg/weston/
	install -m 0644 ${WORKDIR}/weston-rdp-virtual-screen.ini ${D}${sysconfdir}/xdg/weston/
	install -d -m 0777 ${D}${sysconfdir}/keys/
	install -d -m -755 ${D}${bindir}
	install -m 0755 ${WORKDIR}/weston-launcher.sh ${D}${bindir}
	echo 'WESTON_MODE="vnc-virtual"' >> ${D}${sysconfdir}/default/weston
}
FILES:${PN}:append = " \
    ${sysconfdir}/systemd/system/weston.service.d/override.conf \
    ${sysconfdir}/xdg/weston/weston-vnc-virtual-screen.ini \
    ${sysconfdir}/xdg/weston/weston-rdp-virtual-screen.ini \
    ${sysconfdir}/keys/ \
"
