_**# ICC-Cricket-T20_WorldCup-Exploration-and-Analysis**_

-- I have manually collected data from ESPN CricInfo, which can be done by web scraping via **Beautiful Soup** library of Python  too.
-- Let us begin--

--> Table creation by manual coding: (can be done in schema section too without coding)
    A. **Table #1: BatAvg**
    This table comprises of player names, their batting average, # of innings played, their teams and total runs scored.
    B. **Table #2: BatSR**
    This table gives primarily the strike rate of a batter, which is calculated as follows,
    ****Strike Rate = (# of runs scored/balls faced)*100****

_Note: You might find codes along the lines reading, "DROP TABLE table_name", this is just a precautionary measure 
   because I did some errors collecting and importing the data from ESPN_

  C. **Table #3: MostFifties**
     The total number of 50's scored by the batter, with respect to number of innings they took to do it.
  D. **Table #4: MostHundreds**
    The total number of 100's scored by the batter, with respect to number of innings they took to do it.
    In a T20I game, you rarely find a batter scoring a century because of obvious reasons.
    Usually in most cases, it will be one of top-4 batters from the batting order of a team who does it.
  E. **Table #5: HighestScores**
    This includes the highest score of a batter scored in a single innings.

--> Importing the data from MS Excel onto the MySQL Workbench:
    The respective data is imported to corresponding tables.

--> Performing an **INNER JOIN** onto tables #1 & #3 to analyze top-5 batsmen of WC2022 in terms of their batting average 
    and team.
    Did the grouping based on their teams to see which team had the better batters.
    ![InnerJoin_Query](https://github.com/JoysonPrince/EDA-and-General-Insights-using-MySQL/assets/137388224/c0ecc6ac-0ac9-48f3-8043-ae9a570531e5)

--> Inserted a column named TeamCoach into table #1 for more perspective related to coaching staff
    Each team has a different coach obviouly, and I accomplished it with the repeated use of UPDATE statement by changing 
    the coach names and their teams.

--> A **VIEW** creation named T20_Team_Ranking which can be used throughout the session of the database unlike CTE's
    This VIEW is just a modular view on using different SQL concepts.
    ![VIEW_Query](https://github.com/JoysonPrince/EDA-and-General-Insights-using-MySQL/assets/137388224/f079f570-8263-4580-9706-b26db3e57e2c)

--> The PRIMARY KEY, FOREIGN KEY is generally declared while designing the DB, but in some cases if there exist a need to 
    modify or alter the constraints, this is how it's done.
    Follow Step #6.

--> This step is again exploring and applying SQL concepts, where-in a multi-column indexing is done to return the query 
    fetching quickly. This is more in use for Data Engineers, & where there's a complex & large dataset involved.

--> Steps 8,9,10 decribes the importance of a batter scoring a fifty, and converting their starts into a more substantial 
    score leading to a century. (Although a century doesn't matter, a match-winning score albeit a smaller inning matters 
    more)
    This gives credibilty to the team and improves the confidence & pedigree of a batter.
    
Top-5 batters by number of runs scored:
    ![Top-5 runs query](https://github.com/JoysonPrince/EDA-and-General-Insights-using-MySQL/assets/137388224/f117fc99-0496-40e9-b677-8d465b1d6306)
    Top-5 batters with highest Strike Rates:
    ![Top-5 SR_Avg_query](https://github.com/JoysonPrince/EDA-and-General-Insights-using-MySQL/assets/137388224/fd58fdf7-3ab3-469b-b5c0-66afb15b1a87)
    Teams with most 50's scored:
![Most50s_query](https://github.com/JoysonPrince/EDA-and-General-Insights-using-MySQL/assets/137388224/7ae34a27-6c93-4341-8f52-d191885e4ba6)
    Teams with most 100's scored:
![Most100s_query](https://github.com/JoysonPrince/EDA-and-General-Insights-using-MySQL/assets/137388224/024e41e6-4c3a-4dc6-9663-6b43218f7954)


    

--> The batsmen are rated in a T2O game by their Strike Rate, average in the high-30's, this is described by Step 11

--> Created a table Bowlers, describing the data for bowlers:
   Strike Rate: The average number of balls bowled for every wicket taken
   **Number of balls/Wicket**
   Average: Number of runs conceded per wicket
   **Number of runs given/Total wickets taken**
   Economy Rate: The average number of runs conceded per over (An over has 6 balls)
   **Number of overs bowled/number of runs conceded**

   ![bowlers_query](https://github.com/JoysonPrince/EDA-and-General-Insights-using-MySQL/assets/137388224/fce7fd2c-39e8-4161-8c83-5a8f8546da0d)


--> The Economy Rate is added into the Bowlers table via generated column
    The column follows the formula for Economy Rate as mentioned above

![bowlers_col_query](https://github.com/JoysonPrince/EDA-and-General-Insights-using-MySQL/assets/137388224/22e7f1ae-945b-4c9d-b436-6b85a1cc8e14)

--> Exploring TRIGGER functionality:
    Whenever a new data is added into the Bowlers table, it should get auto-updated for every row record

![post_trigger_query](https://github.com/JoysonPrince/EDA-and-General-Insights-using-MySQL/assets/137388224/1c42087d-3e83-4072-a323-f62cb4bb0707)

--> Created another table BowlerStats for a neat data view on the stats.
    Added column 'Team' for which team the bowler belongs to & column 'StrikeRate' as well.

--> A couple of **Stored Procedures** describing top-performing bowlers & top-performing batters based on the stats.

i) This stored procedure gives a fixed result because the criteria is set to be bowlingaverage < 16 and Economyrate < 7.5, aka a deterministic output without any user input.
![storedproc1_query](https://github.com/JoysonPrince/EDA-and-General-Insights-using-MySQL/assets/137388224/722acafb-049a-4cb2-9735-9c308c1bc493)

ii) Here the user i asked to give 2 input parameters namely, team name & player name
![storedproc2_query](https://github.com/JoysonPrince/EDA-and-General-Insights-using-MySQL/assets/137388224/d02f81ca-0142-4f25-8f0a-eb26a5480aa5)

--> A **CASE Statement** to describe the best team based on their T2O Rankings.

![Case1_query](https://github.com/JoysonPrince/EDA-and-General-Insights-using-MySQL/assets/137388224/08c266d3-9575-4f6e-a5ce-96af4e3f0273)


--> **CASE Statement** to show the how the stats of a bowler has impacted his team.
    Keeping the Strike Rate as a criteria, describes how many balls he will bowl before picking up a wicket
    
![Case2_query](https://github.com/JoysonPrince/EDA-and-General-Insights-using-MySQL/assets/137388224/de3f102a-e05a-4f09-8552-59dd2cbe8cde)
    
   
 
