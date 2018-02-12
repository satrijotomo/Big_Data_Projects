### TWITTER ANALYSIS ###

Components used:
- Flume : To collect twitter data
- Pig	: To process tweets and extract features of interest
- Hive	: To store data in data warehouse
- Sqoop	: To export Hive data to RDBMS for further analysis

Prerequisites:
- Cloudera environment. Cloudera quickstart VM is used in this exercise
- All required services are up and running
- Twitter access keys are available 

Running:
1. Flume: # flume-ng agent --name twit --conf-file /home/cloudera/twitter_analysis/flume_tweets_agent.properties --classpath /home/cloudera/twitter_analysis/jar/flume-sources-1.0-SNAPSHOT.jar
Use nohup for running on the background
Flume script can also be run on the background with "nohup" command

2. Pig: # pig -p year=2018 -p month=02 -p day=04 -p hour=15 -f /home/cloudera/twitter_analysis/pig_twitter_processing.pig

3. Upload file twitter_avro_schema.avsc to HDFS and update avro.schema.url property value in hive_twitter_processing.hql accordingly. Also update avro location as necessary (refer to output of Pig in step#2).

4. Run Hive script: # hive -f hive_twitter_processing.hql

5. Run sqoop command inside file sqoop_twitter.txt







