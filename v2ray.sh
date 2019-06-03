#!/bin/sh
apt-get -y install build-essential nano
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
echo "SETTING UP TIME"
export DEBIAN_FRONTEND=noninteractive
apt-get install -y tzdata
ln -fs /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata
echo "SETUP COMPLETE"