FROM ubuntu:latest


WORKDIR /root

RUN apt-get update

RUN apt-get update && apt-get install -y openssh-server wget

RUN apt-get install -y software-properties-common debconf-utils net-tools vim 

RUN add-apt-repository -y ppa:webupd8team/java

RUN apt-get update

RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections

RUN apt-get install -y oracle-java8-installer

RUN wget https://github.com/jbw/build-hadoop/releases/download/3.0.3-ubuntu/hadoop-3.0.3.tar.gz && \
    tar -xzvf hadoop-3.0.3.tar.gz && \
    mv hadoop-3.0.3 /usr/local/hadoop && \ 
    rm hadoop-3.0.3.tar.gz

# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle 
ENV HADOOP_HOME=/usr/local/hadoop 
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin 
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"
ENV YARN_NODEMANAGER_USER="root"

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

# Docker config
COPY hadoop-config/* /tmp/
# if master
COPY hadoop-master-config/* /tmp/

# if slave
# COPY hadoop-slave-config/* /tmp/

# Hadoop config 
RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/start-slaves.sh ~/start-slaves.sh && \
    mv /tmp/.bashrc ~/.bashrc


RUN chmod +x ~/start-hadoop.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x ~/start-slaves.sh 

RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]
