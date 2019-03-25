#!/bin/bash

wget https://s3-us-west-2.amazonaws.com/joeshi/customer/motionglobal/lab.sql
echo "copy sql successfully" >> /tmp/haha_log.txt

yum install mysql -y
echo "install mysql finished" >> /tmp/haha_log.txt

mysql -h ${rds_endpoint} -u${rds_username} -p${rds_password} lab < lab.sql
echo "import data successfully" >> /tmp/haha_log.txt
