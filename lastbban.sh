#!/bin/bash
target="/etc/hosts.deny"
dayy=$(date +%-d); monthh=$(date +%b);
isodate=$(date +%Y-%m-%dT%H:%M:%S%z)
whitelist=(127.0.0.1 localhost )
listbanned=($(cat $target | grep -ve "^#"| awk  -F: '{if($1="sshd")print $2}'))
numofattemps=10
#periodtimb="+10min"
#lasb -s
#listtobaned=(a.a.a.a b.b.b.b 127.0.0.1 4.4.4.4)
listtobaned=($(lastb -i | awk -v day="$(date +%_d)"  '{if($6==day  ) print $3}' |sort | uniq -c |  awk -v lim=$numofattemps '{if($1>lim) print $2}'))

#/todo/parser for lastb host or ip
#([\S]+)[\W]+([\S]+)[\W]+([0-9]+)[[:space:]]([0-9][0-9]):([0-9][0-9]):([0-9][0-9])[[:space:]]([0-9][0-9][0-9][0-9])[[:space:]]-
#(\w+\s+\d\s[\d]{2}:[\d]{2}:[\d]{2}\s[\d]{4}\)s\- http://regexr.com/3g2s0

contains() {

  #cobvert array to list
  #echo "$1"
  #echo "$2"
    [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]] && return 0 || return 1

}

banbanban() {
  #function banning
  echo -ne "sshd: $1 \n##[$isodate] added $1 nmmber of attemps $2\n" >> $target
}

list_wh="${whitelist[@]}"
list_bn="${listbanned[@]}"


for a in ${listtobaned[@]}
do
if contains "$list_wh" "$a" "100"; then
  echo "$a on whitelist "
  #/todo/convert echo to log output
elif contains "$list_bn" "$a" "100"; then
  echo "$a ist just banned "
  #/todo/convert echo to log output
else
  echo "$a ban"
  #ban
  #//todo/there schould be function fro baning tcp wraper
  banbanban $a "200"
fi
done
