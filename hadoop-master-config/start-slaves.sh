#!/bin/bash

slaves_count=4
i=1

while (($i <= $slaves_count))
do
    echo "booting up hadoop-slave-$i"
    ssh -t hadoop-slave-$i "./start-hadoop.sh && exit"
    i=$(( $i + 1 ))
done
