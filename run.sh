#!/bin/bash

/etc/init.d/apache2 start
/test.sh &
exec /usr/bin/mysqld_safe
