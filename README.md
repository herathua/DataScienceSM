# Hadoop + Spark + Pig + HDFS Docker Setup

This project provides a complete Docker-based setup for Apache Hadoop, Spark, and Pig with HDFS integration. It's designed for development, testing, and learning purposes.

## 🏗️ Architecture

- **Hadoop HDFS**: NameNode and DataNode for distributed file storage
- **Apache Spark**: Master and Worker nodes for distributed computing
- **Apache Pig**: Data processing and analysis tool
- **Docker Compose**: Orchestration of all services

## 📁 Project Structure

```
hadoop-spark-pig-docker/
├── docker-compose.yml          # Main orchestration file
├── README.md                   # This file
├── hadoop/
│   ├── Dockerfile             # Hadoop container definition
│   └── hadoop-config/         # Hadoop configuration files
│       ├── core-site.xml
│       ├── hdfs-site.xml
│       ├── mapred-site.xml
│       └── yarn-site.xml
├── spark/
│   ├── Dockerfile             # Spark container definition
│   └── spark-defaults.conf    # Spark configuration
├── pig/
│   ├── Dockerfile             # Pig container definition
│   ├── hadoop-config/         # Hadoop config for Pig
│   │   └── core-site.xml
│   └── scripts/               # Sample Pig scripts
│       └── sample_analysis.pig
└── data/                      # Sample data files
    └── sample.txt
```

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- At least 4GB RAM available
- Ports 9000, 9870, 9864, 7077, 8080 available

### 1. Build and Start Services

```bash
# Build and start all services
docker-compose up -d --build

# Check service status
docker-compose ps
```

### 2. Wait for Services to Start

The services need a few minutes to fully initialize. You can monitor the logs:

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f namenode
docker-compose logs -f spark-master
```

### 3. Verify Services

Once all services are running, you can access:

- **HDFS Web UI**: http://localhost:9870
- **Spark Web UI**: http://localhost:8080

## 🔧 Usage Examples

### Using Pig for Data Analysis

1. **Access Pig container**:
```bash
docker exec -it pig bash
```

2. **Upload sample data to HDFS**:
```bash
hdfs dfs -put /data/sample.txt /data/
hdfs dfs -ls /data/
```

3. **Run Pig analysis**:
```bash
# Start Pig shell
pig

# In Pig shell, run the sample script
exec /scripts/sample_analysis.pig
```

### Using Spark

1. **Access Spark container**:
```bash
docker exec -it spark-master bash
```

2. **Run Spark shell**:
```bash
spark-shell --master spark://spark-master:7077
```

3. **Example Spark code**:
```scala
// Load data from HDFS
val data = spark.read.csv("hdfs://namenode:9000/data/sample.txt")

// Show data
data.show()

// Perform analysis
data.groupBy("_c0").count().show()
```

### HDFS Commands

```bash
# List HDFS contents
hdfs dfs -ls /

# Create directory
hdfs dfs -mkdir /user

# Copy file to HDFS
hdfs dfs -put localfile.txt /user/

# Copy file from HDFS
hdfs dfs -get /user/file.txt ./
```

## 📊 Sample Data Analysis

The project includes sample data (`data/sample.txt`) with the following format:
```
user,product,quantity,date
```

The sample Pig script (`pig/scripts/sample_analysis.pig`) demonstrates:
- Loading data from HDFS
- Grouping by user and product
- Calculating totals and counts
- Storing results back to HDFS

## 🔍 Monitoring and Debugging

### Service Health Checks

```bash
# Check all services
docker-compose ps

# Check specific service
docker exec namenode hdfs dfsadmin -report
docker exec spark-master curl -s http://localhost:8080
```

### View Logs

```bash
# All services
docker-compose logs

# Specific service
docker-compose logs namenode
docker-compose logs spark-master
docker-compose logs pig
```

### Common Issues

1. **Port conflicts**: Ensure ports 9000, 9870, 9864, 7077, 8080 are available
2. **Memory issues**: Increase Docker memory allocation to at least 4GB
3. **Service startup order**: Services are configured with proper dependencies

## 🛠️ Configuration

### Hadoop Configuration

Key configuration files in `hadoop/hadoop-config/`:
- `core-site.xml`: Core Hadoop settings
- `hdfs-site.xml`: HDFS-specific settings
- `mapred-site.xml`: MapReduce settings
- `yarn-site.xml`: YARN resource management

### Spark Configuration

Spark settings in `spark/spark-defaults.conf`:
- Master URL configuration
- Memory settings
- HDFS integration

### Environment Variables

You can customize the setup by modifying environment variables in `docker-compose.yml`:
- `SPARK_WORKER_MEMORY`: Worker memory allocation
- `SPARK_WORKER_CORES`: Worker CPU cores
- `CLUSTER_NAME`: Hadoop cluster name

## 🧹 Cleanup

```bash
# Stop all services
docker-compose down

# Remove volumes (WARNING: This will delete all data)
docker-compose down -v

# Remove images
docker-compose down --rmi all
```

## 📚 Additional Resources

- [Apache Hadoop Documentation](https://hadoop.apache.org/docs/current/)
- [Apache Spark Documentation](https://spark.apache.org/docs/latest/)
- [Apache Pig Documentation](https://pig.apache.org/docs/latest/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is open source and available under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0). 