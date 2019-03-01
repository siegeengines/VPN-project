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
      "port": 10808, // 监听端口
      "protocol": "socks", // 入口协议为 SOCKS 5
      "domainOverride": ["tls","http"],
      "settings": {
        "auth": "noauth"  //socks的认证设置，noauth 代表不认证，由于 socks 通常在客户端使用，所以这里不认证
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "vmess", // 出口协议
      "settings": {
        "vnext": [
		  {
            "address": "m1.shebao.gq", // 服务器地址，请修改为你自己的服务器 IP 或域名
            "port": 443,  // 服务器端口
            "users": [
              {
                "id": "a2d029c7-ee40-42bd-b526-69ddbaf8ea91",  // 用户 ID，必须与服务器端配置相同
                "alterId": 64, // 此处的值也应当与服务器相同
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
        "domain": ["geosite:cn"] // 中国大陆主流网站的域名
      },
      {
        "type": "chinaip",
        "outboundTag": "direct",
        "ip": [
          "geoip:cn",// 中国大陆的 IP
          "geoip:private" // 私有地址 IP，如路由器等
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
      "port": 10808, // 监听端口
      "protocol": "socks", // 入口协议为 SOCKS 5
      "domainOverride": ["tls","http"],
      "settings": {
        "auth": "noauth"  //socks的认证设置，noauth 代表不认证，由于 socks 通常在客户端使用，所以这里不认证
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "vmess", // 出口协议
      "settings": {
        "vnext": [
          {
            "address": "s1.shebao.gq", // 服务器地址，请修改为你自己的服务器 IP 或域名
            "port": 443,  // 服务器端口
            "users": [
              {
                "id": "a2d029c7-ee40-42bd-b526-69ddbaf8ea91",  // 用户 ID，必须与服务器端配置相同
                "alterId": 64, // 此处的值也应当与服务器相同
				"security": "auto"
              }
            ]
          },
		  {
            "address": "s2.shebao.gq", // 服务器地址，请修改为你自己的服务器 IP 或域名
            "port": 443,  // 服务器端口
            "users": [
              {
                "id": "a2d029c7-ee40-42bd-b526-69ddbaf8ea91",  // 用户 ID，必须与服务器端配置相同
                "alterId": 64, // 此处的值也应当与服务器相同
				"security": "auto"
              }
            ]
          },
		  {
            "address": "s3.shebao.gq", // 服务器地址，请修改为你自己的服务器 IP 或域名
            "port": 443,  // 服务器端口
            "users": [
              {
                "id": "a2d029c7-ee40-42bd-b526-69ddbaf8ea91",  // 用户 ID，必须与服务器端配置相同
                "alterId": 64, // 此处的值也应当与服务器相同
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
        "domain": ["geosite:cn"] // 中国大陆主流网站的域名
      },
      {
        "type": "chinaip",
        "outboundTag": "direct",
        "ip": [
          "geoip:cn",// 中国大陆的 IP
          "geoip:private" // 私有地址 IP，如路由器等
        ]
      }
    ]
  }
}' > /var/www/html/v2m.json