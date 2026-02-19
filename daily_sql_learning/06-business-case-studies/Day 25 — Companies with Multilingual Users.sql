---------------------------------------------------------------------------------------------
-- GOAL: Find companies having at least 2 users who speak both English & German.
---------------------------------------------------------------------------------------------
-- GOOGLE INTERVIEW QUESTION
---------------------------------------------------------------------------------------------
create table company_users (company_id int, user_id int, language varchar(20));

insert into company_users 
values (1,1,'English'), (1,1,'German'), (1,2,'English'), (1,3,'German'), (1,3,'English'),
	   (1,4,'English'), (2,5,'English'), (2,5,'German'), (2,5,'Spanish'), (2,6,'German'),
	   (2,6,'Spanish'), (2,7,'English');
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
SELECT * FROM company_users;

WITH users_lang AS (
	SELECT company_id, user_id,
		   COUNT(DISTINCT language) AS no_lang
	FROM company_users
	WHERE language IN ('English', 'German')
	GROUP BY company_id, user_id
	HAVING COUNT(DISTINCT language) = 2)
SELECT company_id, 
	   COUNT(*) AS No_users
FROM users_lang
GROUP BY company_id
HAVING COUNT(*) >= 2;