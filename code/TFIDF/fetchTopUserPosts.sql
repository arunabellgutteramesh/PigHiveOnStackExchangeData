-- Store top users in a separate table called TopUsers:

CREATE TABLE TopUsers
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' AS
SELECT OwnerUserId, SUM(Score) AS TotalScore
FROM posts
GROUP BY OwnerUserId
ORDER BY TotalScore DESC LIMIT 10;

-- Fetch body, tag and title of the users in TopUsers and store it in a separate table called TopUserPosts

CREATE TABLE TopUserPosts AS
SELECT OwnerUserId, Body, Title, Tags
FROM posts
WHERE OwnerUserId in (SELECT OwnerUserId FROM TopUsers)
GROUP BY OwnerUserId, Body, Title, Tags;

-- Store the TopUserPosts results into an HDFS directory

INSERT OVERWRITE DIRECTORY '/user/data/hiveResults'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
SELECT OwnerUserId, Body, Title
FROM TopUserPosts
GROUP BY OwnerUserId, Body, Title;
