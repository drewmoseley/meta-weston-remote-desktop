#!/bin/sh
#
# Launch weston as a non-root user
#
# This is used for vnc and weston to ensure proper user authentication
#

export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
exec /usr/bin/weston $@
