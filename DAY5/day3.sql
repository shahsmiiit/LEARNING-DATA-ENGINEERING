DROP DATABASE IF EXISTS `sandboxdb`;
CREATE DATABASE `sandboxdb` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

use `sandboxdb`;


CREATE TABLE api_logs (
    id INT PRIMARY KEY,
    payload JSON
);

INSERT INTO api_logs VALUES
(1, '{
  "employee_id": 101,
  "name": "Amit",
  "department": "IT",
  "skills": ["Python", "SQL", "AWS"],
  "salary": 75000
}'),
(2, '{
  "employee_id": 102,
  "name": "Neha",
  "department": "HR",
  "skills": ["Excel", "Recruitment"],
  "salary": 65000
}');
select * from api_logs;

# JSON : EXTRACT
# REMOVING ""
SELECT 
	id, 
	REPLACE(JSON_EXTRACT(payload, '$.name'), '"', '') as name,
	REPLACE(JSON_EXTRACT(payload, '$.department'), '"', '') as department,
	REPLACE(JSON_EXTRACT(payload, '$.salary'), '"', '') as salary
FROM api_logs;

SELECT 
	id, 
	payload->> '$.name' as name,
	payload->> '$.department' as department,
	payload->> '$.salary' as salary
FROM api_logs;

#
SELECT *
FROM api_logs
WHERE payload->>'$.department' = 'IT';

#update
UPDATE api_logs
SET payload = JSON_SET(payload, '$.salary', 80000)
WHERE id = 1;

select * from api_logs

#insert
UPDATE api_logs
SET payload = JSON_INSERT(payload, '$.location', 'BANGLORE')
WHERE id = 2;

#---xml------------------------------------------------------------------
CREATE TABLE xml_logs (
    id INT PRIMARY KEY,
    data LONGTEXT
);

INSERT INTO xml_logs VALUES
(1, '<company>
        <employee>
            <id>101</id>
            <name>Amit</name>
            <department>IT</department>
        </employee>
     </company>'),
(2, '<company>
        <employee>
            <id>102</id>
            <name>Neha</name>
            <department>HR</department>
        </employee>
     </company>');

#INSERT
SELECT 
    id,
    ExtractValue(data, '/company/employee/name') AS name,
    ExtractValue(data, '/company/employee/department') AS department
FROM xml_logs;

# Filter XML Data
SELECT *
FROM xml_logs
WHERE ExtractValue(data, '/company/employee/department') = 'IT';

INSERT INTO xml_logs VALUES
(3, '<company>
        <employee>
            <id>103</id>
            <name></name>
            <department>IT</department>
        </employee>
     </company>');


INSERT INTO xml_logs VALUES
(4, '<company>
        <employee>
            <id>104</id>
            <department>IT</department>
        </employee>
     </company>');

SELECT * FROM xml_logs;

UPDATE xml_logs
SET data = UpdateXML(data, '/company/employee/department', '<department>Tech</department>')
WHERE id = 3;

UPDATE xml_logs
SET data = UpdateXML(data, '/company/employee/name', '')
WHERE id = 3;

DELETE FROM xml_logs
WHERE ExtractValue(data, '/company/employee/id') = '104';





