#!/bin/sh
chmod +x *.sh
apt-get -y install build-essential dnsmasq nano
echo "INSTALLING SOFTETHER VPN SERVER"
tar xzvf *vpnserver*
cd vpnserver 
printf "1\n1\n1\n" | make
cd ..
mv vpnserver /usr/local
cd /usr/local/vpnserver/
chmod 600 *
chmod 700 vpncmd
chmod 700 vpnserver
ls -l
echo "SETTING UP TIME"
export DEBIAN_FRONTEND=noninteractive
apt-get install -y tzdata
ln -fs /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata
echo "INSTALLING V2RAY PROXY SERVER"
cd /tmp
wget https://install.direct/go.sh
mkdir /v2ray
bash go.sh
echo '{
  "log": {
    "access": "/v2ray/access.log",
    "error": "/v2ray/error.log",
	"loglevel": "debug"
  },
  "inbounds": [
    {
      "port": 443, 
      "protocol": "vmess",   
      "settings": {
        "clients": [
          {
            "id": "a2d029c7-ee40-42bd-b526-69ddbaf8ea91",  
            "alterId": 64
          }
        ],
		"disableInsecureEncryption": true
      },
	    "streamSettings": {
        "network": "mkcp", 
        "kcpSettings": {
          "uplinkCapacity": 100,
          "downlinkCapacity": 100,
          "congestion": true,
          "header": {
            "type": "wechat-video"
          }
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom", 
      "settings": {}
    }
  ],
   "routing": {
    "strategy": "rules",
    "settings": {
      "domainStrategy": "AsIs",
      "rules": [
        {
          "type": "field",
          "outboundTag": "block",
          "protocol": [
            "bittorrent"
          ]
        }
      ]
    }
  }
}' > /etc/v2ray/config.json
systemctl enable v2ray
systemctl start v2ray
echo "INSTALLING INIT DAEMON FOR SOFTETHER VPN SERVER"
echo '#!/bin/sh
### BEGIN INIT INFO
# Provides:          vpnserver
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable Softether by daemon.
### END INIT INFO
DAEMON=/usr/local/vpnserver/vpnserver
DNSSER=/etc/init.d/dnsmasq
LOCK=/var/lock/subsys/vpnserver
TAP_ADDR=192.168.7.1
test -x $DAEMON || exit 0
case "$1" in
start)
$DAEMON start
sleep 1
$DNSSER restart
touch $LOCK
sleep 1
/sbin/ifconfig tap_soft $TAP_ADDR
;;
stop)
$DAEMON stop
rm $LOCK
;;
restart)
$DAEMON stop
sleep 3
$DAEMON start
sleep 1
$DNSSER restart
sleep 1
/sbin/ifconfig tap_soft $TAP_ADDR
;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0
' > /etc/init.d/vpnserver
echo "UPDATING DHCP AND DNS SETTINGS"
echo 'interface=tap_soft
dhcp-range=tap_soft,192.168.7.2,192.168.7.254,12h
dhcp-option=tap_soft,3,192.168.7.1
port=0
dhcp-option=option:dns-server,1.1.1.1,1.0.0.1,8.8.8.8,8.8.4.4' >> /etc/dnsmasq.conf
echo "UPDATING IP FORWARDING"
echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/ipv4_forwarding.conf
sysctl --system
echo "SETTING UP FIREWALL"
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
apt-get -y install iptables-persistent
echo '# Generated by iptables-save v1.6.1 on Tue Jan  8 06:07:58 2019
*nat
:PREROUTING ACCEPT [4:4686]
:INPUT ACCEPT [4:4686]
:OUTPUT ACCEPT [9:786]
:POSTROUTING ACCEPT [9:786]
-A POSTROUTING -s 192.168.7.0/24 -o ens4 -j MASQUERADE
COMMIT
# Completed on Tue Jan  8 06:07:58 2019
# Generated by iptables-save v1.6.1 on Tue Jan  8 06:07:58 2019
*filter
:INPUT ACCEPT [8906:113717181]
-A INPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT
-A INPUT -s 192.168.7.0/24 -j DROP
:FORWARD ACCEPT [0:0]
-A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
-A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
-A FORWARD -m string --algo bm --string "peer_id=" -j DROP
-A FORWARD -m string --algo bm --string ".torrent" -j DROP
-A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
-A FORWARD -m string --algo bm --string "torrent" -j DROP
-A FORWARD -m string --algo bm --string "announce" -j DROP
-A FORWARD -m string --algo bm --string "info_hash" -j DROP
-A FORWARD -m string --string "get_peers" --algo bm -j DROP
-A FORWARD -m string --string "announce_peer" --algo bm -j DROP
-A FORWARD -m string --string "find_node" --algo bm -j DROP
-A FORWARD -s 192.168.7.0/24 -d 192.168.7.0/24 -j DROP
:OUTPUT ACCEPT [7532:12168496]
-A OUTPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT
-A OUTPUT -d 192.168.7.0/24 -j DROP
:sshguard - [0:0]
COMMIT
# Completed on Tue Jan  8 06:07:58 2019 ' > /etc/iptables/rules.v4
echo "INSTALLING CRONTAB"
echo "@reboot /etc/init.d/vpnserver restart
@daily apt-get update && apt-get upgrade -y && /sbin/shutdown -r now" > /home/my-crontab
crontab /home/my-crontab
chmod +x /etc/init.d/vpnserver
/etc/init.d/vpnserver restart
echo "SETUP COMPLETE"