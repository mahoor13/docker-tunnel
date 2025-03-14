#!/bin/sh

# If SSH_CONFIG_FOLDER is set, copy its contents to /root/.ssh/
if [ -n "$SSH_CONFIG_FOLDER" ] && [ -d "$SSH_CONFIG_FOLDER" ]; then
    cp -r $SSH_CONFIG_FOLDER/* /root/.ssh/
    chmod -R 600 /root/.ssh/*
    echo "Copied SSH config files from $SSH_CONFIG_FOLDER to /root/.ssh/"
fi

ssh-keyscan -H "$TARGET_HOST" >> /root/.ssh/known_hosts

# Run the command passed to the container
exec "$@"
