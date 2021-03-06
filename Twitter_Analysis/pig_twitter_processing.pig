REGISTER '/home/cloudera/twitter_analysis/jar/json-simple-1.1.1.jar'
REGISTER '/home/cloudera/twitter_analysis/jar/elephant-bird-pig-4.14.jar'
REGISTER '/home/cloudera/twitter_analysis/jar/elephant-bird-hadoop-compat-4.14.jar'
REGISTER '/home/cloudera/twitter_analysis/jar/avro-1.8.0.jar' 
REGISTER '/home/cloudera/twitter_analysis/jar/piggybank-0.15.0.jar'
REGISTER '/home/cloudera/twitter_analysis/jar/jackson-core-asl-1.9.13.redhat-3.jar'
REGISTER '/home/cloudera/twitter_analysis/jar/jackson-mapper-asl-1.9.13.redhat-3.jar'
REGISTER '/home/cloudera/twitter_analysis/jar/custom-pig-udf-0.0.1-SNAPSHOT.jar'

DEFINE extractHref com.dezyre.hadooptraining.udf.HrefExtractor();
DEFINE getHashTagText com.dezyre.hadooptraining.udf.HashTextExtractor();
DEFINE encodeUTF8 com.dezyre.hadooptraining.udf.Utf8StringEncoder();
 
raw_tweets = LOAD '/user/cloudera/tweetdata/bigdata/output/${year}/${month}/${day}/${hour}' USING com.twitter.elephantbird.pig.load.JsonLoader('-nestedLoad') as (json:map[]);

featured_tweets = FOREACH raw_tweets GENERATE (long)json#'id' AS id, (long)json#'timestamp_ms' AS ts, (chararray)json#'lang' AS twtlang, (chararray)json#'created_at' AS created_at, encodeUTF8((chararray)json#'text') AS tweet_text, encodeUTF8(extractHref((chararray)json#'text')) AS url, encodeUTF8(extractHref((chararray)json#'source')) AS source, encodeUTF8(getHashTagText(json#'entities'#'hashtags')) AS hashtags, encodeUTF8((chararray)json#'user'#'location') AS agent_location, encodeUTF8((chararray)json#'user'#'description') AS agent_desc, encodeUTF8((chararray)json#'user'#'name') AS agent_name, (chararray)json#'user'#'profile_image_url' AS agent_image_url, encodeUTF8((chararray)json#'user'#'screen_name') AS screen_name, (int)json#'user'#'followers_count' AS follower_count;

en_tweets = FILTER featured_tweets BY twtlang == 'en';

dsnt_tweets = DISTINCT en_tweets; -- unnecessary

STORE dsnt_tweets INTO '/user/cloudera/pig/output/bigdata/${year}/${month}/${day}/${hour}' USING AvroStorage();
