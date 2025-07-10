@echo off
echo 🚀 Starting Hadoop + Spark + Pig + HDFS Docker Setup
echo ==================================================

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker Desktop and try again.
    pause
    exit /b 1
)

REM Check if docker-compose is available
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ docker-compose is not installed. Please install Docker Compose.
    pause
    exit /b 1
)

echo ✅ Docker and Docker Compose are available

echo.
echo 🏗️  Building and starting services...
echo This may take several minutes on first run...

REM Build and start services
docker-compose up -d --build

if %errorlevel% equ 0 (
    echo.
    echo ✅ Services started successfully!
    echo.
    echo 📊 Service Status:
    docker-compose ps
    echo.
    echo ⏳ Waiting for services to fully initialize...
    echo This may take 2-3 minutes...
    echo.
    
    REM Wait for services to be ready
    timeout /t 30 /nobreak >nul
    
    echo 🌐 Access URLs:
    echo    HDFS Web UI: http://localhost:9870
    echo    Spark Web UI: http://localhost:8080
    echo.
    echo 🔧 Next Steps:
    echo    1. Wait for all services to show 'Up' status: docker-compose ps
    echo    2. Access Pig container: docker exec -it pig bash
    echo    3. Upload sample data: hdfs dfs -put /data/sample.txt /data/
    echo    4. Run Pig analysis: pig -f /scripts/sample_analysis.pig
    echo.
    echo 📋 Useful Commands:
    echo    View logs: docker-compose logs -f
    echo    Stop services: docker-compose down
    echo    Restart services: docker-compose restart
    echo.
    echo 📖 For detailed instructions, see README.md
) else (
    echo ❌ Failed to start services. Check the logs:
    docker-compose logs
    pause
    exit /b 1
)

pause 