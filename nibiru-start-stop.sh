#!/bin/bash

#Kasun Rathnayak/kasun.rathnayaka@pearson.com

echo "##################################################"
echo  "This Script use for stop/start niburu instances"
echo "##################################################"
echo ""

read -p "Enter peroot username :" peroot
stty -echo
read -p "Password: " passwd; echo
stty echo

curl -v -H "Content-Type: application/json" -X GET -u $peroot:$passwd https://nibiru-prod.prsn.us/api/instances/ | grep hostname > servernew.txt

echo "server list:"
cat servernew.txt | cut -d "." -f1 > server.txt
cat server.txt |  awk '{print $2}' | cut  -d "\"" -f2
echo ""
rm servernew.txt

read -p  "Enter team ID/filtername  for get niburu server list :" team
cat server.txt | grep $team | awk '{print $2}' | cut  -d "\"" -f2 > start-stop.txt
rm server.txt
cat start-stop.txt



read -p "Please mention you requiment / stop (s) start (r) :" req

if [ "$req" = "r" ]
	then

	read -p "Do you want to start above instance(y/n) :" answer

	if [ "$answer" = "y" ]
	then

		while read p; do
  			curl -v -H "Content-Type: application/json" -X PUT -d '{"state":"running"}' -u $peroot:$passwd https://nibiru-prod.prsn.us/api/instances/$p
		done <start-stop.txt
		rm start-stop.txt
		echo "Done.."

	else
    		echo "cancel this action"
	fi

elif [ "$req" = "s" ]
	then

	read -p "Do you want to stop  above instance(y/n) :" answer

        if [ "$answer" = "y" ]
        then

                while read p; do
                        curl -v -H "Content-Type: application/json" -X PUT -d '{"state":"stopped"}' -u $peroot:$passwd https://nibiru-prod.prsn.us/api/instances/$p
                done <start-stop.txt
                rm start-stop.txt
                echo "Done.."

        else
                echo "cancel this action"
        fi

else
	echo "cancel this action"
	fi

