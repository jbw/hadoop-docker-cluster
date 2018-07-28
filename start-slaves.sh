#!/bin/bash

# start hadoop slave container
i=1
while [ $i -lt 4 ]
do
    sudo docker rm -f hadoop-slave-$i &> /dev/null
    echo "start hadoop-slave-$i container..."
    sudo docker run -itd \
    --net=hadoop \
    --name hadoop-slave-$i \
    --hostname hadoop-slave-$i \
    jbw/hadoop &> /dev/null
    i=$(( $i + 1 ))
done