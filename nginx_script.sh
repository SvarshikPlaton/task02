#/bin/bash

yum update -y --exclude=kernel*

yum install -y nginx
systemctl enable nginx
systemctl start nginx

mkdir /www
yum install -y policycoreutils-python-utils
semanage fcontext -a -t httpd_sys_content_t "/www(/.*)?"
restorecon -Rv /www

firewall-cmd --permanent --zone=public --add-port=81/tcp
firewall-cmd --reload
semanage port -a -t http_port_t -p tcp 81
semanage port -a -t http_port_t -p tcp 8081
setsebool -P httpd_can_network_relay 1

# index.html
echo "<html>
<head><title>Welcome to nginx!</title></head>
<body>
<h1>Hello from Nginx</h1>
</body>
</html>" > /www/index.html

# nginx config
echo "http {
    upstream apache_servers {
        server 192.168.56.101:8081;
        server 192.168.56.102:8081;
    }
    server {
        listen 81;
        location /webapp {
            proxy_pass http://apache_servers/;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
        }
        location / {
            root /www;
            index index.html;
        }
    }
}
events {
    worker_connections 1024;
}" > /etc/nginx/nginx.conf

systemctl restart nginx
