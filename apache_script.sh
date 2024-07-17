#/bin/bash

sudo yum update -y --exclude=kernel*

yum install -y httpd
systemctl enable httpd
systemctl start httpd

mkdir /webapp
yum install -y policycoreutils-python-utils
semanage fcontext -a -t httpd_sys_content_t "/webapp(/.*)?"
restorecon -Rv /webapp

firewall-cmd --permanent --zone=public --add-port=8081/tcp
firewall-cmd --reload
semanage port -a -t http_port_t -p tcp 8081

# index.html
echo "<html>
<head><title>Welcome to Apache!</title></head>
<body>
<h1>Hello from Apache Tomcat</h1>
</body>
</html>" > /webapp/index.html

# apache config
echo "Listen 8081

<VirtualHost *:8081>
        DocumentRoot "/webapp"
        DirectoryIndex index.html
        ServerName localhost
        <Directory "/webapp">
                AllowOverride All
                Require all granted
        </Directory>
</VirtualHost>" > /etc/httpd/conf.d/site.conf

systemctl restart httpd