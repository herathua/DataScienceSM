-- Pig word count example
lines = LOAD '/input/sample.txt' AS (line:chararray);
words = FOREACH lines GENERATE FLATTEN(TOKENIZE(line)) AS word;
grouped = GROUP words BY word;
word_count = FOREACH grouped GENERATE group AS word, COUNT(words) AS count;
STORE word_count INTO '/output/pig_wordcount'; 