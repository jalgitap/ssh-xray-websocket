#!/bin/bash

kubali="\033[38;2;0;128;0m"
GREEN="\033[0;32m"
kataa="\033[31;1m"
siani="\033[0;36m"
mwisho="\033[0m"
teal_color="\033[38;2;100;182;172m"
orange="\033[0;33m"
PURPLE='\033[0;35m'
kidude="[+]"
kubali_kidude="${kubali}${kidude}${mwisho}"
kataa_kidude="${kataa}${kidude}"
# install badvpn
clear
echo -e "${kubali_kidude}${PURPLE}🚀Installing WebServer..${mwisho}"
sleep 2
# install webserver
apt -y install nginx
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default

rm -rf /etc/nginx/nginx.conf

wget -O /etc/nginx/nginx.conf http://sc2.asle.me/nginx.conf
##our configuration                                      
cat <<'EOF' > /etc/nginx/conf.d/server.conf
    server {
             listen 80;
             listen [::]:80;
             listen 443 ssl;
             listen [::]:443;
             server_name 127.0.0.1 localhost;
             server_tokens on;
             ssl_certificate /etc/certificates/main.crt;
             ssl_certificate_key /etc/certificates/main.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
             root /usr/share/nginx/html;

    location = / {
        proxy_pass http://127.0.0.1:3103;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_buffering off;
        chunked_transfer_encoding off;
    }

    location = /vmtls {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:3104;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_buffering off;
        chunked_transfer_encoding off;
    }
    location = /vmntls {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:3105;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_buffering off;
        chunked_transfer_encoding off;
    }
    location = /vltls {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:3106;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_buffering off;
        chunked_transfer_encoding off;
    }
    location = /vlntls {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:3107;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_buffering off;
        chunked_transfer_encoding off;
    }
    location = /trtls {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:3108;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_buffering off;
        chunked_transfer_encoding off;
    }
    location = /trntls {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:3109;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_buffering off;
        chunked_transfer_encoding off;
    }
    error_page 404 /not_found.html;
    location = /not_found.html {
        internal;
        root /var/www/html;
    }
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
}
EOF

/etc/init.d/nginx restart
