# wayland-protocols: update 1.37 -> 1.38
#   - Add wayland-native dependency to provide the requested wayland-scanner
# (From OE-Core rev: 5de187aee675a78fe59620a3fb64a5da5ae662aa)

DEPENDS += "wayland-native"

# Also add back in missing packages.  This is fixed more cleanly in master but removing
# the "PACKAGES=${PN}" line but since we are bbappending, let's just force it.
PACKAGES:append = " ${PN}-src ${PN}-dbg ${PN}-staticdev ${PN}-dev ${PN}-doc ${PN}-locale "