# PigHiveOnStackExchangeData

Tasks

1.	Data Acquisition

Stack Exchange is a platform where anyone can post any question from any field.  People who know the answer post them at the site.  The others in quest for answer, score these answers based on their satisfaction.  This data is available at https://data.stackexchange.com/stackoverflow/query/new.  SQL queries were run at the aforementioned website to fetch the top 200,000 top scored posts.
A counting query was first run to figure out the range of ViewCount in which the top 50,000 records lie (since the site allows only a download of 50,000 records at one shot), followed by a fetch query to fetch it.  This process was repeated four times to get 200,000 records in total.
Like:
Counting Query:
SELECT  COUNT(*) 
FROM posts WHERE posts.ViewCount > 86500 
Fetch Query:
SELECT TOP 50000 * 
FROM posts WHERE posts.ViewCount > 86500 
ORDER BY posts.ViewCount DESC

2.	Extract, Load and Transform (ETL)

The raw data downloaded consisted of 22 columns.  The Body column was rather malicious since it consisted the body of the post written in natural language, had many special characters, and way too many new line characters in its field. The ‘\n’ character made it impossible to load the data onto pig, despite loading it with “CSVExcelStorage” and “YES_MULTILINE” argument. Thus, all the new line characters were truncated to a mere space by cleaning the data using python script (removeNewLines.py) before loading onto pig.

In pig, fetchValidRecords.pig script was run in “mapreduce” mode to:
a)	 Load four primitively cleaned (i.e., with no new line characters) CSV files and concatenate them to form one big file of 200,000 tuples for further cleaning.
b)	Remove commas and limit data to only a few required columns.
c)	Remove rows of data that consists of NULLs in its primary/key column.
d)	Store the cleaned data into an HDFS (hadoop distributed file system) directory for further processing by hive.  

3.	Hive Querying

For the three simple queries asked, writing a map reduce job in python/JAVA seemed too much effort.  Hence, the querying was done in hive.  
The cleaned data stored at an HDFS directory was taken up by hive to fill the content of its table “posts”, whose structure was defined in the CREATE hive query.  All the three queries asked was answered through Hive Query Language (HQL).  The hive queries for the Task 3 is written in a file called hiveQueries.sql and executed as:
hive -f /home/vagrant/code/hiveScript.sql
where “/home/vagrant/code” is the location where this hiveScript.sql was stored.

4.	TF IDF

The calculation of TF IDF per user of the top ten users involved the fetching of top ten users and storing in a separate table called TopUsers.  The OwnerUserId from this TopUsers table is then used to query the top user’s all of the posts’ Body, Title and Tags and stored in a table called TopUserPosts.  This TopUserPosts is then stored onto an HDFS directory.  The result partitions from this HDFS directory is merged using the command:
hdfs dfs -getmerge /user/data/hiveResults hiveResults.csv 
and stored at an NFS directory.  Hive was used to fetch the TopUserPosts and the queries are enclosed within fetchTopUserPosts.sql file.

The results from the above query, hiveResults.csv consists of all the User’s records in the same file which was split into their respective user files to be used as input to TF IDF program.  This splitting was done in python script - splitTopUserPosts.py

The results of the splitTopUserPosts.py script is fed as input to TF IDF mappers.  The collection of TF IDF mappers reducer programs are stored in tfidf_code folder. The commands ran to compute the TF IDF is stored in tfidfcommands.txt under tfidf_code folder.

The results from the above tfidf_code gave result to ten files for each user.  It contained the top terms and their weights.  To fetch the top ten terms of each user sortResults.py was run.

5. Google Dataproc

The above Task 2 & 3 were run in Google Cloud platform (GCP) using dataproc.  Dataproc is a fully managed service built for Hadoop map-reduce.

At the GCP console, a new project was launched.  For this project a cluster was launched and started.  Here, Cluster was given a name and chose to run at east4 region since its close to Dublin.  Chose 1 Node 0 Datanode configuration to run just one node as both Master and Slave.

The cluster was instantiated and the data uploaded via DCU server was fetched using:
wget https://student.computing.dcu.ie/~bellgua2/cleaned_QR_01.csv

The rest of the procedure is same as in Task 2 and 3.

References

1.	TF IDF Code:
https://github.com/devangpatel01/TF-IDF-implementation-using-map-reduce-Hadoop-python-
2.	Stack Overflow:
https://stackoverflow.com/
