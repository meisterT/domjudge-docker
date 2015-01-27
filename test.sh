#!/bin/bash

# wait for mysql database
until $(mysqladmin ping > /dev/null 2>&1)
do
	sleep 1s;
done

# submit test programs
cd /domjudge-src/tests
make check test-stress

# setup cgroups and chroot
cd /opt/domjudge/judgehost
bin/create_cgroups

# start judgedaemons
su domjudge -c "bin/judgedaemon -n 0&"
su domjudge -c "bin/judgedaemon -n 1&"
