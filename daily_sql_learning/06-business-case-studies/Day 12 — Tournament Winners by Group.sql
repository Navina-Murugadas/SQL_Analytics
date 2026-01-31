create table players
(player_id int,
group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);

SELECT * FROM players;
SELECT * FROM matches;

-- Write an SQL query to find the winner in each group.
-- The winner in each group is the player who scored the maximum total points within the group. 
-- In the case of a tie, the lowest player_id wins.

WITH players_info AS (
	SELECT first_player AS player, first_score AS score
	FROM matches
	UNION ALL
	SELECT second_player AS player, second_score AS score
	FROM matches
),
score_board AS (
SELECT p.group_id, po.player, SUM(po.score) AS score
FROM players_info po
INNER JOIN players p
	ON po.player = p.player_id
GROUP BY group_id, po.player
),
ranking AS (
SELECT *,
	RANK() OVER(PARTITION BY group_id
				ORDER BY score DESC, player ASC)
				AS rnk
FROM score_board
)
SELECT r.group_id, r.player, r.score
FROM ranking r
WHERE rnk = 1;
