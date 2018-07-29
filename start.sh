#!/bin/bash
docker rm -f hadoop-master

docker run -itd --net=hadoop -p 50070:50070 -p 8088:8088 --name hadoop-master --hostname hadoop-master jbw/hadoop

# start hadoop slave container
i=1
while [ $i -lt 5 ]
do
    docker rm -f hadoop-slave-$i
    echo "start hadoop-slave-$i container..."
    docker run -itd --net=hadoop --name hadoop-slave-$i --hostname hadoop-slave-$i jbw/hadoop
    i=$(( $i + 1 ))
done

docker exec -it hadoop-master bash