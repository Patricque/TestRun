#! /bin/bash
clear
result="FAILED"   # Default to FAILED.
#Grab a parameter if it is passed; otherwise assume we're using the plog file in the current working directory
if  [[ $# -gt 0 ]]
	then logfile=$1
	else logfile=$PWD/processlog.plog
fi

result_file=$PWD/processlog_resultfile.txt

start_time=`cat $logfile | grep context | head -1 | awk -F',' '{print $2}' | awk -F'"' '{print $2}'`
MAC_address=`cat $logfile | grep context | head -1 | awk -F',' '{print $1}' | awk -F'"' '{print $2}'`

#Collect SPI-ROM ID aka GUID from MLB used during test
guid=`cat $logfile | grep context | tail -1 | awk -F',' '{print $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13}' | awk -F'"' '{print $2}'`

# count the number of failures in the plog file
typeset -i fail_count=`cat $logfile | grep 'msg-type="FAIL' | wc -l `

if [ $fail_count -lt 1 ]		
	then
	result="PASSED"
fi

if [ $fail_count -gt 0 ]
	then
	fail_data=`cat $logfile | grep 'msg-type="FAIL'`
	failure=`echo $fail_data | grep 'msg-type="FAIL' | head -1`
	TFF=`echo $fail_data | grep 'msg-type="FAIL' | head -1 | awk -F'ts' '{print $2}' | awk -F'\"' '{print $2}'`
	PACKAGE=`echo $fail_data | grep 'msg-type="FAIL' | head -1 | awk -F'Package_Name' '{print $2}' | awk -F'\"' '{print $2}'`
	TID=`echo $fail_data | grep 'msg-type="FAIL' | head -1 | awk -F'Extended_Code' '{print $2}' | awk -F'\"' '{print $2}'`
	location=`echo $fail_data | grep 'msg-type="FAIL' | head -1 | awk -F'location=' '{print $2}' | awk -F''"\'"'' '{print $2}'`
	failed_table=`echo $fail_data | grep 'msg-type="FAIL' | head -1 | awk -F'Table_Name=' '{print $2}' | awk -F'"' '{print $2}'`
	set_name=`echo $fail_data | grep 'msg-type="FAIL' | head -1 | awk -F'Set_Name=' '{print $2}' | awk -F'"' '{print $2}'`
	result_info=`echo $fail_data | grep 'msg-type="FAIL' | head -1 | awk -F'Result_Info_Str=' '{print $2}' | awk -F'"' '{print $2}'`
	FAILTYPE=`echo $fail_data | grep 'msg-type="FAIL' | head -1 | awk -F'Result_Info_Str=' '{print $2}' | awk -F'"' '{print $2}' | awk -F''"\'"'' '{print $2}' | awk -F' ' '{print $1}'`
	current_status="Failed - $PACKAGE $TID"
fi

#get serial numbers
SYSTEM_serial=`cat $logfile | grep class=\"Product\",model=\"MacPro6,1\",system-id= | head -1 | awk -F'serial-number=' '{print $2}' | awk -F'"' '{print $2}'`
CPU_serial=`cat $logfile | grep class=\"RiserCard\",type=\"cpu\",subtype=\"2S\",location=\"?\",riser-serial-number= | tail -1 |awk -F',' '{print $10}' |awk -F'\"' '{print $2}' |awk -F' ' '{print $1}'`
IO_serial=`cat $logfile | grep class=\"RiserCard\",type=\"io\",subtype=\"2S\",location=\"?\",riser-serial-number= | tail -1 |awk -F',' '{print $10}' |awk -F'\"' '{print $2}' |awk -F' ' '{print $1}'`
MLB_serial=`cat $logfile | grep class=\"MLB\",location=\"internal\",mlb-serial-number= | tail -1 |awk -F',' '{print $8}' |awk -F'\"' '{print $2}'`
GFXA_serial=`cat $logfile | grep class=\"RiserCard\",type=\"gfxa\",subtype=\"2S\",location=\"?\",riser-serial-number= | tail -1 |awk -F',' '{print $10}' |awk -F'\"' '{print $2}' |awk -F' ' '{print $1}'`
GFXB_serial=`cat $logfile | grep class=\"RiserCard\",type=\"gfxb\",subtype=\"2S\",location=\"?\",riser-serial-number= | tail -1 |awk -F',' '{print $10}' |awk -F'\"' '{print $2}' |awk -F' ' '{print $1}'`

#echo data pieces pulled from Phoenix logfile
echo "MLB_SN=$MLB_serial" 
echo "I/O_SN=$IO_serial"
echo "CPU_SN=$CPU_serial"
echo "GFXA_SN=$GFXA_serial"
echo -e "GFXB_SN=$GFXB_serial\n"
echo "SYSTEM_SERIAL=$SYSTEM_serial"
echo "GUID=$guid"
echo "MAC=$MAC_address"
echo -e "RESULT=$result\n"
echo "Failures Detected=$fail_count"
echo "TS=$start_time"

if [ $fail_count -gt 0 ];
	then
	echo "TFF=$TFF"
	echo "TABLE=$failed_table"
	echo "SETNAME=$set_name"
	echo "PACKAGE=$PACKAGE"
	echo "TID=$TID"
	echo "Location=$location"
	echo "FAILTYPE=$FAILTYPE"
	echo "RESULTINFO=$result_info"
	echo -e "\n$current_status\n"
	#echo "Additional fail data: $fail_data"
fi

#populate text file with results
echo "MLB_SN=$MLB_serial" > $result_file
echo "I/O_SN=$IO_serial" >> $result_file
echo "CPU_SN=$CPU_serial" >> $result_file
echo "GFXA_SN=$GFXA_serial" >> $result_file
echo "GFXB_SN=$GFXB_serial" >> $result_file
echo "SYSTEM_SERIAL=$SYSTEM_serial" >> $result_file
echo "GUID=$guid" >> $result_file
echo "MAC=$MAC_address" >> $result_file
echo "RESULT=$result" >> $result_file
echo "Failures Detected=$fail_count" >> $result_file
echo "TS=$start_time" >> $result_file

if [ $fail_count -gt 0 ];
	then
	echo "TFF=$TFF" >> $result_file
	echo "TABLE=$failed_table" >> $result_file
	echo "SETNAME=$set_name" >> $result_file
	echo "PACKAGE=$PACKAGE" >> $result_file
	echo "TID=$TID" >> $result_file
	echo "Location=$location" >> $result_file
	echo "FAILTYPE=$FAILTYPE" >> $result_file
	echo "RESULTINFO=$result_info" >> $result_file
	echo "MOREDATA: $fail_data" >> $result_file
fi
