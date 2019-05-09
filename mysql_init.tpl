#!/bin/bash

#download source file
cd /tmp/
wget https://s3.amazonaws.com/aml-sample-data/banking.csv
echo "download csv file successfully" >> /tmp/haha_log.txt

#simple the data
awk -F "\"*,\"*" '{print $1","$2","$3}' banking.csv  > simple.csv
echo "process csv file successfully" >> /tmp/haha_log.txt   


#install mysql
yum install mysql -y
echo "install mysql finished" >> /tmp/haha_log.txt

#create table
mysql -B -u ${rds_username} -p${rds_password}  lab -h ${rds_endpoint}  -e "CREATE TABLE banking ( \
    id INT NOT NULL AUTO_INCREMENT, \
    age INT NOT NULL, \
    job VARCHAR(255) NOT NULL, \
  	marital VARCHAR(255) NOT NULL, \
    PRIMARY KEY (id) \
); " ;

echo "create table finished" >> /tmp/haha_log.txt
 

#load data from csv

mysql -B -u ${rds_username} -p${rds_password}  lab -h ${rds_endpoint}   -e "LOAD DATA LOCAL INFILE  'simple.csv'  INTO TABLE banking FIELDS TERMINATED BY ','  LINES TERMINATED BY '\n' IGNORE 1 ROWS (age,job,marital);"

echo "import data successfully" >> /tmp/haha_log.txt






