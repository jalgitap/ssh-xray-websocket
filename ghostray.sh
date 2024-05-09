#!/bin/bash

kubali="\033[38;2;0;128;0m"
GREEN="\033[0;32m"
kataa="\033[31;1m"
siani="\033[0;36m"
mwisho="\033[0m"
teal_color="\033[38;2;100;182;172m"
orange="\033[0;33m"
kidude="[+]"
PURPLE='\033[0;35m'
kubali_kidude="${kubali}${kidude}${mwisho}"
kataa_kidude="${kataa}${kidude}${mwisho}"

ghostraylink=$(bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root)
uuidp=ae98b711-f012-4014-bca8-691d2a72f15b

if [[ -f /usr/local/bin/xray ]]; then
    echo -e "${kataa}${kidude} Oops! It Seems Xray Is Already Installed!.. ${mwisho}"
    echo -e "🚀Removing Xray"
    rm -rf /usr/local/bin/xray
    echo -e "${kubali}${kidude}Done!${mwisho}"
    clear
    echo -e "$PURPLE🚀 Installing Ghostray Core.. $mwisho"
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root
else
    clear
    echo -e "$PURPLE🚀 Installing Ghostray Core.. $mwisho"
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root
fi    

sleep 2
clear
echo -e "${kubali_kidude}🚀${PURPLE}Building Xray Configs..${mwisho}"
cat <<EOF > /usr/local/etc/xray/vmtls.json
{
    "log": {
      "access": "/var/log/xray/access.log",
      "error": "/var/log/xray/error.log",
      "loglevel": "info"
    },
    "inbounds": [
      {
        "listen": "127.0.0.1",
        "port": 10085,
        "protocol": "dokodemo-door",
        "settings": {
          "address": "127.0.0.1"
        },
        "tag": "api"
      },
      {
        "listen": "127.0.0.1",
        "port": 3104,
        "protocol": "vmess",
        "settings": {
          "clients": [
            {
              "id": "a86e52da-0308-41f3-ab5b-0a9f2a0bbd3b",
              "alterId": 0,
              "email": ""
#vmtls

            }
          ],
          "decryption": "none"
        },
        "streamSettings": {
          "network": "ws",
          "security": "none",
          "wsSettings": {
            "path": "/vmtls",
            "headers": {
              "Host": ""
            }
          },
          "quicSettings": {},
          "sockopt": {
            "mark": 0,
            "tcpFastOpen": true
          }
        },
        "sniffing": {
          "enabled": true,
          "destOverride": [
            "http",
            "tls"
          ]
        }
      }
    ],
    "outbounds": [
      {
        "protocol": "freedom",
        "settings": {},
        "tag": "unblocked"
      },
      {
        "protocol": "blackhole",
        "settings": {},
        "tag": "blocked"
      }
    ],
    "routing": {
      "rules": [
        {
          "type": "field",
          "ip": [
            "0.0.0.0/8",
            "10.0.0.0/8",
            "100.64.0.0/10",
            "169.254.0.0/16",
            "172.16.0.0/12",
            "192.0.0.0/24",
            "192.0.2.0/24",
            "192.168.0.0/16",
            "198.18.0.0/15",
            "198.51.100.0/24",
            "203.0.113.0/24",
            "::1/128",
            "fc00::/7",
            "fe80::/10"
          ],
          "outboundTag": "blocked"
        },
        {
          "inboundTag": ["api"],
          "outboundTag": "api",
          "type": "field"
        }
      ],
      "domainStrategy": "IPOnDemand",
      "balancers": [
        {
          "tag": "blocked",
          "selector": [
            "blocked"
          ]
        }
      ]
    },
    "stats": {},
    "api": {
      "services": [
        "StatsService"
      ],
      "tag": "api"
    },
    "policy": {
      "levels": {
        "0": {
          "statsUserDownlink": true,
          "statsUserUplink": true
        }
      },
      "system": {
        "statsInboundUplink": true,
        "statsInboundDownlink": true,
        "statsOutboundUplink": true,
        "statsOutboundDownlink": true
      }
    }
  }
  
EOF

cat <<EOF > /usr/local/etc/xray/vmntls.json
{
    "log": {
      "access": "/var/log/xray/access.log",
      "error": "/var/log/xray/error.log",
      "loglevel": "info"
    },
    "inbounds": [
      {
        "listen": "127.0.0.1",
        "port": 10085,
        "protocol": "dokodemo-door",
        "settings": {
          "address": "127.0.0.1"
        },
        "tag": "api"
      },
      {
        "listen": "127.0.0.1",
        "port": 3105,
        "protocol": "vmess",
        "settings": {
          "clients": [
            {
              "id": "a86e52da-0308-41f3-ab5b-0a9f2a0bbd3b",
              "alterId": 0,
              "email": ""
#vmntls

            }
          ],
          "decryption": "none"
        },
        "streamSettings": {
          "network": "ws",
          "security": "none",
          "wsSettings": {
            "path": "/vmntls",
            "headers": {
              "Host": ""
            }
          },
          "quicSettings": {},
          "sockopt": {
            "mark": 0,
            "tcpFastOpen": true
          }
        },
        "sniffing": {
          "enabled": true,
          "destOverride": [
            "http",
            "tls"
          ]
        }
      }
    ],
    "outbounds": [
      {
        "protocol": "freedom",
        "settings": {},
        "tag": "unblocked"
      },
      {
        "protocol": "blackhole",
        "settings": {},
        "tag": "blocked"
      }
    ],
    "routing": {
      "rules": [
        {
          "type": "field",
          "ip": [
            "0.0.0.0/8",
            "10.0.0.0/8",
            "100.64.0.0/10",
            "169.254.0.0/16",
            "172.16.0.0/12",
            "192.0.0.0/24",
            "192.0.2.0/24",
            "192.168.0.0/16",
            "198.18.0.0/15",
            "198.51.100.0/24",
            "203.0.113.0/24",
            "::1/128",
            "fc00::/7",
            "fe80::/10"
          ],
          "outboundTag": "blocked"
        },
        {
          "inboundTag": ["api"],
          "outboundTag": "api",
          "type": "field"
        }
      ],
      "domainStrategy": "IPOnDemand",
      "balancers": [
        {
          "tag": "blocked",
          "selector": [
            "blocked"
          ]
        }
      ]
    },
    "stats": {},
    "api": {
      "services": [
        "StatsService"
      ],
      "tag": "api"
    },
    "policy": {
      "levels": {
        "0": {
          "statsUserDownlink": true,
          "statsUserUplink": true
        }
      },
      "system": {
        "statsInboundUplink": true,
        "statsInboundDownlink": true,
        "statsOutboundUplink": true,
        "statsOutboundDownlink": true
      }
    }
  }
  
EOF

cat <<EOF > /usr/local/etc/xray/vltls.json
{
    "log": {
      "access": "/var/log/xray/access2.log",
      "error": "/var/log/xray/error.log",
      "loglevel": "info"
    },
    "inbounds": [
      {
        "listen": "127.0.0.1",
        "port": 10085,
        "protocol": "dokodemo-door",
        "settings": {
          "address": "127.0.0.1"
        },
        "tag": "api"
      },
      {
        "listen": "127.0.0.1",
        "port": 3106,
        "protocol": "vless",
        "settings": {
          "clients": [
            {
              "id": "a86e52da-0308-41f3-ab5b-0a9f2a0bbd3b",
              "alterId": 0,
              "email": ""
#vltls

            }
          ],
          "decryption": "none"
        },
        "streamSettings": {
          "network": "ws",
          "security": "none",
          "wsSettings": {
            "path": "/vltls",
            "headers": {
              "Host": ""
            }
          },
          "quicSettings": {},
          "sockopt": {
            "mark": 0,
            "tcpFastOpen": true
          }
        },
        "sniffing": {
          "enabled": true,
          "destOverride": [
            "http",
            "tls"
          ]
        }
      }
    ],
    "outbounds": [
      {
        "protocol": "freedom",
        "settings": {},
        "tag": "unblocked"
      },
      {
        "protocol": "blackhole",
        "settings": {},
        "tag": "blocked"
      }
    ],
    "routing": {
      "rules": [
        {
          "type": "field",
          "ip": [
            "0.0.0.0/8",
            "10.0.0.0/8",
            "100.64.0.0/10",
            "169.254.0.0/16",
            "172.16.0.0/12",
            "192.0.0.0/24",
            "192.0.2.0/24",
            "192.168.0.0/16",
            "198.18.0.0/15",
            "198.51.100.0/24",
            "203.0.113.0/24",
            "::1/128",
            "fc00::/7",
            "fe80::/10"
          ],
          "outboundTag": "blocked"
        },
        {
          "inboundTag": ["api"],
          "outboundTag": "api",
          "type": "field"
        }
      ],
      "domainStrategy": "IPOnDemand",
      "balancers": [
        {
          "tag": "blocked",
          "selector": [
            "blocked"
          ]
        }
      ]
    },
    "stats": {},
    "api": {
      "services": [
        "StatsService"
      ],
      "tag": "api"
    },
    "policy": {
      "levels": {
        "0": {
          "statsUserDownlink": true,
          "statsUserUplink": true
        }
      },
      "system": {
        "statsInboundUplink": true,
        "statsInboundDownlink": true,
        "statsOutboundUplink": true,
        "statsOutboundDownlink": true
      }
    }
  }
  
EOF

cat <<EOF > /usr/local/etc/xray/vlntls.json
{
    "log": {
      "access": "/var/log/xray/access2.log",
      "error": "/var/log/xray/error.log",
      "loglevel": "info"
    },
    "inbounds": [
      {
        "listen": "127.0.0.1",
        "port": 10085,
        "protocol": "dokodemo-door",
        "settings": {
          "address": "127.0.0.1"
        },
        "tag": "api"
      },
      {
        "listen": "127.0.0.1",
        "port": 3107,
        "protocol": "vless",
        "settings": {
          "clients": [
            {
              "id": "a86e52da-0308-41f3-ab5b-0a9f2a0bbd3b",
              "alterId": 0,
              "email": ""
#vlntls

            }
          ],
          "decryption": "none"
        },
        "streamSettings": {
          "network": "ws",
          "security": "none",
          "wsSettings": {
            "path": "/vlntls",
            "headers": {
              "Host": ""
            }
          },
          "quicSettings": {},
          "sockopt": {
            "mark": 0,
            "tcpFastOpen": true
          }
        },
        "sniffing": {
          "enabled": true,
          "destOverride": [
            "http",
            "tls"
          ]
        }
      }
    ],
    "outbounds": [
      {
        "protocol": "freedom",
        "settings": {},
        "tag": "unblocked"
      },
      {
        "protocol": "blackhole",
        "settings": {},
        "tag": "blocked"
      }
    ],
    "routing": {
      "rules": [
        {
          "type": "field",
          "ip": [
            "0.0.0.0/8",
            "10.0.0.0/8",
            "100.64.0.0/10",
            "169.254.0.0/16",
            "172.16.0.0/12",
            "192.0.0.0/24",
            "192.0.2.0/24",
            "192.168.0.0/16",
            "198.18.0.0/15",
            "198.51.100.0/24",
            "203.0.113.0/24",
            "::1/128",
            "fc00::/7",
            "fe80::/10"
          ],
          "outboundTag": "blocked"
        },
        {
          "inboundTag": ["api"],
          "outboundTag": "api",
          "type": "field"
        }
      ],
      "domainStrategy": "IPOnDemand",
      "balancers": [
        {
          "tag": "blocked",
          "selector": [
            "blocked"
          ]
        }
      ]
    },
    "stats": {},
    "api": {
      "services": [
        "StatsService"
      ],
      "tag": "api"
    },
    "policy": {
      "levels": {
        "0": {
          "statsUserDownlink": true,
          "statsUserUplink": true
        }
      },
      "system": {
        "statsInboundUplink": true,
        "statsInboundDownlink": true,
        "statsOutboundUplink": true,
        "statsOutboundDownlink": true
      }
    }
  }
  
EOF

cat <<EOF > /usr/local/etc/xray/trtls.json
{
    "log": {
      "access": "/var/log/xray/access3.log",
      "error": "/var/log/xray/error.log",
      "loglevel": "info"
    },
    "inbounds": [
      {
        "listen": "127.0.0.1",
        "port": 10085,
        "protocol": "dokodemo-door",
        "settings": {
          "address": "127.0.0.1"
        },
        "tag": "api"
      },
      {
        "listen": "127.0.0.1",
        "port": 3108,
        "protocol": "trojan",
        "settings": {
          "clients": [
            {
              "id": "a86e52da-0308-41f3-ab5b-0a9f2a0bbd3b",
              "alterId": 0,
              "email": ""
#trtls

            }
          ],
          "decryption": "none"
        },
        "streamSettings": {
          "network": "ws",
          "security": "none",
          "wsSettings": {
            "path": "/trtls",
            "headers": {
              "Host": ""
            }
          },
          "quicSettings": {},
          "sockopt": {
            "mark": 0,
            "tcpFastOpen": true
          }
        },
        "sniffing": {
          "enabled": true,
          "destOverride": [
            "http",
            "tls"
          ]
        }
      }
    ],
    "outbounds": [
      {
        "protocol": "freedom",
        "settings": {},
        "tag": "unblocked"
      },
      {
        "protocol": "blackhole",
        "settings": {},
        "tag": "blocked"
      }
    ],
    "routing": {
      "rules": [
        {
          "type": "field",
          "ip": [
            "0.0.0.0/8",
            "10.0.0.0/8",
            "100.64.0.0/10",
            "169.254.0.0/16",
            "172.16.0.0/12",
            "192.0.0.0/24",
            "192.0.2.0/24",
            "192.168.0.0/16",
            "198.18.0.0/15",
            "198.51.100.0/24",
            "203.0.113.0/24",
            "::1/128",
            "fc00::/7",
            "fe80::/10"
          ],
          "outboundTag": "blocked"
        },
        {
          "inboundTag": ["api"],
          "outboundTag": "api",
          "type": "field"
        }
      ],
      "domainStrategy": "IPOnDemand",
      "balancers": [
        {
          "tag": "blocked",
          "selector": [
            "blocked"
          ]
        }
      ]
    },
    "stats": {},
    "api": {
      "services": [
        "StatsService"
      ],
      "tag": "api"
    },
    "policy": {
      "levels": {
        "0": {
          "statsUserDownlink": true,
          "statsUserUplink": true
        }
      },
      "system": {
        "statsInboundUplink": true,
        "statsInboundDownlink": true,
        "statsOutboundUplink": true,
        "statsOutboundDownlink": true
      }
    }
  }
  
EOF

cat <<EOF > /usr/local/etc/xray/trntls.json
{
    "log": {
      "access": "/var/log/xray/access3.log",
      "error": "/var/log/xray/error.log",
      "loglevel": "info"
    },
    "inbounds": [
      {
        "listen": "127.0.0.1",
        "port": 10085,
        "protocol": "dokodemo-door",
        "settings": {
          "address": "127.0.0.1"
        },
        "tag": "api"
      },
      {
        "listen": "127.0.0.1",
        "port": 3109,
        "protocol": "trojan",
        "settings": {
          "clients": [
            {
              "id": "a86e52da-0308-41f3-ab5b-0a9f2a0bbd3b",
              "alterId": 0,
              "email": ""
#trntls

            }
          ],
          "decryption": "none"
        },
        "streamSettings": {
          "network": "ws",
          "security": "none",
          "wsSettings": {
            "path": "/trntls",
            "headers": {
              "Host": ""
            }
          },
          "quicSettings": {},
          "sockopt": {
            "mark": 0,
            "tcpFastOpen": true
          }
        },
        "sniffing": {
          "enabled": true,
          "destOverride": [
            "http",
            "tls"
          ]
        }
      }
    ],
    "outbounds": [
      {
        "protocol": "freedom",
        "settings": {},
        "tag": "unblocked"
      },
      {
        "protocol": "blackhole",
        "settings": {},
        "tag": "blocked"
      }
    ],
    "routing": {
      "rules": [
        {
          "type": "field",
          "ip": [
            "0.0.0.0/8",
            "10.0.0.0/8",
            "100.64.0.0/10",
            "169.254.0.0/16",
            "172.16.0.0/12",
            "192.0.0.0/24",
            "192.0.2.0/24",
            "192.168.0.0/16",
            "198.18.0.0/15",
            "198.51.100.0/24",
            "203.0.113.0/24",
            "::1/128",
            "fc00::/7",
            "fe80::/10"
          ],
          "outboundTag": "blocked"
        },
        {
          "inboundTag": ["api"],
          "outboundTag": "api",
          "type": "field"
        }
      ],
      "domainStrategy": "IPOnDemand",
      "balancers": [
        {
          "tag": "blocked",
          "selector": [
            "blocked"
          ]
        }
      ]
    },
    "stats": {},
    "api": {
      "services": [
        "StatsService"
      ],
      "tag": "api"
    },
    "policy": {
      "levels": {
        "0": {
          "statsUserDownlink": true,
          "statsUserUplink": true
        }
      },
      "system": {
        "statsInboundUplink": true,
        "statsInboundDownlink": true,
        "statsOutboundUplink": true,
        "statsOutboundDownlink": true
      }
    }
  }
  
EOF

cat <<EOF >/etc/systemd/system/vmtls.service
[Unit]
Description=XRAY-Websocket By Pixer Jason
Documentation=https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/vmtls.json
Restart=on-failure
RestartSec=3s
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF


cat <<EOF >/etc/systemd/system/vmntls.service
[Unit]
Description=XRAY-Websocket By Pixer Jason
Documentation=https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/vmntls.json
Restart=on-failure
RestartSec=3s
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF >/etc/systemd/system/vltls.service
[Unit]
Description=XRAY-Websocket By Pixer Jason
Documentation=https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/vltls.json
Restart=on-failure
RestartSec=3s
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF >/etc/systemd/system/vlntls.service
[Unit]
Description=XRAY-Websocket By Pixer Jason
Documentation=https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/vlntls.json
Restart=on-failure
RestartSec=3s
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF >/etc/systemd/system/trtls.service
[Unit]
Description=XRAY-Websocket By Pixer Jason
Documentation=https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/trtls.json
Restart=on-failure
RestartSec=3s
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF >/etc/systemd/system/trntls.service
[Unit]
Description=XRAY-Websocket By Pixer Jason
Documentation=https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/trntls.json
Restart=on-failure
RestartSec=3s
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF
rm -rf /usr/local/etc/xray/config.json
rm -rf /etc/systemd/system/xray.service
systemctl daemon-reload
systemctl enable vmtls
systemctl enable vmntls
systemctl enable vltls
systemctl enable vlntls
systemctl enable trtls
systemctl enable trntls
systemctl start vmtls
systemctl start vmntls
systemctl start vltls
systemctl start vlntls
systemctl start trtls
