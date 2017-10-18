#!/bin/bash

/etc/init.d/apache2 start
export SUBMITBASEURL="http://localhost/domjudge"
/test.sh &
exec /usr/bin/mysqld_safe
