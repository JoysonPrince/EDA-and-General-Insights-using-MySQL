create database if not exists CWC2022;
USE CWC2022;

 /* SQL PROJECT using MySQL WorkBench for TechTip24 Certification */
 
 /* Step 1- Data Overview and Cleaning
DataSet reference: --[https://www.kaggle.com/datasets/adnananam/icc-mens-wc-t20-batting-stats-2022?utm_medium=social&utm_campaign=kaggle-dataset-share&utm_source=linkedin]--
--I analyzed the dataset and found there are 7 data tables of which 1 table(table #3)is irrelevant because it contains the same values as of table #2
Thus I selected 5 tables from the original dataset and created them as follows for analysis:
*/
CREATE TABLE BatAvg(
SerialNo INT,
Player VARCHAR(23),
Team VARCHAR(6),
Average DECIMAL(4,2),
Innings INT,
BatAvg DECIMAL(5,2),
Runs INT
);
SELECT * FROM Batavg;
drop table batavg;

CREATE TABLE BatSR(
SerialNo INT,
Player VARCHAR(23),
Team VARCHAR(5),
StrikeRate DECIMAL(5,2),
Innings INT,
BatAvg DECIMAL(5,2),
Runs INT
);
SELECT * FROM BatSR;
drop table batsr;

CREATE TABLE MostFifties(
SerialNo INT,
Player VARCHAR(23),
Team VARCHAR(5),
Fifties INT,
Innings INT,
BatAvg DECIMAL(5,2),
Runs INT
);
SELECT * FROM mostfifties;
drop table mostfifties;

CREATE TABLE MostHundreds(
SerialNo INT,
Player VARCHAR(23),
Team VARCHAR(5),
Hundreds INT,
Innings INT,
BatAvg DECIMAL(5,2),
Runs INT
);
SELECT * FROM mosthundreds;
drop table mosthundreds;

CREATE TABLE HighestScore(
SerialNo INT,
Player VARCHAR(23),
Team VARCHAR(5),
HighestScore VARCHAR(7),
Innings VARCHAR(6),
BatAvg VARCHAR(6),
Runs INT
);
SELECT * FROM highestscore;
ALTER TABLE highestscore
RENAME COLUMN player TO playerhs,
RENAME COLUMN team TO teamhs,
RENAME COLUMN batavg TO batavghs,
RENAME COLUMN runs TO runshs;


/* Step 2: Importing of original tables from the Kaggle DataSet into MySQL
--I manually created the tables by specifying the necessary data types for each column by carefully analyzing the CSV files of the dataset-- 
*/

/*Step 3: Inner Join table #1(batavg) and table #3(highestscore)

Since many columns of these 2 tables are having similar column names, there will be an error of ambiguity.
Thus, I renamed the columns of table #3 adding a suffix of their table name.
So, by successful joining I analyzed top-5 batsmen of WC2022 in terms of their Batting average and team */

SELECT player,team, average FROM batavg
INNER JOIN highestscore ON batavg.team=highestscore.teamhs
where batavg>40 AND runs>100
group by team
order by batavg desc
LIMIT 5;

-- Step 4: Added a Column(TeamCoach) into Table #1(batavg) and modified its Data Type
ALTER TABLE BatAvg
ADD TeamCoach VARCHAR(15);
ALTER TABLE BatAvg
MODIFY COLUMN TeamCoach VARCHAR(19);
SELECT * FROM BatAvg;
UPDATE BatAvg
SET TeamCoach = "David Houghton"
WHERE Team="zim"; 

/* Step 5: VIEWS
I created a VIEW(T20_Team_Ranking) which is a virtual table but can be interacted with as if they were an actual table.
So, whatever modifications or alterations we do on the Original Table(BatAvg) shall be automatically reflected onto the VIEW(T20_Team_Ranking) created. */

CREATE VIEW T20_Team_Ranking AS 
SELECT Player,team,teamcoach,team_rank
FROM batavg;
SELECT * FROM T20_TEAM_RANKING;

select * from batavg;
ALTER TABLE Batavg
ADD Team_Rank INT;
UPDATE BatAvg
SET Team_Rank = 16
where team="sco";

-- Step 6: Declaring a Primary Key after creating the table and showing their indexes
ALTER TABLE BatAvg
ADD CONSTRAINT PRIMARY KEY (Player);
SHOW INDEXES FROM BatAvg; 

/* Step 7: Created a multi-column index on the table BatSR 
Creating Indexes returns the values quicker than the normal procedure of extracting from the entire table */
CREATE INDEX idx_idx
ON Batsr(player,team,strikerate);
SHOW INDEXES FROM BatSR;
select * from batsr
where team="Ind" and player LIKE "__r%" AND Strikerate>= 135;
/* After creating a index for the columns Player,Team and StrikeRate from the table BatSR,
I analyzed to find that in the entirety of WC2022 there were only 2 batters from India with a Strike Rate higher than 135 which is statistically considered to be good 
*/

-- Step 8: Total Runs(Top-10) scored by a Team in the entire T20WC2022
SELECT COUNT(player) AS Total_Players,team,team_rank,SUM(runs) AS Total_Runs FROM batavg
group by team_rank
order by sum(runs) desc
limit 10;
SELECT * FROM BATAVG; 

-- Step 9: Max Fifties scored by a Team in the T20WC2022
SELECT team,count(fifties) AS FiftyCount FROM mostfifties
where fifties>0 and batavg>35 
group by team
order by count(fifties) desc;
select * from mostfifties;
/* Most fifties were scored by India and Pakistan, but since I decided the criteria(batavg) 
to be greater than 35 which is considered On-Par with modern game standards, MySQL returned New Zealand and England 
*/

-- Step 10: Most Hundreds scored in the T20WC2022
SELECT DISTINCT(hundreds) AS HundredCount,player,team FROM mosthundreds
order by hundreds desc;
/* To be noted that Count(Hundreds) would have returned 50 as HundredCount which is not possible,
thus Distinct(Hundreds) gives me the exact answer */

-- Step 11: Top-4 Batsmen with Strike Rate > 135 and Average > 40
select * from batsr where strikerate>135 and batavg>40
order by batavg desc limit 4; 

-- Step 12: Using REGEXP Operator to filter data/Similar use case with LIKE Operator
select * from batavg
where player REGEXP "^A";
select * from batavg
where teamcoach REGEXP "t$"; 
select player,teamcoach from batavg
where player REGEXP "^[a-z]" AND teamcoach REGEXP "[a-z]$"; 
select * from batavg
where teamcoach REGEXP "^M | mott$";

-- Step 13: Created a Table Bowlers for the usage of TRIGGERS
create table Bowlers(
SerialNo INT PRIMARY KEY AUTO_INCREMENT,
Player VARCHAR(23),
Matches INT,
Overs DECIMAL(4,2),
Runs_Conceded INT,
Wickets INT NOT NULL,
BowlingAverage DECIMAL(4,2) NOT NULL
);
select * from bowlers;
INSERT INTO bowlers (player,matches,overs,runs_conceded,wickets,bowlingaverage)
VALUES("Wanindu Hasaranga",8,31,199,15,13.27),
("Sam Curran",7,22.4,148,13,11.38),
("Bas De Leede",8,22,169,13,13.00),
("Blessing Muzarabani",8,26,199,12,16.58),
("Anrich Nortje",5,17.4,95,11,8.64),
("Shaheen Afridi",7,25.1,155,11,14.09),
("Shadab Khan",7,26,165,11,15),
("Paul Van Meekeren",8,31,198,11,18),
("Joshua Little",7,27,189,11,17.18),
("Sikandar Raza",8,24,156,10,15.6),
("Arshdeep Singh",6,20,156,10,15.6),
("Mitchell Santner",6,20,129,9,14.33),
("Maheesh Theekshana",8,30.1,202,9,22.44),
("Richard Ngarava",8,28,197,9,21.89),
("Mark Wood",5,14,108,9,12),
("Fred Klaassen",8,30,191,8,23.88),
("Haris Rauf",7,26,178,8,22.25),
("Taskin Ahmed",5,18,131,8,16.38),
("Hardik Pandya",6,18,146,8,18.25),
("Trent Boult",6,20,148,8,18.5),
("Mohd Waseem",6,17,124,8,15.5);

-- Step 14: Added a mathematically generated column EconomyRate into the table Bowlers to cross-verify Trigger Functionalities
ALTER TABLE bowlers
ADD COLUMN EconomyRate DECIMAL(3,2);
UPDATE bowlers
SET EconomyRate = (runs_conceded/overs);
select * from bowlers;
CREATE TRIGGER TriggerEconomy
BEFORE INSERT ON bowlers
FOR EACH ROW
SET NEW.EconomyRate = (NEW.runs_conceded/NEW.overs);
INSERT INTO bowlers(player,matches,overs,runs_conceded,wickets,bowlingaverage,economyrate)
VALUES("Tim Southee",6,17.2,114,7,16.29,NULL),
("Ben Stokes",7,16.2,111,6,18.5,NULL),
("Brandon Glover",3,8.5,60,7,8.57,NULL);
select * from bowlers;

-- As can be seen from the above statements, Triggers worked successfully after the insertion of newly added records into the table Bowlers */

-- Step 15: Created a new Table Bowlerstats for more precise stats of a bowler
CREATE TABLE BowlerStats(
SerialNO INT PRIMARY KEY AUTO_INCREMENT,
Player VARCHAR(23) NOT NULL,
EconomyRate DECIMAL(3,2) NOT NULL,
BallsBowled INT,
BowlingAvg DECIMAL(4,2) NOT NULL,
Wickets INT NOT NULL
);
-- Added a new column StrikeRate by generating a formula within the existing columns (ballsbowled and wickets)
select * from bowlerstats;
ALTER TABLE bowlers
ADD COLUMN BallsBowled INT AFTER Overs;

[ UPDATE bowlers
SET ballsbowled = 53 -- 1 Over = 6 balls
WHERE Player ="Brandon Glover"; ] -- repeat this loop for all the records by reference to Overs column

SELECT * FROM bowlerstats;
-- Using the backfilling technique to fill the records from bowlers into bowlerstats
INSERT INTO bowlerstats (serialno, player, economyrate, ballsbowled, bowlingavg, wickets)
SELECT serialno, player, economyrate, ballsbowled, bowlingaverage, wickets FROM bowlers;
-- after backfilling, fill the strikerate column with the below formula,
UPDATE bowlerstats
SET strikerate = (ballsbowled/wickets); 

-- Step 16: Added and Updated the Teams column for the respective players to give more clarity on which Country the player represents
SELECT * FROM bowlers;
ALTER TABLE bowlers
ADD COLUMN Team VARCHAR(18) AFTER Player;
UPDATE bowlers
SET team = "SL" WHERE Player IN ("Maheesh Theekshana");
SELECT * FROM bowlers; 

-- Step 17: Created a Stored Procedure named top_performing_bowlers 
DELIMITER $$
CREATE PROCEDURE top_performing_bowlers()
BEGIN
SELECT team, player, wickets, bowlingaverage, economyrate FROM bowlers
WHERE bowlingaverage < 16 AND Economyrate < 7.5
GROUP BY team
ORDER BY bowlingaverage DESC
LIMIT 5;
END $$
DELIMITER ;
-- We can add multiple records into the Table Bowlers and use this stored procedure to return top bowlers
CALL top_performing_bowlers();

-- Step 18: Created a Stored Procedure top_performing_batters with 2 input parameters for the user
DELIMITER $$
CREATE PROCEDURE top_performing_batters(IN team_name VARCHAR(6),IN player_name VARCHAR(23))
BEGIN
SELECT team,player,average,runs FROM batavg
WHERE team = team_name AND player = player_name;
END $$
DELIMITER ;
CALL top_performing_batters("eng","ben stokes"); 


-- Step 19: Case statement to determine the performance of a team based on their ranking
SELECT * FROM batavg;
SELECT team,teamcoach,player,team_rank,
CASE
WHEN team_rank <=3 THEN "Consistent_Teams"
WHEN team_rank BETWEEN 4 AND 7 THEN "Moderate_Teams"
ELSE "Inconsistent_Teams"
END AS Team_Performance
FROM batavg
ORDER BY team_rank; 

-- Step 20: Case statement to show the viewers how the stats of a bowler has impacted his team
select * from bowlerstats;
SELECT player,strikerate,wickets,
CASE
WHEN strikerate <= 13 THEN "High Impact"
ELSE "Low Impact"
END AS Bowler_Impact
FROM bowlerstats
ORDER BY wickets DESC;

