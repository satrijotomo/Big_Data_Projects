register '/home/cloudera/hadoop-training-projects/pig/movielens/piggybank-0.16.0.jar';
register '/home/cloudera/hadoop-training-projects/pig/movielens/datafu-pig-incubating-1.3.1.jar';

DEFINE csvLoader org.apache.pig.piggybank.storage.CSVLoader();
DEFINE VAR datafu.pig.stats.VAR();

-- load movie data
movie_data = load '/user/cloudera/rawdata/handson_train/movielens/latest/movies/' using csvLoader() as (movieId: chararray, title: chararray, genres : chararray);
-- remove_header
movie_raw = FILTER movie_data BY genres != 'genres';
-- project movieId & title
movies = FOREACH movie_raw GENERATE (long)movieId as movieId,title;


-- load rating data
rating_data = load '/user/cloudera/rawdata/handson_train/movielens/latest/ratings/' using PigStorage(',') as (userId: chararray, movieId: chararray, rating: float, ts : long);
-- remove_header
rating_raw = FILTER rating_data BY movieId != 'movieId';
-- project movieId, rating
ratings = FOREACH rating_raw GENERATE (long)movieId as movieId, rating;
-- group by movieId
rating_group = GROUP ratings BY movieId;
-- for each group, get the count of rating, sum of rating, avg of rating and variance of rating
ratings_per_movie = FOREACH rating_group GENERATE group as movieId, COUNT(ratings.rating) as rating_count, SUM(ratings.rating) as total_rating, AVG(ratings.rating) as avg_rating, VAR(ratings.rating) as var_rating;

-- join movie and rating
movies_join_ratings = JOIN movies by movieId LEFT, ratings_per_movie by movieId;
-- project movieId, title, count of rating, sum of rating, avg of rating and variance of rating
final_data = FOREACH movies_join_ratings GENERATE movies::movieId, movies::title, ratings_per_movie::rating_count, ratings_per_movie::total_rating, ratings_per_movie::avg_rating, ratings_per_movie::var_rating;

-- store result
STORE final_data INTO '/user/cloudera/output/handson_train/movielens/movies_rating_analysis';
