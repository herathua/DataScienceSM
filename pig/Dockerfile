FROM ubuntu:20.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Java and other dependencies
RUN apt-get update && \
    apt-get install -y \
    openjdk-8-jdk \
    wget \
    curl \
    ssh \
    net-tools \
    vim \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set Java environment
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# Download and install Hadoop 3.3.6
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz && \
    tar -xzf hadoop-3.3.6.tar.gz -C /opt && \
    rm hadoop-3.3.6.tar.gz

ENV HADOOP_HOME=/opt/hadoop-3.3.6
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Download and install Pig
RUN wget https://downloads.apache.org/pig/pig-0.17.0/pig-0.17.0.tar.gz && \
    tar -xzf pig-0.17.0.tar.gz -C /opt && \
    rm pig-0.17.0.tar.gz

ENV PIG_HOME=/opt/pig-0.17.0
ENV PATH=$PATH:$PIG_HOME/bin

# Copy Hadoop configuration
COPY hadoop-config/ $HADOOP_HOME/etc/hadoop/

# Create working directory
WORKDIR /data

# Create startup script
RUN echo '#!/bin/bash\n\
echo "Starting Pig container..."\n\
echo "Hadoop version:"\n\
hadoop version\n\
echo "Pig version:"\n\
pig -version\n\
echo "HDFS status:"\n\
hdfs dfsadmin -report\n\
echo "Ready to use Pig!"\n\
echo "Run: pig" to start Pig shell\n\
echo "Run: hdfs dfs -ls /" to list HDFS contents\n\
exec "$@"' > /startup.sh && chmod +x /startup.sh

CMD ["/startup.sh", "/bin/bash"] 