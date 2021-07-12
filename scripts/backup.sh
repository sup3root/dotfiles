#!/bin/bash
####################################
#
#       bakup system 
#
####################################
set -e
# what to backup
backup_files="/home /etc /root /boot /opt"

# where to backup 
dest="/run/media/sup3r/E/sup3r@linuxBackup"

# create archive filename
day=$(date +%Y%m%d)
hostname=$(uname -n)
archive_file="$hostname-$day.tgz"

# print start status message
echo "backing up $backup_files to $dest/$archive_file"
date
echo

# backup the files using tar
tar czpvf $dest/$archive_file\
    --exclude=/home/sup3r/.config/google-chrome\
    --exclude=/home/sup3r/github\
    --exclude=/home/sup3r/.cache\
    --exclude=/home/sup3r/.config/libreoffice\
    --exclude=/home/sup3r/test\
    --exclude=/home/sup3r/.local/share/Trash\
    --exclude=/home/sup3r/.local/share/TelegramDesktop\
    --exclude=/home/sup3r/Downloads\
    --exclude=/home/sup3r/Videos\
    --exclude=/home/sup3r/.mozilla\
    --exclude=/home/sup3r/.config/chromium\
    --exclude=/home/sup3r/Music\
    --exclude=/home/sup3r/Pictures\
    --exclude=/opt/google\
    --exclude=/home/sup3r/.local/lib/python*\
    --exclude=/root/.cache\
    $backup_files

# print end status message
echo 
echo "backup finished"
date --rfc-3339=s

# long listing of files in $dest to check file sizes
ls -lhtr $dest

