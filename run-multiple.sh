#!/bin/bash
shopt -s extglob
runhandling(){
#sudo rm /home/sshakeri/master/launch/request/typeA/duration/*exp*.txt
#sudo rm /home/sshakeri/master/launch/request/typeB/duration/*exp*.txt
#sudo rm /home/sshakeri/master/launch/request/typeAandB/duration/*exp*.txt
iteration=1
totalexp="$1"
mix="$2"
overlay="$3"
bunches=(50) 
types=(1)
local folder
local exp=$(($totalexp+1))

for typ in "${types[@]}" 
do
echo "$typ"
 if [ ${typ} == "1" ];
 then
        folder="typeA"
 fi
 if [ ${typ} == "2" ];
 then
          folder="typeB"
 fi
 if [ ${typ} == "3" ];
 then
          folder="typeAandB"
 fi

	for bunch in "${bunches[@]}" 
	do
           iteration=1
	   echo $bunch
           sudo systemctl stop docker
           sudo systemctl start docker
           ssh sshakeri@145.100.131.12 sudo systemctl stop docker
           ssh sshakeri@145.100.131.12 sudo systemctl start docker	   
           while [ $iteration -lt $exp ]; do
	       mixnumber=0
               while [ $mixnumber -lt $mix ];do 
	       mixnumber=$(($mixnumber+1))
               #sudo systemctl stop docker
               #sudo systemctl start docker
               #ssh sshakeri@145.100.131.12 sudo systemctl stop docker
               #ssh sshakeri@145.100.131.12 sudo systemctl start docker
	       t_accumulative_start="$(date -d "$(date -u)" "+%s")"
               bash  /home/sshakeri/master/$overlay/request/$folder/req-handling.sh "$bunch" "$typ" "$iteration" "$mixnumber" "$3"
               sleep 100
	       #iteration=$(($iteration+1))
	       lines=$(wc -l "/home/sshakeri/master/$overlay/request/$folder/log.txt" | awk '{ print $1 }')
	       while [[ "$lines" -lt "$bunch" ]]; do
                       lines=$(wc -l "/home/sshakeri/master/$overlay/request/$folder/log.txt"| awk '{ print $1 }')
		       sleep 1 
		       echo "hello"
		       echo $lines
	       done
               t_accumulative_end="$(date -d "$(date -u)" "+%s")"
	       t_accumulation=$(($t_accumulative_end-$t_accumulative_start))
	       echo $t_accumulation > "/home/sshakeri/master/$overlay/request/$folder/duration/accumulation-bunch$bunch-mix$mixnumber-exp$iteration.txt"
	       sleep 60
	       #bash  /home/sshakeri/master/delete.sh "$overlay" "$folder" "$bunch" "$mixnumber"
	       #sleep 10
              done
	       iteration=$(($iteration+1))
	       echo $t_accumulation
	      #echo "$lines"
done
done
done
sleep 10
for typ in "${types[@]}"
do
echo "$typ"
 if [ ${typ} == "1" ];
 then
        folder="typeA"
 fi
 if [ ${typ} == "2" ];
 then
          folder="typeB"
 fi
 if [ ${typ} == "3" ];
 then
          folder="typeAandB"
 fi
for bunch in "${bunches[@]}"
        do
           iteration=1
           echo $bunch  
           while [ $iteration -lt $exp ]; do
               mixnumber=0
	       while [ $mixnumber -lt $mix ];do
               mixnumber=$(($mixnumber+1))
               sudo python3  /home/sshakeri/master/$overlay/request/$folder/average.py "$iteration" "$bunch" "$folder" "$mixnumber" "$overlay"
	       #mixnumber=$(($mixnumber+1))
       done
       iteration=$(($iteration+1))
       done
       done
done
#python3 /home/sshakeri/master/bunch_policy.py "$overlay"
}


if [[ $# -lt "3" ]]; then
echo "Usage: $0 <number of experiements> <numeb of mixes> <calico or swarm>"
  exit 1
else
  runhandling "$1" "$2" "$3"
  fi
