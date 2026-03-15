#!/bin/bash

# ホストからマウントした.sshをコピーしてパーミッションを修正
if [ -d "$HOME/.ssh-host" ]; then
    mkdir -p "$HOME/.ssh"
    cp -a "$HOME/.ssh-host/." "$HOME/.ssh/"
    chmod 700 "$HOME/.ssh"
    chmod 600 "$HOME/.ssh"/*
    chmod 644 "$HOME/.ssh"/*.pub 2>/dev/null
    chmod 644 "$HOME/.ssh/known_hosts" 2>/dev/null
fi

exec "$@"
