#!/bin/sh
MYHOME=/home/vagrant
MYSQL_PASSWORD=system

# bundlerがionotify絡みでエラーになるケースがあるのでその対策
echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf
sysctl -p

apt-get update

sudo -u vagrant cat > ${MYHOME}/.bash_login <<'EOF'
PATH=${PATH}:${HOME}/.gem/ruby/2.5.0/bin:${HOME}/webroot/vendor/bundle/ruby/2.5.0/bin/
screen -rx
EOF

sudo -u vagrant cat > ${MYHOME}/.gemrc <<EOF
install: --no-document --user-install
update: --no-document
EOF

sudo -u vagrant cat > ${MYHOME}/.railsrc <<EOF
--skip-test
--skip-coffee
--skip-sprockets
--skip-turbolinks
--webpack=vue
--database=mysql
EOF

apt-get install -y language-pack-ja
update-locale LANG=ja_JP.UTF-8

apt-get -y install screen
sudo -iu vagrant cat > ${MYHOME}/.screenrc <<EOF
escape ^t^t
termcapinfo xterm* ti@:te@
defscrollback 65536
vbell off
EOF

export DEBIAN_FRONTEND=noninteractive # supress debconf error message
echo "mysql-server-5.7 mysql-server/root_password password ${MYSQL_PASSWORD}" | debconf-set-selections
echo "mysql-server-5.7 mysql-server/root_password_again password ${MYSQL_PASSWORD}" | debconf-set-selections
apt-get -y install mysql-server libmysqlclient-dev
sed -i -e 's/\(bind-address\s*= \).*/\10.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql.service
mysql -u root -p -e "grant all on *.* to root@'%' identified by 'system'"

apt-get -y install build-essential
apt-get -y install ruby ruby-dev
apt-get -y install graphviz

sudo -iu vagrant <<EOF
cd ${MYHOME}/approot
gem install bundle
bundle install
EOF
