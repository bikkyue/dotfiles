#!/bin/bash

# ホストからマウントした.sshをコピーしてパーミッションを修正
if [ -d "$HOME/.ssh-host" ]; then
    mkdir -p "$HOME/.ssh"
    sudo cp -r "$HOME/.ssh-host/." "$HOME/.ssh/"
    sudo chown -R "$USER":"$USER" "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    find "$HOME/.ssh" -type f -exec chmod 600 {} \;
fi

exec "$@"
