#!/bin/bash
#title           :importnordvpn.sh
#description     :This script will batch import ovpn files  .
#author		       :dzaczek consolechars.wordpress.com
#date            :20170225
#version         :0.1
#usage           :./bash mkscript.sh -u [username] -p [password] -d [directory with ovpn configs]
#notes           :Install NetworkManager.x86_64 NetworkManager-openvpn.x86_64 NetworkManager-openvpn-gnome.x86_64 awk
#notes           : Scprit reqquired time, for add 1583 vpn config needed 3h 2m
#==============================================================================
remove_all_vpn(){
  #remove all vpn utill any vpn conncetion is on a list
  while [[ $(nmcli con show | awk '$3=="vpn" {print "1"}' | wc -l) -gt 0  ]]; do
    nmcli con del $(nmcli con show | awk '$3=="vpn" {print $2}') 2>/dev/null
  done
echo "Connection VPN removed"
}

while getopts ":u:p:d:c h" opt; do
 case $opt in
   u) au=$OPTARG   ;;
   p) ap=$OPTARG   ;;
   c) ac=1         ;;
   d) ad=$OPTARG ;;
   h) ah=1 ;;
   \?)       echo "Invalid option: -$OPTARG\n Please use parameter -h for help" >&2
   exit 1 ;;

 esac
done

#check if -h print help end exit
if [ "x" != "x$ah" ]; then
  cat << EOF
          #script batch adding openvpn  nordvpn configs to nmcli
          #time adding  1583 VPN'S  3:02:17.37 total
      usage: up ./importnordvpn.sh [-u <"username">| -p <"password">][-h][--d <directory>][-c]
            -u username (is mail ) it must be in qoutes " "
            -p password it must be in qoutes " "
            -d patch to direcotory  ovpn files arguments not required you can run script in direcotry
                version 0.1 do not suport white space in file name
            -c clean DANGER remove all connection type vpn from nmcli
            -h it is this information

      examples:
            ./importnordvpn -u "myemail@examplemail.com" -p "P44SSwoRd"
          or
            ./importnordvpn -u "myemail@examplemail.com" -p "P44SSwoRd" -d Download/configs/
          if you want clean configuration
             ./importnordvpn -c
          clean configuration and load new
            ./importnordvpn -c -u "myemail@examplemail.com" -p "P44SSwoRd" -d Download/configs/
      ___________________________________________________
      Report bugs to:dzaczek[animaletingbanana]sysop.cat
      up home page:https://consolechars.wordpress.com/
      ___________________________________________________
EOF

  exit 1
fi
#check if -c if exist remove all vpn
if [ "x" != "x$ac" ]; then

  remove_all_vpn
#check if username and password id declarated if not exit
if [ "x" == "x$au" ] && [ "x" == "x$ap" ]; then
  exit 1
fi
fi
#checked if username declarated
if [ "x" == "x$au" ]; then
  echo "-u [username] is required"
  exit 1
fi
#checked if password is declarated
if [ "x" == "x$ap" ]; then
  echo "-p [password] is required"
  exit 1
fi
#checked id direcotry is delcarated
if [ "x" != "x$ad" ] ; then
cd $ad 2>/dev/null
#chek if -d patch is able to cd if not exit
if [ $? -eq 1 ]; then
  echo "-d $ad wrong patch to directory"
exit 1
fi
fi
#assign varaibles
USERNAMEFORVPN=$au
PASSWFORVPN=$ap
#ssign to vataible a all files *.vpn in directory
a=$(ls *.ovpn)
#check   if not len a eq 0
if [[ `echo $a |wc | awk '{print $2}'` -eq 0 ]]; then
  echo "Ovpn filne in $PWD do not found "
  exit 1
fi
#iterating a line by line
 printf '%s\n' "$a" | while IFS= read -r line
do
     #prepare short name for connection
     conname=`echo $line | awk  -F "." '{print $1"-"$4}' `
     # add/import connection to nmcli and grap uuid by regex in awk
     uuidcon=$(nmcli connection import type openvpn  file  $line |  awk 'match($0,  /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/) {print substr($0, RSTART, RLENGTH)}')
     #reneme conenction and add username and password
     nmcli con mod uuid $uuidcon connection.id $conname +vpn.data "username=$USERNAMEFORVPN" vpn.secrets password="$PASSWFORVPN"
     echo "Added conncetion $line , uuid uuid is $uuidcon reneamed to $conname"

done
