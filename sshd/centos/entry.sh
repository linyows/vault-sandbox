#!/bin/sh

ssh-keygen -A

# do not detach (-D), log to stderr (-e), passthrough other arguments
#exec /usr/sbin/sshd -D -e "$@"
exec /usr/sbin/sshd -D -E /var/log/secure.log
