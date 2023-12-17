#!/bin/sh

rsync -a --delete /home/kay/.config /mnt/backups/user-config-backup-daily
rsync -a --delete /home/kay/.dotfiles /mnt/backups/user-config-backup-daily
rsync -a --delete /home/kay/.local /mnt/backups/user-config-backup-daily
