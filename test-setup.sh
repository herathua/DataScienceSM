#!/bin/bash

echo "🧪 Testing Hadoop + Spark + Pig + HDFS Setup"
echo "============================================"

# Function to check if a service is responding
check_service() {
    local service=$1
    local url=$2
    local description=$3
    
    echo -n "Testing $description... "
    if curl -s "$url" > /dev/null 2>&1; then
        echo "✅ OK"
        return 0
    else
        echo "❌ FAILED"
        return 1
    fi
}

# Function to check if a container is running
check_container() {
    local container=$1
    local description=$2
    
    echo -n "Checking $description... "
    if docker ps | grep -q "$container"; then
        echo "✅ Running"
        return 0
    else
        echo "❌ Not running"
        return 1
    fi
}

# Check if containers are running
echo "📦 Container Status:"
check_container "namenode" "Hadoop NameNode"
check_container "datanode" "Hadoop DataNode"
check_container "spark-master" "Spark Master"
check_container "spark-worker" "Spark Worker"
check_container "pig" "Pig Container"

echo ""
echo "🌐 Service Connectivity:"
check_service "namenode" "http://localhost:9870" "HDFS Web UI"
check_service "spark-master" "http://localhost:8080" "Spark Web UI"

echo ""
echo "🔍 HDFS Status:"
if docker exec namenode hdfs dfsadmin -report > /dev/null 2>&1; then
    echo "✅ HDFS is operational"
    echo "   Live datanodes: $(docker exec namenode hdfs dfsadmin -report | grep 'Live datanodes' | awk '{print $3}')"
else
    echo "❌ HDFS is not operational"
fi

echo ""
echo "📊 Spark Status:"
if curl -s "http://localhost:8080" | grep -q "Spark Master"; then
    echo "✅ Spark Master is operational"
    workers=$(curl -s "http://localhost:8080" | grep -o "Workers: [0-9]*" | awk '{print $2}')
    echo "   Active workers: $workers"
else
    echo "❌ Spark Master is not operational"
fi

echo ""
echo "🐷 Pig Test:"
if docker exec pig pig -version > /dev/null 2>&1; then
    echo "✅ Pig is available"
else
    echo "❌ Pig is not available"
fi

echo ""
echo "📁 Sample Data Test:"
if docker exec pig test -f /data/sample.txt; then
    echo "✅ Sample data is available"
    echo "   Records: $(docker exec pig wc -l < /data/sample.txt)"
else
    echo "❌ Sample data is not available"
fi

echo ""
echo "🎯 Quick Pig Analysis Test:"
if docker exec pig hdfs dfs -test -d /data 2>/dev/null; then
    echo "✅ HDFS /data directory exists"
else
    echo "📤 Creating HDFS directory and uploading sample data..."
    docker exec pig hdfs dfs -mkdir -p /data
    docker exec pig hdfs dfs -put /data/sample.txt /data/
fi

echo ""
echo "✨ Setup Test Complete!"
echo ""
echo "📋 Next Steps:"
echo "   1. Access HDFS Web UI: http://localhost:9870"
echo "   2. Access Spark Web UI: http://localhost:8080"
echo "   3. Run Pig analysis: docker exec -it pig bash"
echo "   4. In Pig shell: exec /scripts/sample_analysis.pig" 