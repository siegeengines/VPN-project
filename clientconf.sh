#!/bin/sh
apt-get install lamp-server^
echo '{
  "dns": {
    "servers": [
		"1.1.1.1",
		"1.0.0.1",
		"8.8.8.8",
        "8.8.4.4"
    ]
  },
  "inbounds": [
    {
      "port": 10808, 
      "protocol": "socks", 
      "domainOverride": ["tls","http"],
      "settings": {
        "auth": "noauth" 
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "vmess", 
      "settings": {
        "vnext": [
		  {
            "address": "m1.shebao.gq",
            "port": 443, 
            "users": [
              {
                "id": "a2d029c7-ee40-42bd-b526-69ddbaf8ea91", 
                "alterId": 64, 
				"security": "auto"
              }
            ]
          }
        ]
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
      },
	  "mux": {
		"enabled": true,
		"concurrency": 2
	  }
	}
  ],
"routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [
      {
        "type": "field",
        "outboundTag": "direct",
        "domain": ["geosite:cn"] 
      },
      {
        "type": "chinaip",
        "outboundTag": "direct",
        "ip": [
          "geoip:cn",
          "geoip:private" 
        ]
      }
    ]
  }
}' > /var/www/html/v2s.json
echo '{
  "dns": {
    "servers": [
		"1.1.1.1",
		"1.0.0.1",
		"8.8.8.8",
        "8.8.4.4"
    ]
  },
  "inbounds": [
    {
      "port": 10808, 
      "protocol": "socks",
      "domainOverride": ["tls","http"],
      "settings": {
        "auth": "noauth"  
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "vmess", 
      "settings": {
        "vnext": [
          {
            "address": "s1.shebao.gq", 
            "port": 443, 
            "users": [
              {
                "id": "a2d029c7-ee40-42bd-b526-69ddbaf8ea91", 
                "alterId": 64, 
				"security": "auto"
              }
            ]
          },
		  {
            "address": "s2.shebao.gq", 
            "port": 443, 
            "users": [
              {
                "id": "a2d029c7-ee40-42bd-b526-69ddbaf8ea91", 
                "alterId": 64,
				"security": "auto"
              }
            ]
          },
		  {
            "address": "s3.shebao.gq",
            "port": 443, 
            "users": [
              {
                "id": "a2d029c7-ee40-42bd-b526-69ddbaf8ea91",  
                "alterId": 64, 
				"security": "auto"
              }
            ]
          }
        ]
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
      },
	  "mux": {
		"enabled": true,
		"concurrency": 2
	  }
	}
  ],
"routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [
      {
        "type": "field",
        "outboundTag": "direct",
        "domain": ["geosite:cn"] 
      },
      {
        "type": "chinaip",
        "outboundTag": "direct",
        "ip": [
          "geoip:cn",
          "geoip:private" 
        ]
      }
    ]
  }
}' > /var/www/html/v2m.json