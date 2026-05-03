/* ============================================================
   Group 13: Bryan G Vera, Cameron J Bergeron, Dalton J Opudo, Lance Lamon Martin
   Local Sports League Management System DML
   Course: CS-3743 Database Systems
   ============================================================ */

USE group13_sports_league;
   
/*
=================================================================== 
Query 1 - Cameron Bergeron
A select statement with that includes at least two aggregate functions
Season scoring summary.
This query shows how active each season is by returning:
- total matches played
- total points scored
- average points scored per match
This includes at least two aggregate functions: COUNT, SUM, and AVG.
===================================================================
*/
SELECT
    s.season_name AS Season,
    sp.sport_name AS Sport,
    COUNT(m.match_id) AS Total_Matches,
    COALESCE(SUM(m.home_score + m.away_score), 0) AS Total_Points_Scored,
    COALESCE(ROUND(AVG(m.home_score + m.away_score), 2), 0) AS Avg_Points_Per_Match
FROM SEASON AS s
JOIN SPORT AS sp
    ON s.sport_id = sp.sport_id
LEFT JOIN MATCH_GAME AS m
    ON s.season_id = m.season_id
GROUP BY
    s.season_id,
    s.season_name,
    sp.sport_name
ORDER BY
    Total_Points_Scored DESC,
    Total_Matches DESC,
    s.season_name;
 
/*
============================================================
Query 2 - Dalton J Opudo
-- A select statement that uses at least one join, concatenation, 
-- and distinct clause
-- JOIN + CONCAT + DISTINCT
-- Purpose: Display unique coaches, their teams, and seasons
============================================================
*/
SELECT DISTINCT
    CONCAT(c.first_name, ' ', c.last_name) AS coach_name,
    t.team_name,
    s.season_name
FROM COACH c
JOIN COACH_TEAM_SEASON cts 
    ON c.coach_id = cts.coach_id
JOIN TEAM_SEASON ts 
    ON cts.team_season_id = ts.team_season_id
JOIN TEAM t 
    ON ts.team_id = t.team_id
JOIN SEASON s 
    ON ts.season_id = s.season_id
ORDER BY coach_name;
    
/*
===================================================================
Query 3 - Bryan Vera
-- A Select Statement that includes at least one subquery
-- This query returns the names of teams that have not lost a match
===================================================================
*/
SELECT t.team_name
FROM TEAM t
-- Match teams whose IDs appear in subquery
WHERE t.team_id IN (
	-- Get all team IDs from TEAM_SEASON that meet the condition below
    SELECT ts.team_id
    FROM TEAM_SEASON ts
    -- Exclude team_season_id that appears in the losing teams
    WHERE ts.team_season_id NOT IN (    
    -- Get Home and Away teams that lost
        SELECT home_team_season_id
        FROM MATCH_GAME
        WHERE home_score < away_score
        UNION
        SELECT away_team_season_id
        FROM MATCH_GAME
        WHERE away_score < home_score
    )
); 

/*
===================================================================
Query 4 - Lance Martin
-- A select statement that uses an ORDER BY clause
-- This query displays match results with team names and sorts
-- them by most recent match date first.
===================================================================
*/
SELECT
	mg.match_id,
	mg.match_datetime,
	ht.team_name AS home_team,
	at.team_name AS away_team,
	mg.home_score,
	mg.away_score,
	mg.match_status
FROM MATCH_GAME mg
JOIN TEAM_SEASON hts
	ON mg.home_team_season_id = hts.team_season_id
JOIN TEAM ht
	ON hts.team_id = ht.team_id
JOIN TEAM_SEASON ats
	ON mg.away_team_season_id = ats.team_season_id
JOIN TEAM at
	ON ats.team_id = at.team_id
ORDER BY mg.match_datetime DESC;

/*
===================================================================
Query 5 - Cameron Bergeron
Match results report.
This query gives league staff a readable game report
showing when a match happened, where it was played, the teams involved,
and the final score.
===================================================================
*/
SELECT
    m.match_id AS Match_ID,
    DATE(m.match_datetime) AS Match_Date,
    l.location_name AS Location,
    ht.team_name AS Home_Team,
    at.team_name AS Away_Team,
    CONCAT(m.home_score, ' - ', m.away_score) AS Final_Score,
    m.match_status AS Match_Status
FROM MATCH_GAME AS m
JOIN LOCATION AS l
    ON m.location_id = l.location_id
JOIN TEAM_SEASON AS hts
    ON m.home_team_season_id = hts.team_season_id
JOIN TEAM AS ht
    ON hts.team_id = ht.team_id
JOIN TEAM_SEASON AS ats
    ON m.away_team_season_id = ats.team_season_id
JOIN TEAM AS at
    ON ats.team_id = at.team_id
ORDER BY
    m.match_datetime;
    
/*
===================================================================
Query 6 - Cameron Bergeron
Coach assignment report.
This query shows which coach is assigned to each team
for each season, which is useful for administration and scheduling.
===================================================================
*/
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS Coach_Name,
    t.team_name AS Team,
    s.season_name AS Season,
    ts.division_name AS Division,
    c.phone_number AS Coach_Phone
FROM COACH_TEAM_SEASON AS cts
JOIN COACH AS c
    ON cts.coach_id = c.coach_id
JOIN TEAM_SEASON AS ts
    ON cts.team_season_id = ts.team_season_id
JOIN TEAM AS t
    ON ts.team_id = t.team_id
JOIN SEASON AS s
    ON ts.season_id = s.season_id
ORDER BY
    s.season_name,
    t.team_name; 
/*
============================================================
-- Query 7 - Dalton J Opudo
-- Purpose: Calculate total goals scored by each player
============================================================
*/
SELECT 
    p.player_id,
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    SUM(pms.goals) AS total_goals
FROM PLAYER p
JOIN PLAYER_MATCH_STAT pms 
    ON p.player_id = pms.player_id
GROUP BY p.player_id, player_name
ORDER BY total_goals DESC;

/*
============================================================
-- Query 8 - Dalton J Opudo
-- Purpose: Show matches sorted by most recent date
============================================================
*/
SELECT 
    match_id,
    match_datetime,
    match_status
FROM MATCH_GAME
ORDER BY match_datetime DESC;

/*
================================================================
Query 9
This query finds the top goal scorer for each team.
It helps identify the best performing player on every team.
===================================================================
*/
SELECT 
    t.team_name,
    p.first_name,
    p.last_name,
    SUM(pms.goals) AS total_goals
FROM PLAYER p

JOIN PLAYER_MATCH_STAT pms 
    ON p.player_id = pms.player_id

JOIN PLAYER_TEAM_SEASON pts 
    ON p.player_id = pts.player_id

JOIN TEAM_SEASON ts 
    ON pts.team_season_id = ts.team_season_id

JOIN TEAM t 
    ON ts.team_id = t.team_id

GROUP BY t.team_name, pts.team_season_id, p.player_id, p.first_name, p.last_name

HAVING total_goals = (
    SELECT MAX(team_goals)
    FROM (
        SELECT 
            SUM(pms2.goals) AS team_goals
        FROM PLAYER_MATCH_STAT pms2
        JOIN PLAYER_TEAM_SEASON pts2 
            ON pms2.player_id = pts2.player_id
        WHERE pts2.team_season_id = pts.team_season_id
        GROUP BY pts2.player_id
    ) AS team_totals
)

ORDER BY total_goals;

/*
===================================================================
Query 10 - Bryan Vera
This query lists all players along with the teams they are assigned to.
It joins multiple tables to connect each player to their corresponding teams
===================================================================
*/
SELECT 
    t.team_name,
    p.first_name,
    p.last_name,
    pts.jersey_number
FROM PLAYER p
-- Link players to their team-season assignment
JOIN PLAYER_TEAM_SEASON pts 
    ON p.player_id = pts.player_id
-- Link to team-season info
JOIN TEAM_SEASON ts 
    ON pts.team_season_id = ts.team_season_id
-- Get actual team name
JOIN TEAM t 
    ON ts.team_id = t.team_id
-- Order results 
ORDER BY t.team_name, p.last_name;

/*
===================================================================
Query 11 - Lance Martin
-- Purpose: Display total minutes played by each player
-- This query helps evaluate player participation by summing
-- the total minutes they played across all matches.
===================================================================
*/
SELECT
	p.player_id,
	CONCAT(p.first_name, ' ', p.last_name) AS player_name,
	SUM(pms.minutes_played) AS total_minutes_played
FROM PLAYER p
JOIN PLAYER_MATCH_STAT pms
	ON p.player_id = pms.player_id
GROUP BY p.player_id, player_name
ORDER BY total_minutes_played DESC;
/*
===================================================================
Query 12 - Lance Martin
-- Purpose: Show average total points scored per match at each location
-- This evaluates how high-scoring games are at different venues
-- and identifies locations with more offensive matches.
===================================================================
*/
SELECT
	l.location_name,
	ROUND(AVG(m.home_score + m.away_score), 2) AS avg_total_score
FROM LOCATION l
JOIN MATCH_GAME m
	ON l.location_id = m.location_id
GROUP BY l.location_name
ORDER BY avg_total_score DESC;

/*
===================================================================
Query 13
INSERT TRIGGER
-- Purpose: Automatically update team records after a match is inserted
===================================================================
*/
DELIMITER $$

CREATE TRIGGER update_team_stats_after_match
AFTER INSERT ON MATCH_GAME
FOR EACH ROW
BEGIN

	IF NEW.home_score > NEW.away_score THEN
		UPDATE TEAM_SEASON
		SET wins = wins + 1,
			points = points + 3
		WHERE team_season_id = NEW.home_team_season_id;
        
		UPDATE TEAM_SEASON
		SET losses = losses + 1
		WHERE team_season_id = NEW.away_team_season_id;
    
	ELSEIF NEW.away_score > NEW.home_score THEN
		UPDATE TEAM_SEASON
		SET wins = wins + 1,
			points = points + 3
		WHERE team_season_id = NEW.away_team_season_id;
	
		UPDATE TEAM_SEASON
		SET losses = losses + 1
		WHERE team_season_id = NEW.home_team_season_id;
        
	ELSE
		UPDATE TEAM_SEASON
		SET ties = ties + 1,
			points = points + 1
		WHERE team_season_id IN (NEW.home_team_season_id,NEW.away_team_season_id);
	END IF;
END$$
DELIMITER ;

/*
===================================================================
Query 14
DELETE TRIGGER
-- Purpose: Automatically reverse team records when a match is deleted
===================================================================
*/
DELIMITER $$

CREATE TRIGGER update_team_stats_after_delete
AFTER DELETE ON MATCH_GAME
FOR EACH ROW
BEGIN

	IF OLD.home_score > OLD.away_score THEN
		UPDATE TEAM_SEASON
		SET wins = wins - 1,
			points = points - 3
		WHERE team_season_id = OLD.home_team_season_id;
        
		UPDATE TEAM_SEASON
		SET losses = losses - 1
		WHERE team_season_id = OLD.away_team_season_id;
        
	ELSEIF OLD.away_score > OLD.home_score THEN
		UPDATE TEAM_SEASON
		SET wins = wins - 1,
			points = points - 3
		WHERE team_season_id = OLD.away_team_season_id;
		
        UPDATE TEAM_SEASON
		SET losses = losses - 1
		WHERE team_season_id = OLD.home_team_season_id;
        
	ELSE
		UPDATE TEAM_SEASON
		SET ties = ties - 1,
			points = points - 1
		WHERE team_season_id IN (OLD.home_team_season_id,OLD.away_team_season_id);
	END IF;
END$$
DELIMITER ;
