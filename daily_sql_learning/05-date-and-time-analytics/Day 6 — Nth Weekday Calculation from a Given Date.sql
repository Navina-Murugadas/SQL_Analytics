/*
Day			Number
Sunday		1
Monday		2
Tuesday		3
Wednesday	4
Thursday	5
Friday		6
Saturday	7
---------------------------------------------------------------------------------------------
FIRST OCCURENCE OF NEXT SUNDAY:
8 - DATEPART(WEEKDAY, @date)

FIRST OCCURENCE OF NEXT SPECIFIED WEEKDAY (MON - SAT):
Including Today --> (7 + TargetDayNumber - DATEPART(WEEKDAY, @today)) % 7 
Excluding Today --> ((7 + TargetDayNumber - DATEPART(WEEKDAY, @today)) % 7) + 7
*/
---------------------------------------------------------------------------------------------

-- Date of nth occurrence of ANY WEEKDAY in future from given date.
-- DATEADD(DAY, (7 + TargetDayNumber - DATEPART(WEEKDAY, @today)) % 7, @today)

-- TARGET: Nth WEDNESDAY:
DECLARE @today DATE;
DECLARE @n INT;
SET @today = '2025-12-01'	-- MONDAY 
SET @n = 3;					-- Nth Occurence

-- Days to be added for next WEDNESDAY:
SELECT (7 + 4 - DATEPART(WEEKDAY, @today)) % 7 AS Days_to_be_added;

-- Next occurence of WEDNESDAY:
SELECT DATEADD(DAY, (7 + 4 - DATEPART(WEEKDAY, @today)) % 7, @today) AS Next_occ;

-- 3rd occurence of the next WEDNESDAY:
DECLARE @first_occ DATE = DATEADD(DAY, (7 + 4 - DATEPART(WEEKDAY, @today)) % 7, @today);
SELECT DATEADD(WEEK, @n-1, @first_occ) AS Nth_Occurence;
