#!/bin/bash
shopt -s extglob
duration()
{ 

  local iteration="$1"
  local bunchnum="$2"
  local typ="$3"
  local exp="$4"
  local mix="$5"
  local overlay="$6"
  local port="$7"
  local folder="$3"
  input="req$iteration-bunch$bunchnum-mix$mix"
  file="/home/sshakeri/master/$overlay/request/$folder/$input-dataflow.txt"
  echo "$file"
  sudo docker container stop klm-req"$iteration"
  sudo docker container rm  klm-req"$iteration"
  ssh -tt  sshakeri@145.100.131.12 sudo docker container stop airfrance-req"$iteration"
  #sleep 1
  ssh -tt sshakeri@145.100.131.12 sudo docker container rm  airfrance-req"$iteration"
  #sleep 1
  sudo docker network remove my-overlay-network"$iteration"
  t_overlay_start="$(date -d "$(date -u)" "+%s")"
  echo "sudo docker network create --driver overlay  --subnet=10.10."$iteration".0/24  --attachable my-overlay-network"$iteration$bunchnum$mix""
  octet="$(($iteration+10))"
  sudo docker network create --driver overlay  --subnet=10.10."$octet".0/24  --attachable my-overlay-network"$iteration"
  while true; do
  ready1="$(sudo docker network ls | grep my-overlay-network$iteration | wc -l)"
  if [ "$ready1" -gt 0 ];
  then
	echo "overlay$iteration is ready"   
	break
 
  else 
       echo "overlay$iteration is not ready"
	sleep 1
  fi 

  done
  t_overlay_end="$(date -d "$(date -u)" "+%s")"
  t_container_start="$(date -d "$(date -u)" "+%s")"
  address1=10.10."$octet"."$(($iteration+100))"
  status="$(sudo  docker node inspect --format {{.Spec.Availability}} mc4)"
  if [ $status != "active" ];
  then
     	echo "it is drainnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn"
  fi 
  	echo "sudo docker run -itd --name=klm-req$iteration --network=my-overlay-network${iteration} sarashakeri/ubuntu-iperf:v1.5" > "command1-$input-exp$exp.sh"
        #sudo docker run -itd --name=klm-req"$iteration" --network="my-overlay-network${iteration}" --ip="$address1"  sarashakeri/ubuntu-iperf:v1.5
  	sudo chmod +x  "command1-$input-exp$exp.sh"
        bash "command1-$input-exp$exp.sh"
        #sudo rm "command1-$input-exp$exp.sh"
        #sleep  1
  #klm_ip="$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' klm-req$iteration)"
  #airfrance_ip="$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' airfrance-req$iteration)"
  address2=10.10."$octet"."$(($iteration+101))"
  echo "sudo docker run -itd  --name=airfrance-req$iteration --network=my-overlay-network${iteration} sarashakeri/ubuntu-iperf:v1.5" > "command2-$input-exp$exp.sh" 
  scp "command2-$input-exp$exp.sh" sshakeri@145.100.131.12:
  ssh -n -tt  sshakeri@145.100.131.12 sudo chmod +x  "command2-$input-exp$exp.sh"
  ssh -n -tt  sshakeri@145.100.131.12 bash "command2-$input-exp$exp.sh"
  #ssh -n -tt  sshakeri@145.100.131.12 sudo rm "command2-$input-exp$exp.sh"
  #t_container_end="$(date -d "$(date -u)" "+%s")"
  #klm_ip="$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' klm-req$iteration)"
  #airfrance_ip="$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' airfrance-req$iteration)"
  i=0
  while true; do
     	    echo "in while true" 
            first=$(sudo docker ps | grep  "klm-req$iteration" | wc -l)
            commandtemp="echo \$(sudo docker ps | grep  airfrance-req$iteration | wc -l) > temp2-$input-exp$exp.txt" 
            echo $commandtemp > "command4-$input-exp$exp.sh"
            echo "scp temp2-$input-exp$exp.txt sshakeri@145.100.130.149:" >> "command4-$input-exp$exp.sh"
            scp "command4-$input-exp$exp.sh" sshakeri@145.100.131.12:
            ssh -n -tt  sshakeri@145.100.131.12 sudo chmod +x  "command4-$input-exp$exp.sh"
            ssh -n -tt  sshakeri@145.100.131.12 bash  command4-$input-exp$exp.sh
            file2="/home/sshakeri/temp2-$input-exp$exp.txt" 
           while IFS= read -r line
          do 
            second=$line
           done < "$file2"


    if [[ $second -gt 0 ]] && [[ "$first" -gt 0 ]]; then
          break
    else
	   echo "it was elseeeeeeeeeeeeeeeeeeeeeeeee"
           if  [[ $first -eq 0 ]]; then
           sudo docker container stop klm-req"$iteration"
           sudo docker container rm  klm-req"$iteration"
           bash "command1-$input-exp$exp.sh"
           fi

           if  [[ $second -eq 0 ]]; then
           ssh -n -tt  sshakeri@145.100.131.12 sudo docker container stop airfrance-req"$iteration"
           ssh -n -tt sshakeri@145.100.131.12 sudo docker container rm  airfrance-req"$iteration"
           ssh -n -tt  sshakeri@145.100.131.12 bash "command2-$input-exp$exp.sh" 
           fi 

	   sleep 5
    fi
  done 
  t_container_end="$(date -d "$(date -u)" "+%s")"
  t_transfer_start="$(date -d "$(date -u)" "+%s")"
  while IFS= read -r line 
  do
    array=()
    for word in $line; do
      array+=("$word")
    done
    port=$(($port+1))
    if [ ${array[1]} == "airfrance" ];
    then
       echo "hello"
       #ssh -n -tt sshakeri@145.100.131.12 sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' airfrance-req1
       command="sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${array[1]}-req$iteration" 
       echo $command > "command3-$input-exp$exp.sh"
       scp "command3-$input-exp$exp.sh"  sshakeri@145.100.131.12: 
       #ssh -n -tt sshakeri@145.100.131.12 "${command}" > "command3-$input-exp$exp.sh"
       ssh -n -tt sshakeri@145.100.131.12 sudo chmod +x  "command3-$input-exp$exp.sh"
       server="$(ssh -n -T sshakeri@145.100.131.12 bash command3-$input-exp$exp.sh)"
       #sudo rm "command3-$input-exp$exp.sh"
       #server="$(ssh -n -tt sshakeri@145.100.131.12 sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${array[1]}-req$iteration)"
       #client="$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${array[0]}-req$iteration)"
      # echo $server
       sudo docker container exec  "${array[0]}-req$iteration" iperf3 -c "$server"  -p $port -n 5G
    fi
    #wait
    echo "${array[1]}"
    echo "${array[0]}"
    if [ ${array[1]} == "klm" ];
    then
       echo "befor server"
       server="$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${array[1]}-req$iteration)"
       echo "we are here and server ip is"
       echo "$server"
       #client="$(ssh sshakeri@145.100.131.12 sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${array[0]}-req$iteration)"
       ssh -n -tt sshakeri@145.100.131.12 sudo docker exec "${array[0]}-req$iteration" iperf3 -c "${server}"  -p "${port}" -n 5G
    fi
    #--port1=$(($port+$i))
    #--i=$(($i+1))
    #echo "sudo docker exec -it "${array[1]}-req$iteration" iperf3 -s  -p $port &"
    #sudo docker container exec "${array[1]}-req$iteration" /bin/bash -c "iperf3 -s -p $port &"
    #--local ip_server=$(name_to_ip "${array[1]}-req$iteration")
    #--echo $ip_server
    #echo "server is sent"
    #echo "sudo docker exec -it "${array[0]}-req$iteration" iperf3 -c $server  -p $port -n 5G"
    #sudo docker container exec  "${array[0]}-req$iteration" iperf3 -c $server  -p $port -n 12.5G
    #echo "client is sent"
    #kubectl exec "${array[1]}-req$iteration" -- /bin/bash -c "pkill iperf3"
    #echo "req$iteration completed" >> "/home/sshakeri/master/request/$folder/log.txt"
  done < "$file"
  echo "req$iteration completed" >> "/home/sshakeri/master/$overlay/request/$folder/log.txt"
  echo "req$iteration completed" 
  t_transfer_end="$(date -d "$(date -u)" "+%s")"
  t_container=$(($t_container_end-$t_container_start))
  t_overlay=$(($t_overlay_end-$t_overlay_start))
  t_transfer=$(($t_transfer_end-$t_transfer_start))
  t_total=$(($t_transfer_end-$t_overlay_start))
  echo "$t_overlay" > "/home/sshakeri/master/$overlay/request/$folder/duration/overlay-$input-exp$exp.txt"
  echo "$t_container" > "/home/sshakeri/master/$overlay/request/$folder/duration/container-$input-exp$exp.txt"
  echo "$t_transfer" > "/home/sshakeri/master/$overlay/request/$folder/duration/transfer-$input-exp$exp.txt"
  echo "$t_total" > "/home/sshakeri/master/$overlay/request/$folder/duration/total-$input-exp$exp.txt"
  sudo docker container stop klm-req"$iteration"
  sudo docker container rm  klm-req"$iteration"
  ssh -tt sshakeri@145.100.131.12 sudo docker container stop airfrance-req"$iteration"
  ssh -tt sshakeri@145.100.131.12 sudo docker container rm  airfrance-req"$iteration"
  sudo docker network remove my-overlay-network"$iteration"
}



if [[ $# -lt "7" ]]; then
  echo "Usage: $0  <req-number> <bunch-number> <type of request> <Experiment-number> <mix_number> <overlay> <port_num>"
# bash  /home/sshakeri/master/delete.sh "$overlay" "$folder" "$bunchnum" "$mix"
  exit 1
else
  duration "$1" "$2" "$3" "$4" "$5" "$6" "$7"
fi
