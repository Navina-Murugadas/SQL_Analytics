---------------------------------------------------------------------------------------------
-- GOAL: Find callers whose first and last call of the day were made to the same recipient.
---------------------------------------------------------------------------------------------
create table phonelog(
    Callerid int, 
    Recipientid int,
    Datecalled datetime
);

insert into phonelog(Callerid, Recipientid, Datecalled)
values(1, 2, '2019-01-01 09:00:00.000'),
       (1, 3, '2019-01-01 17:00:00.000'),
       (1, 4, '2019-01-01 23:00:00.000'),
       (2, 5, '2019-07-05 09:00:00.000'),
       (2, 3, '2019-07-05 17:00:00.000'),
       (2, 3, '2019-07-05 17:20:00.000'),
       (2, 5, '2019-07-05 23:00:00.000'),
       (2, 3, '2019-08-01 09:00:00.000'),
       (2, 3, '2019-08-01 17:00:00.000'),
       (2, 5, '2019-08-01 19:30:00.000'),
       (2, 4, '2019-08-02 09:00:00.000'),
       (2, 5, '2019-08-02 10:00:00.000'),
       (2, 5, '2019-08-02 10:45:00.000'),
       (2, 4, '2019-08-02 11:00:00.000');
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
SELECT * FROM phonelog;

WITH First_Last_Call AS (
    SELECT Callerid,
           CAST(Datecalled AS DATE) Call_date,
           MIN(Datecalled) AS First_call,
           MAX(Datecalled) AS Last_call
    FROM phonelog
    GROUP BY Callerid, CAST(Datecalled AS DATE))
SELECT fl.Callerid, fl.Call_date, pl1.Recipientid
FROM First_Last_Call fl
INNER JOIN phonelog pl1
    ON fl.Callerid = pl1.Callerid
    AND fl.First_call = pl1.Datecalled
INNER JOIN phonelog pl2
    ON fl.Callerid = pl2.Callerid
    AND fl.Last_call = pl2.Datecalled
WHERE pl1.Recipientid = pl2.Recipientid;