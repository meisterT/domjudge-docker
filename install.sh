#!/bin/bash

set -e
set -x

# add non-privileged user for running judgedaemons
adduser --disabled-password domjudge
groupadd domjudge-run

# create our own copy of the source code
git clone /domjudge.git /domjudge-src
chown -R domjudge domjudge-src


# configure, make and install domserver
cd /domjudge-src
su domjudge ./bootstrap
su domjudge ./configure
su domjudge -c 'make domserver'
make install-domserver

# start and wait for mysql database
mysqld_safe &
until $(mysqladmin ping > /dev/null 2>&1)
do
	sleep 1s;
done

# setup database and add special team user
# FIXME: user random password
cd /opt/domjudge/domserver
bin/dj_setup_database install
echo 'INSERT INTO user (userid, username, name, password, teamid) VALUES (3, "dummy", "dummy user for example team", "$2y$10$..uuk/OfkCe.H6xDocWvgOwT5AvrYKQk4lo0s25iZHGPrcLzru3xS", 2)' | mysql domjudge
echo "INSERT INTO userrole (userid, roleid) VALUES (3, 3);" | mysql domjudge

mysqladmin shutdown

echo "machine localhost login dummy password dummy" > ~/.netrc
cp /opt/domjudge/domserver/etc/apache.conf /etc/apache2/conf-enabled/

# add users for judgedaemons (FIXME: make them configurable)
useradd -d /nonexistent -g nogroup -s /bin/false domjudge-run

# make and install judgehost
cd /domjudge-src/
su domjudge -c 'make judgehost'
make install-judgehost
cd /opt/domjudge/judgehost/
cp /opt/domjudge/judgehost/etc/sudoers-domjudge /etc/sudoers.d/
sed -i -e "s/''/'chroot-startstop.sh'/" etc/judgehost-config.php # FIXME
