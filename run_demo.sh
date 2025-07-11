#!/bin/bash
set -e

# Copy sample data into namenode container (for Windows compatibility)
echo 'Copying sample.txt to namenode container...'
docker cp data/sample.txt namenode:/data/sample.txt

# Upload sample data to HDFS
echo 'Uploading sample.txt to HDFS...'
docker exec namenode hdfs dfs -mkdir -p /input || true
docker exec namenode hdfs dfs -put -f /data/sample.txt /input/

echo 'Running Pig word count...'
docker exec pig pig -x mapreduce -f /scripts/wordcount.pig

echo 'Pig word count results:'
docker exec namenode hdfs dfs -cat /output/pig_wordcount/part* || echo 'No Pig output found.'

echo 'Copying Spark script to spark-master...'
docker cp spark/wordcount.py spark-master:/tmp/wordcount.py

echo 'Running Spark word count...'
docker exec spark-master spark-submit --master spark://spark-master:7077 /tmp/wordcount.py

echo 'Spark word count results:'
docker exec namenode hdfs dfs -cat /output/spark_wordcount/part* || echo 'No Spark output found.'

echo 'Demo complete!' 