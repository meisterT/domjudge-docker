#!/bin/bash

# wait for mysql database
until $(mysqladmin ping > /dev/null 2>&1)
do
	sleep 1s;
done

# submit test programs
cd /domjudge-src/tests
make test-normal

# setup cgroups and chroot
cd /opt/domjudge/judgehost
bin/create_cgroups
bin/dj_make_chroot /chroot/domjudge amd64

# start judgedaemons
su domjudge -c "bin/judgedaemon -n 0&"
su domjudge -c "bin/judgedaemon -n 1&"
