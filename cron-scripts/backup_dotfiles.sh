#!/usr/bin/env sh

rsync -a /home/kay/.config /mnt/backups/user-config-backup
rsync -a /home/kay/.dotfiles /mnt/backups/user-config-backup
rsync -a /home/kay/.local /mnt/backups/user-config-backup
