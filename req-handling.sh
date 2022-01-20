#!/bin/bash
shopt -s extglob
measure() {
 #kubectl delete pods --all
 bunchnum="$1"
 typ="$2"
 exp="$3"
 mix="$4"
 overlay="$5"
 iteration=1
 local folder
 if [ $typ == "1" ];
 then
        folder="typeA"
 fi
 if [ $typ == "2" ];
 then
          folder="typeB"
 fi
 if [ $typ == "3" ];
 then
          folder="typeAandB"
 fi
 rm /home/sshakeri/master/$5/request/$folder/log.txt
 #sudo systemctl stop docker
 #sudo systemctl start docker
 #sudo python3 /home/sshakeri/master/launch/request/genreq.py "$bunchnum" "$typ"
 #bash  /home/sshakeri/master/delete.sh "$overlay" "$folder" "$bunchnum" "$mix"
 local x=$(($bunchnum+1))
 local port=10
 while [ $iteration -lt $x ]; do
    bash  /home/sshakeri/master/$overlay/request/$folder/createcontainer.sh "$iteration" "$bunchnum" "$folder" "$exp" "$mix" "$overlay" "$port" &
    sleep 1
    iteration=$(($iteration+1))
#    port=$(($port+10))
done
}
if [[ $# -lt "5" ]]; then
echo "Usage: $0 <num-of-requests(bunch)> <type of request : A:1 B:2 AandB:3> <run_number> <mix_number> <overlay>"
  exit 1
else
  measure "$1" "$2" "$3" "$4" "$5"
fi
