
#!/bin/bash
target="./hosts.deny"
dayy=$(date +%-d); monthh=$(date +%b);
isodate=$(date +%Y-%m-%dT%H:%M:%S%z)
whitelist=(85.89.172.190 127.0.0.1 localhost)
listbanned=(1.1.1.1 2.2.2.2 4.4.4.4)
#($(cat hosts.deny | grep -ve "^#"| awk  -F: '{if($1="sshd")print $2}'))
numofattemps=10
periodtimb="+10min"
#lasb -s
listtobaned=(a.a.a.a b.b.b.b 127.0.0.1 4.4.4.4)
#/todo/parser for lastb host or ip

contains() {

  #cobvert array to list
  #echo "$1"
  #echo "$2"
    [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]] && return 0 || return 1

}

banbanban() {
  #function banning
  echo -ne "sshd: $1 \n##[$isodate] added $1 nmmber of attemps $2\n" #>> $target
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



#for i in $(seq $dayy);
#do
#  echo -ne "\t $monthh $i\t\n"; lastb -a | grep $"$monthh " | awk -v var="$i" '{if($5==var) print $10}'| sort | uniq -c | sork -k1nr | head ;
#done
