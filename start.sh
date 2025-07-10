#!/bin/bash

echo "🚀 Starting Hadoop + Spark + Pig + HDFS Docker Setup"
echo "=================================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose is not installed. Please install Docker Compose."
    exit 1
fi

echo "✅ Docker and Docker Compose are available"

# Check available ports
echo "🔍 Checking port availability..."
ports=(9000 9870 9864 7077 8080)
for port in "${ports[@]}"; do
    if netstat -an | grep ":$port " | grep LISTEN > /dev/null; then
        echo "⚠️  Port $port is already in use. Please free up this port."
    else
        echo "✅ Port $port is available"
    fi
done

echo ""
echo "🏗️  Building and starting services..."
echo "This may take several minutes on first run..."

# Build and start services
docker-compose up -d --build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Services started successfully!"
    echo ""
    echo "📊 Service Status:"
    docker-compose ps
    echo ""
    echo "⏳ Waiting for services to fully initialize..."
    echo "This may take 2-3 minutes..."
    echo ""
    
    # Wait for services to be ready
    sleep 30
    
    echo "🌐 Access URLs:"
    echo "   HDFS Web UI: http://localhost:9870"
    echo "   Spark Web UI: http://localhost:8080"
    echo ""
    echo "🔧 Next Steps:"
    echo "   1. Wait for all services to show 'Up' status: docker-compose ps"
    echo "   2. Access Pig container: docker exec -it pig bash"
    echo "   3. Upload sample data: hdfs dfs -put /data/sample.txt /data/"
    echo "   4. Run Pig analysis: pig -f /scripts/sample_analysis.pig"
    echo ""
    echo "📋 Useful Commands:"
    echo "   View logs: docker-compose logs -f"
    echo "   Stop services: docker-compose down"
    echo "   Restart services: docker-compose restart"
    echo ""
    echo "📖 For detailed instructions, see README.md"
else
    echo "❌ Failed to start services. Check the logs:"
    docker-compose logs
    exit 1
fi 