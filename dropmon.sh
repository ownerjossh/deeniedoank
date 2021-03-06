#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi

MYIP=$(wget -qO- ipv4.icanhazip.com)

if [ $1 ]; then
	port_dropbear=$1
	log=/var/log/auth.log
	loginsukses='Password auth succeeded'
	echo ' '
	echo ' '
	echo "               Dropbear Users Login Monitor                    "
	echo "---------------------------------------------------------------"
	echo "    Date-time    |  PID      |  User Name      |  From Host    "
	echo "---------------------------------------------------------------" 
	pids=`ps ax |grep dropbear |grep  " $port_dropbear" |awk -F" " '{print $1}'`
	for pid in $pids
	do
		pidlogs=`grep $pid $log |grep "$loginsukses" |awk -F" " '{print $3}'`
		i=0
		for pidend in $pidlogs
		do
			let i=i+1
		done
		
		if [ $pidend ]; then
			login=`grep $pid $log |grep "$pidend" |grep "$loginsukses"`
			PID=$pid
			user=`echo $login |awk -F" " '{print $10}' | sed -r "s/'/ /g"`
			waktu=`echo $login |awk -F" " '{print $2,$3}'`
			while [ ${#waktu} -lt 13 ]
			do
				waktu=$waktu" "
			done
			
			while [ ${#user} -lt 16 ]
			do
				user=$user" "
			done
			
			while [ ${#PID} -lt 8 ]
			do
				PID=$PID" "
			done

			fromip=`echo $login |awk -F" " '{print $12}' |awk -F":" '{print $1}'`
			echo "  $waktu|  $PID | $user|  $fromip "
		fi
	done
	
	echo "----------------------------------------------------------------"
	echo " Ingin tendang user? Ketik kill -9 (angka PID)"
	echo " Misal: kill -9 1234 [enter]"
	echo "----------------------------------------------------------------"
	
	echo "    DEVELOPED BY Yusuf Ardiansyah and Elang overdosis    "
	echo "----------------------------------------------------------------"
	echo ""
else
	echo "  Gunakan perintah ./dropmon [port]"
	echo "  Contoh : ./dropmon 443"
	echo ""
fi

exit 0
