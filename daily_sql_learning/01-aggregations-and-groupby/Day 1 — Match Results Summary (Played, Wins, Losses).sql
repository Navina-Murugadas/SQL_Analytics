create database sql100;
use sql100;

create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;

-- Goal: Find matches played, won, and lost by each team.
SELECT team_name, 
	COUNT(1) AS no_of_matches_played, 
	SUM(win) AS no_of_matches_won, 
	COUNT(1) - SUM(win) AS no_of_losses
FROM(
SELECT Team_1 AS team_name, 
	CASE WHEN Team_1 = Winner THEN 1 ELSE 0 
	END AS win
FROM icc_world_cup
UNION ALL
SELECT Team_2 AS team_name, 
	CASE WHEN Team_2 = Winner THEN 1 ELSE 0 
	END AS win
FROM icc_world_cup
) t
GROUP BY team_name
ORDER BY no_of_matches_won DESC;

