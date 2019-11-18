#!/bin/bash

DOMAIN="linora.net"

echo "Build hosts files and deploy"

echo "Retriving hosts list"

echo "# all $DOMAIN hosts" >hosts.all
for i in `cat linora.list`
do
	echo $i
	IP=̀`ping -c1 $i|head -1|cut -d"(" -f2|cut -d")" -f1`
	

	echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" >hosts.$i
	echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >>hosts.$i
	echo "127.0.0.1 $i" >>hosts.$i
	echo "" >>hosts.$i
	ALIAS=`cat linora-hosts.list |grep $i`
	echo "$IP $ALIAS"
	echo "$IP $ALIAS" >>hosts.all
	
done

echo ""

for i in `cat linora.list`
do
	echo "Deplying $i"
	#IP=̀`ping -c1 $i|head -1|cut -d"(" -f2|cut -d")" -f1`
	
	cat hosts.all >>hosts.$i
	ssh root@$i "cp -p /etc/hosts /etc/hosts.backup"
	scp hosts.$i root@$i:/etc/hosts
	
done


