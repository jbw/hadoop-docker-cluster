FROM ubuntu:latest


WORKDIR /root

RUN apt-get update

RUN apt-get update && apt-get install -y openssh-server wget

RUN apt-get install -y software-properties-common debconf-utils

RUN add-apt-repository -y ppa:webupd8team/java

RUN apt-get update

RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections

RUN apt-get install -y oracle-java8-installer

RUN wget https://github.com/jbw/build-hadoop/archive/3.0.3.tar.gz && \
    tar -xzvf 3.0.3.tar.gz && \
    ls && \
    mv build-hadoop-3.0.3 /usr/local/hadoop && \
    rm 3.0.3.tar.gz

# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle 
ENV HADOOP_HOME=/usr/local/hadoop 
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin 

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

# Docker config
COPY config/* /tmp/

RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]
