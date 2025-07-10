-- Sample Pig script for data analysis
-- This script analyzes user purchase data

-- Load the data from HDFS
raw_data = LOAD '/data/sample.txt' USING PigStorage(',') AS (user:chararray, product:chararray, quantity:int, date:chararray);

-- Display the raw data
DUMP raw_data;

-- Group by user and calculate total purchases
user_totals = GROUP raw_data BY user;
user_summary = FOREACH user_totals GENERATE group AS user, SUM(raw_data.quantity) AS total_purchases, COUNT(raw_data) AS num_purchases;

-- Display user summary
DUMP user_summary;

-- Group by product and calculate total sales
product_totals = GROUP raw_data BY product;
product_summary = FOREACH product_totals GENERATE group AS product, SUM(raw_data.quantity) AS total_sold, COUNT(raw_data) AS num_sales;

-- Display product summary
DUMP product_summary;

-- Store results to HDFS
STORE user_summary INTO '/output/user_summary' USING PigStorage(',');
STORE product_summary INTO '/output/product_summary' USING PigStorage(','); 