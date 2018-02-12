create database if not exists twitterdb ;

alter database twitterdb 
set dbproperties('table.creator'='Cloudera User');

use twitterdb;

create external table tweets (
  id bigint,   
  ts bigint, 
  twtlang string, 
  created_at string,
  tweet_text string, 
  url string,
  source string, 
  hashtags string, 
  agent_location string, 
  agent_desc string, 
  agent_name string, 
  agent_image_url string,
  screen_name string,
  follower_count int
)
partitioned by (
  year string,
  month string,
  day string,
  hour string
)
stored as avro
location '/user/cloudera/pig/output/bigdata'
tblproperties('avro.schema.url'='/user/cloudera/pig/output/bigdata/twitter_avro_schema.avsc');

-- sample query to load all job postings in english
--select * from tweets where twtlang = 'en';
