# elephant-pi
Hadoop cluster on Raspberry Pi

# My hardware

# Installing base OS on Raspberry Pi


# Docker images
`sudo docker network create --driver=bridge hadoop`

## Build

`./build.sh`

## namenode (Master)

## master and slave nodes

# Install
## Verify

## Start

`./start.sh`

## In the container

`./start-hadoop.sh`
# Run example

## Copy a file to HDFS

`hdfs dfs -copyFromLocal /usr/local/hadoop/LICENSE.txt /license.txt`


## Run the wordcount example 

`yarn jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.0.3.jar wordcount /license.txt /test`

## Dump the result to terminal
`hdfs dfs -cat "/test/part-r-00000"`


