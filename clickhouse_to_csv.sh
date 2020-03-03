#!/bin/bash
###########################################
#   Extraction from Clickhouse to CSV  	  #
###########################################
#  + collecting data daily using cron     #
###########################################
#   Created by Kirill Rudenko	            #
###########################################

#you can add as may SQL queries as you need
function get_data(){
	if [ -f query.sql ]; then
		cat query.sql | clickhouse-client -mn
	else
	echo "SELECT [your_column\columns] FROM [schema].[table] ORDER BY(optional) [your_column] INTO OUTFILE '/path/to/file.csv';" > query.sql
	cat query.sql | clickhouse-client -mn
	fi
}

function timestamp(){
	if [ -f /path/to/file.csv ]; then 
		mv /path/to/file.csv /path/to/file__$(date +%b_%d_%Y_%Hh%Mm).csv
		#below one is optional
    chown YOUR_USER: /path/to/file.csv*.* 
	fi
}

function install(){
	(crontab -l ; echo "0 10 * * * /bin/bash /root/clickhouse_to_csv.sh") | crontab -
}


function main(){
	DONE=$(crontab -l |grep -c "clickhouse_to_csv.sh")
	if [ $DONE = 1 ]; then 
	 get_data
	 timestamp
	else
	 install
	 get_data	
	 timestamp
	fi
}

main
