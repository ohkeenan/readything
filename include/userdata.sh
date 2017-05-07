#!/bin/bash

# Setup EC2 Instance
# Note: Much of this will be pre-configured AMI after

cat > $OUTPUT/userdata.txt <<- EOF

#!/bin/bash


# Update Instance
yum update -y
yum-config-manager --enable epel
cat > /etc/yum.repos.d/maria.repo << EOG
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/5.5/centos6-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOG
yum update -y
rpm -ivh http://repo.ajenti.org/ajenti-repo-1.0-1.noarch.rpm
yum install -y MariaDB-server MariaDB-client gcc openssl-devel python-devel openldap-devel gcc libstdc++-devel gcc-c++ fuse fuse-devel curl-devel libxml2-devel mailcap automake git
pip install --upgrade pip

# Install Ajenti
/usr/local/bin/pip install ajenti
yum install -y ajenti
yum install -y ajenti-v ajenti-v-mail ajenti-v-nginx ajenti-v-mysql ajenti-v-php7.0-fpm ajenti-v-php-fpm
chkconfig ajenti on

# Install s3fs (OR YAS3FS TBD)
git clone https://github.com/s3fs-fuse/s3fs-fuse
cd s3fs-fuse/
./autogen.sh
./configure --prefix=/usr --with-openssl
make
make install

mkdir /mnt/s3

#Create users and groups
groupadd www-data -g 140
useradd -r www-data -u 140 -g 140

groupadd s3fs -g 141
useradd -r s3fs -u 141 -g 141

# Mount s3fs
echo "nw-rt:/users/$CLIENTMD5/  /mnt/s3/  fuse.s3fs    _netdev,allow_other,iam_role=nw-rt-$CLIENT,uid=141,gid=141,umask=007,use_cache=/tmp   0   0" >> /etc/fstab
mount -a

# Bring PHP to version 7 and install modules for NextCloud
yum install -y php70-mysqlnd php70-fpm php70-ctype php70-dom php70-gd php70-mbstring php70-pdo php70-iconv php70-json php70-libxml php70-posix php70-zip php70-zlib php70-curl php70-bz2 php70-mcrypt php70-openssl php70-intl php70-fileinfo php70-exif php70-xml php70-imagick php70-json
pkill php-fpm

unlink /etc/alternatives/php
unlink /etc/alternatives/php-fpm
unlink /etc/alternatives/php-fpm-init
ln -s /usr/bin/php7 /etc/alternatives/php
ln -s /usr/sbin/php-fpm-7.0 /etc/alternatives/php-fpm
ln -s /etc/rc.d/init.d/php-fpm-7.0 /etc/alternatives/php-fpm-init

# Start MariaDB
service mysql start

# Secure setup
mysql -uroot -e "\
  UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root'; \
  DELETE FROM mysql.user WHERE User=''; \
  DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1'); \
  DROP DATABASE IF EXISTS test; \
  DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'; \
  FLUSH PRIVILEGES;"

# Create NextCloud database
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY '$MYSQL_NEXTCLOUD_PASSWORD'; CREATE DATABASE nextcloud; GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';"

# Make Main Domain
mkdir /srv/$DOMAIN
echo "It works!" > /srv/$DOMAIN/index.html

# Install websites to Ajenti
tar xjf /mnt/s3/config/ajenti.tar.bz2 -C /home/ec2-user/

# Move old php-fpm config because Ajenti auto generates. This will setup php-fpm
mv /etc/php-fpm.conf /etc/php-fpm.conf.bak

cp /home/ec2-user/$AJ/php-fpm.conf /etc/php-fpm.conf
service ajenti restart

sleep 10s
ajenti-ipc v apply

sleep 10s
ajenti-ipc v import /home/ec2-user/$AJ/website.json
sleep 2s
ajenti-ipc v import /home/ec2-user/$AJ/rainloop.json
sleep 2s
ajenti-ipc v import /home/ec2-user/$AJ/nextcloud.json
sleep 2s
ajenti-ipc v apply

service ajenti restart

pkill php-fpm
service php-fpm restart

usermod -aG s3fs www-data
usermod -aG s3fs ec2-user
usermod -aG www-data ec2-user

touch /var/log/php7-fpm.log
chown www-data:www-data /var/log/php7-fpm.log

# Install NextCloud
wget -qO- https://download.nextcloud.com/server/releases/nextcloud-11.0.3.tar.bz2 | tar xj -C /srv/
rm -rf /srv/nextcloud/data
ln -s /mnt/s3/data /srv/nextcloud/
echo "" > /srv/nextcloud/data/index.html
find /srv/nextcloud -type d -exec chmod 750 {} \;
find /srv/nextcloud -type f -exec chmod 640 {} \;

# Install RainLoop
mkdir /srv/rainloop && cd /srv/rainloop
wget -qO- http://repository.rainloop.net/installer.php | php
find /srv/rainloop -type d -exec chmod 750 {} \;
find /srv/rainloop -type f -exec chmod 640 {} \;

chown -R www-data:www-data /srv/$DOMAIN /srv/rainloop /srv/nextcloud

sudo -u www-data php /srv/nextcloud/occ maintenance:install --database "mysql" \
        --database-name "nextcloud" \
        --database-user "nextcloud" \
        --database-pass "$MYSQL_NEXTCLOUD_PASSWORD" \
        --admin-pass "$NEXTCLOUD_ADMIN_PASSWORD" \
        --admin-user "admin" \
        -v

sudo -u www-data php /srv/nextcloud/occ config:system:set trusted_domains 2 --value=cloud.$DOMAIN

EOF
