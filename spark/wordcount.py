from pyspark import SparkContext
sc = SparkContext(appName='WordCount')
text_file = sc.textFile('hdfs://namenode:8020/input/sample.txt')
counts = text_file.flatMap(lambda line: line.split()) \
             .map(lambda word: (word, 1)) \
             .reduceByKey(lambda a, b: a + b)
counts.saveAsTextFile('hdfs://namenode:8020/output/spark_wordcount')
sc.stop() 