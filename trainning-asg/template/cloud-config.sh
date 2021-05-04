#!/bin/bash
yum install httpd -y
curl http://169.254.169.254/latest/meta-data/public-ipv4 >> /var/www/html/index.html

"v1" >> /var/www/html/index.html

systemctl start httpd

systemctl enable httpd