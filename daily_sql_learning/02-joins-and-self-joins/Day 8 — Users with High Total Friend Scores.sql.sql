---------------------------------------------------------------------------------------------
-- GOAL: For each person, check if the sum of their friends’ scores is above 100.
---------------------------------------------------------------------------------------------
Create table friend (pid int, fid int);
insert into friend (pid , fid ) values ('1','2');
insert into friend (pid , fid ) values ('1','3');
insert into friend (pid , fid ) values ('2','1');
insert into friend (pid , fid ) values ('2','3');
insert into friend (pid , fid ) values ('3','5');
insert into friend (pid , fid ) values ('4','2');
insert into friend (pid , fid ) values ('4','3');
insert into friend (pid , fid ) values ('4','5');

create table person (PersonID int,	Name varchar(50),	Score int);
insert into person(PersonID,Name ,Score) values('1','Alice','88');
insert into person(PersonID,Name ,Score) values('2','Bob','11');
insert into person(PersonID,Name ,Score) values('3','Devis','27');
insert into person(PersonID,Name ,Score) values('4','Tara','45');
insert into person(PersonID,Name ,Score) values('5','John','63');
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
select * from person;
select * from friend;

WITH per_friends AS (
	SELECT f.pid, SUM(p.Score) AS total_friend_score, COUNT(*) AS no_of_friends
	FROM friend f
	INNER JOIN person p
		ON f.fid = p.PersonID
	GROUP BY f.pid
	HAVING SUM(p.Score) > 100
)
SELECT pf.*, p.name
FROM per_friends pf
INNER JOIN person p
	ON pf.pid = p.PersonID;
