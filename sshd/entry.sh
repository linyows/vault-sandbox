#!/bin/bash

exec /usr/sbin/sshd -E /var/log/auth.log -D
