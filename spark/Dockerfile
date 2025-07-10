FROM bitnami/spark:3.5

ENV SPARK_MODE=master
ENV SPARK_MASTER_HOST=spark-master
ENV SPARK_MASTER_URL=spark://spark-master:7077
ENV SPARK_WORKER_MEMORY=1G
ENV SPARK_WORKER_CORES=1

# Disable security for development
ENV SPARK_RPC_AUTHENTICATION_ENABLED=no
ENV SPARK_RPC_ENCRYPTION_ENABLED=no
ENV SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
ENV SPARK_SSL_ENABLED=no

# Copy custom configuration
COPY spark-defaults.conf /opt/bitnami/spark/conf/

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# No CMD override: use Bitnami's default entrypoint 