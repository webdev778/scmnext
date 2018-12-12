apt-get update

sudo -u vagrant cat > ${MYHOME}/.bash_login <<'EOF'
screen -rx
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

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get -y install yarn

apt-get -y install build-essential

sudo -iu vagrant <<EOF
cd ${MYHOME}/approot
yarn install
EOF
