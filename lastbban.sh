
#!/bin/bash
dayy=$(date +%-d); monthh=$(date +%b);
whitelist=(85.89.172.190 127.0.0.1 localhost)
listbanned=(1.1.1.1 2.2.2.2 4.4.4.4)#($(cat hosts.deny | grep -ve "^#"| awk  -F: '{if($1="sshd")print $2}'))
numofattemps=10

for i in "${whitelist[@]}"
do
  echo "${i}"
done

for i in $(seq $dayy);
 do
 echo -ne "\t $monthh $i\t\n"; lastb -a | grep $"$monthh " | awk -v var="$i" '{if($5==var) print $10}'| sort | uniq -c | sork -k1nr | head ;
done
