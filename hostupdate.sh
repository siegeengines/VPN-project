#!/bin/bash
declare -A DN
DN["s1.shebao.gq"]="4wisNByHxksxPlCi"
DN["s2.shebao.gq"]="d8jCKjgeoVZOi08n"
DN["s3.shebao.gq"]="Ffb0kWKwb53tENsU"
DN["m1.shebao.gq"]="p6hmAnR8txVLcv1e"
#DN["test.shebao.gq"]="VgxYvXLXKHmB94pE"
declare -A result
for hostname in "${!DN[@]}"
do
    result[$hostname]=$(ping -c 1 $hostname |grep "bytes from" |cut -d" " -f 4|cut -d":" -f1)
done
asd = "localhost"
for hostname in "${!DN[@]}"
do
echo ${result[$hostname]}
if [ ${result[$hostname]} = "localhost" ]
then
	echo "@reboot cd /tmp && wget http://$hostname:${DN[$hostname]}@dyn.dns.he.net/nic/update?hostname=$hostname" >> /home/my-crontab
	crontab /home/my-crontab
    break
fi
done