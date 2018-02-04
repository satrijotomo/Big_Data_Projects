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
1. Flume: 
$ flume-ng agent --name twit --conf-file /home/cloudera/twitter_analysis/flume_tweets_agent.properties --classpath /home/cloudera/twitter_analysis/jar/flume-sources-1.0-SNAPSHOT.jar


