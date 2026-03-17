----------------------------------------------------------------------------------------------------------------------------------------
-- GOAL: Generate a summary per employee showing total entries, login/logout counts, latest login/logout time, and default phone number.
----------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE employee_checkin_details (
    employeeid INT,
    entry_details VARCHAR(50),
    timestamp_details DATETIME
);

-- Insert Data into employee_checkin_details
INSERT INTO employee_checkin_details (employeeid, entry_details, timestamp_details) VALUES
(1000, 'login', '2023-06-16 01:00:15.340'),
(1000, 'login', '2023-06-16 02:00:15.340'),
(1000, 'login', '2023-06-16 03:00:15.340'),
(1000, 'logout', '2023-06-16 12:00:15.340'),
(1001, 'login', '2023-06-16 01:00:15.340'),
(1001, 'login', '2023-06-16 02:00:15.340'),
(1001, 'login', '2023-06-16 03:00:15.340'),
(1001, 'logout', '2023-06-16 12:00:15.340');

CREATE TABLE employee_details (
    employeeid INT,
    phone_number INT, -- Or BIGINT if phone numbers can be larger
    isdefault VARCHAR(512)
);

-- Insert Data into employee_details
INSERT INTO employee_details (employeeid, phone_number, isdefault) VALUES
(1001, 9999, 'FALSE'),
(1001, 1111,'FALSE'),
(1001, 2222, 'TRUE'),
(1003, 3333, 'FALSE');
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM employee_checkin_details;
SELECT * FROM employee_details;

SELECT ec.employeeid, COUNT(*) AS total_entries,
       SUM(CASE WHEN entry_details = 'login' THEN 1 ELSE 0 END) AS total_logins,
       SUM(CASE WHEN entry_details = 'logout' THEN 1 ELSE 0 END) AS total_logouts,
       MAX(CASE WHEN entry_details = 'login' THEN timestamp_details END) AS latest_login,
       MAX(CASE WHEN entry_details = 'logout' THEN timestamp_details END) AS latest_logout,
       MAX(CASE WHEN ed.isdefault = 'TRUE' THEN ed.phone_number END) AS default_phone_number
FROM employee_checkin_details ec
LEFT JOIN employee_details ed
    ON ec.employeeid = ed.employeeid
    AND ed.isdefault = 'TRUE'
GROUP BY ec.employeeid