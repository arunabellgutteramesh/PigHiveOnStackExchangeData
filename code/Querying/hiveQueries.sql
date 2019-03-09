-- data is being pulled from hdfs location '/user/data/combined' where pig has stored the records after cleaning them.
create table posts(Id int, Score int, Body String, OwnerUserId Int, Title String, Tags String) 
row format delimited 
FIELDS TERMINATED BY ','
location '/user/data/combined';

-- to print headers
SET hive.cli.print.header=true;

show tables;

describe posts;

select * from posts LIMIT 5;

-- first query - 1. The top 10 posts by score
SELECT id, title, score 
FROM posts
ORDER BY score DESC LIMIT 10;

-- second query - 2. The top 10 users by post score
SELECT OwnerUserId, SUM(Score) AS TotalScore
FROM posts
GROUP BY OwnerUserId
ORDER BY TotalScore DESC LIMIT 10;

-- third query - 3. The number of distinct users, who used the word 'hadoop' in one of their posts
SELECT COUNT(DISTINCT OwnerUserId)
FROM posts
WHERE (body LIKE '%hadoop%' OR title LIKE '%hadoop%' OR tags LIKE '%hadoop%');

