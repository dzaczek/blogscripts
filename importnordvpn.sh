#!/bin/bash
#title           :importnordvpn.sh
#description     :This script will batch import ovpn files  .
#author          :dzaczek consolechars.wordpress.com
#date            :20170227
#version         :0.4a
#usage           :./bash mkscript.sh -u [username] -p [password] -d [directory with ovpn configs] || -g
#notes           :Install NetworkManager.x86_64 NetworkManager-openvpn.x86_64 NetworkManager-openvpn-gnome.x86_64 awk
#notes           : Script reqquired time, for add 1583 vpn config needed 3h 2m
#==============================================================================
sessionname="$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c 6;echo;)"
target="/tmp/$sessionname/nordvpn.zip"
target_1=/tmp/$sessionname/
bck=$PWD
wnump=0
#!/bin/bash
ttt=$(ps ax | grep $$ | grep -v grep | awk '{print $2}')
terminal="/dev/$ttt"
#rows=$(stty -a <"$terminal" | grep -Po '(?<=rows )\d+')
start=`date +%s`



runtime=$((end-start))
nice_output(){
  clear
  columns=$(stty -a <"$terminal" | grep -Po '(?<=columns )\d+')
  #echo "Progress BARR"
  precenteage=$(echo "(($1*100/$2))/1" | bc  )
  in="$precenteage/100%"
  sizbar=$(($columns-${#in}-7))
  p1=$(echo "(($precenteage*$sizbar)/100)/1" | bc  )
  arr=$5
  precenteage1=$p1
  precenteage2=$((sizbar-p1))
  echo -n -e "\n\n\n\n\n \t\t\tImporting Files.$1/$2\t $6 \n\n\n"
  end=`date +%s`
  echo  -n -e "\t\t\t Script Working `date -d@$((end-$3)) -u +%H:%M:%S` seconds \n \t\t\t ETA : `date -d@$(echo "($2-$1)*$4" |bc -l) -u +%H:%M:%S`\n ${arr[@]}\n"


#___________Progress___BAR______________________________
  echo -n "$in"
  echo  -n -e "["
  #echo -n -e "\n"
  for ((i=0;i<=precenteage1;i++)); do
  echo -n  -e "\e[44m#\e[0m"
  done

  for ((i=0;i<precenteage2;i++)); do
  echo -n -e "\e[100m-\e[0m"
  done

  echo  -n -e "]"
  echo -n -e "100% \n"
#______________________________________________
}


remove_all_vpn(){
  #remove all vpn utill any vpn conncetion is on a list
  while [[ $(nmcli con show | awk '$3=="vpn" {print "1"}' | wc -l) -gt 0  ]]; do
    nmcli con del $(nmcli con show | awk '$3=="vpn" {print $2}') 2>/dev/null
  done
echo "Connection VPN removed"
}

get_ovpn_files(){
  #get form network vpn-config files
  mkdir $target_1
  url_config_f="aHR0cHM6Ly9ub3JkdnBuLmNvbS9hcGkvZmlsZXMvemlwCg=="
  wget $(echo "$url_config_f" | base64 -d) -O  $target
  if [ $? -eq 1 ]; then
    echo "I cant download ovpn files check internet connection"
  exit 1
  fi
  unzip $target -d$target_1

  rm -f $target

}
import_files_to_nmcli(){
  dxa=6
  dxb=0
  dbl=( )
  echo "Added :"
  printf '%s\n' "$a" | while IFS= read -r line
 do
        start_loop1=`date +%s.%N`
      wnump=$(($wnump+1))
    #  dxb=$(($dxb+1))
      #prepare short name for connection
      conname=`echo $line | awk  -F "." '{print $1"-"$4}' `
      # add/import connection to nmcli and grap uuid by regex in awk
      uuidcon=$(nmcli connection import $temp8 type openvpn  file  $line |  awk 'match($0,  /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/) {print substr($0, RSTART, RLENGTH)}')
      #reneme conenction and add username and password
      nmcli con mod $temp8 uuid $uuidcon connection.id $conname +vpn.data "username=$USERNAMEFORVPN" vpn.secrets password="$PASSWFORVPN"
      if [ $dxb -eq $dxa ];then echo -n -e "\n";dxb=0;else dbl[dxb]="$(echo "scale=3;$(date +%s.%N)-$start_loop1"| bc -l)";dxb=$(($dxb+1)); fi
      average_nmcli_loop=$(echo "scale=2;($(echo ${dbl[*]}| tr ' ' '+'))/${#dbl[*]}" | bc -l )
      #echo "$average_nmcli_loop"
      #echo ${dbl[*]}

      nice_output $wnump $numfiles $start $average_nmcli_loop "${dbl[*]}" $conname
      #echo -n -e "\e[$((31+$dxb))m$conname\e[0m\t" ; if  [ $dxb -eq $dxa ];then echo -n -e "\n";dxb=0; fi
#      echo -e "$wnump. Added $conname:\t $uuidcon" #verbose


 done
echo "Loops $wnump"
}




while getopts ":u:p:d:c h g t" opt; do
 case $opt in
   u) au=$OPTARG   ;;
   p) ap=$OPTARG   ;;
   c) ac=1         ;;
   d) ad=$OPTARG ;;
   h) ah=1 ;;
   t) att=1 ;;
   g) ag=1 ;;
   \?)       echo "Invalid option: -$OPTARG\n Please use parameter -h for help" >&2
   exit 1 ;;

 esac
done


if [ "$#" ==  0 ]; then

    echo "Parameter do not found please use -h for help"  ; exit 1;
	exit 1
fi

#check if -h print help end exit
if [ "x" != "x$ah" ]; then
  cat << EOF
          script batch adding openvpn  nordvpn configs to nmcli
          #time adding  1583 VPN'S  3:02:17.37 total
      usage:
      ./importnordvpn.sh [-u <"username">   -p <"password">][-h][-d <"directory"> || -g][-c]


            -u username (is mail ) it must be in qoutes " "
            -p password it must be in qoutes " "
            -d patch to direcotory  ovpn files arguments not required
                you can run script in direcotry white space in patch
                not working.
            -g Get configs from network.
            -c clean DANGER, roemove all connection type vpn from nmcli
            -t Temporary use this for test, added configuration
                disaper after restart NetworkManager (nmcli)
            -h it is this information

      examples:
            ./importnordvpn -u "myemail@exampl.com" -p "P44SSwoRd"
          or
            ./importnordvpn -u "myemail@exampl.com" -p "P44SSwoRd" -d Download/configs/
          Get configuration from nordvpn.com
            ./importnordvpn -u "myemail@exampl.com" -p "P44SSwoRd" -d
          if you want clean configuration
             ./importnordvpn -c
          clean configuration (remove all vpn's from nmcli ). and load new
            ./importnordvpn -c -u "myemail@exampl.com" -p "P44SSwoRd" -d Download/configs/
      __________________________________________________________
      Report bugs to:dzaczek[animaleatingyellow fruit]sysop.cat
      up home page:https://consolechars.wordpress.com/
      ______________)____________________________________________
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
if [ "x" != "x$att" ]; then
temp8="--temporary"
echo "ok";
else
temp8=""
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
#check if parameter -g
if [ "x" != "x$ag" ] ; then
#get ovpn config files
  get_ovpn_files
#go to diretory with ovpn config files
  cd $target_1 2>/dev/null
  echo $PWD
#chek if -g patch is able to cd if not exit
if [ $? -eq 1 ]; then
  echo "-d $target_1 wrong patch to directory"
exit 1
fi
fi


#assign varaibles
USERNAMEFORVPN=$au
PASSWFORVPN=$ap
#ssign to vataible a all files *.vpn in directory

a=$(ls *.ovpn)
numfiles=$(echo $a |wc | awk '{print $2}')
#check   if not len a eq 0
if [[ "$numfiles" -eq 0 ]]; then
  echo "Ovpn filne in $PWD do not found "
  exit 1
fi
import_files_to_nmcli
#iterating a line by line
if [ "x" != "x$ag" ] ; then
cd $bck
rm -fr $target_1 2>/dev/null
#chek if -g patch is able to rm if not exit
if [ $? -eq 1 ]; then
  echo "-d $target_1 wrong patch to directory i can remove directory"
exit 1
fi
fi
