FROM bde2020/hadoop-base:2.0.0-hadoop3.2.1-java8

ENV NODE_TYPE=namenode
ENV CLUSTER_NAME=test

# Copy custom configuration files
COPY hadoop-config/ /opt/hadoop/etc/hadoop/

# Create necessary directories
RUN mkdir -p /hadoop/dfs/name /hadoop/dfs/data

# Set permissions
RUN chmod -R 755 /hadoop

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:9870/ || exit 1

CMD ["/entrypoint.sh"] 