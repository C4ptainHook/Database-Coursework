

SELECT SUM(it.estimated_price) FROM item it
            WHERE it.account_id = 7

DELETE FROM account WHERE id = 7

DELETE FROM activity WHERE id = 7

UPDATE request SET activity_id = NULL 
WHERE id = 6

SELECT * FROM task WHERE id = 7

CALL assign_validated(8, ARRAY[7]);

SELECT * FROM volunteer_task 

INSERT INTO task_competency(task_id, competency_id)
VALUES(7,4)

SELECT * FROM task_competency WHERE competency_id = 4

INSERT INTO critical_competency(name, level)
VALUES('Java Programing', 'Junior')

SELECT * FROM critical_competency

SELECT * FROM volunteer_competency WHERE competency_id = 4

INSERT INTO volunteer_competency(volunteer_id, competency_id)
VALUES(21,4);

CALL cancel_task(7,8);

SELECT * FROM status

SELECT id FROM status WHERE name = 'In progress'

receiver_id INT REFERENCES receiver(id) NOT NULL,
activity_id INT REFERENCES activity(id),
date DATE NOT NULL,
time TIME NOT NULL,
details TEXT


id SERIAL PRIMARY KEY,
group_name VARCHAR(255),
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255) NOT NULL,
phone_number VARCHAR(30) UNIQUE NOT NULL,
email VARCHAR(255) UNIQUE


INSERT INTO request (receiver_id, date, time, details)
VALUES (4, DATE'2024-01-25', TIME'11:30', 'Urgent request for assistance in the afternoon school event.');

INSERT INTO receiver (group_name, first_name, last_name, phone_number, email)
VALUES ('55 school', 'Emma', 'Smith', '+1234567890', 'emma.smith@example.com');

SELECT * FROM request

SELECT * FROM receiver

SELECT * FROM account

CALL accept_requests(ARRAY[2,3],'Help to the writer Alan Wake', 'University ord % FCB', DATE'2023-10-02');


SELECT * FROM task 

SELECT * FROM activity

UPDATE activity SET end_date = DATE'2022-01-14'
WHERE id = 2

SELECT * FROM account

SELECT * FROM item 

DELETE FROM item WHERE id = 6

SELECT is_activity_finished(2)

SELECT * FROM supplier

UPDATE item SET category_id = (SELECT id FROM category WHERE name = 'Military')

INSERT INTO item(account_id, request_id,naming,quantity,estimated_price)
VALUES(10, 6,'Nails',100,200);

CALL accept_requests(ARRAY[6],'Repair roof for school','University org & UkrBuild', DATE'2023-08-28');

UPDATE account SET reserved_amount = 285000 WHERE id = 1

CALL conclude_contract('Reignmetal', 'NL35RABO9521740876', 'Agreement with Righmetal for Mavic', ARRAY[3], DATE'2024-01-28',285000)

CALL deactivate_account(1);

SELECT * FROM contract

UPDATE contract SET status_id = 4
WHERE id = 18

INSERT INTO income(account_id,bank, date, time,amount,comment)
VALUES(1,'Pumb', CURRENT_DATE, CURRENT_TIME,320000,'For mavic drone');

DELETE FROM account WHERE id = 2

INSERT INTO account(type)
VALUES('Secondary')

SELECT amount FROM income WHERE account_id = 1;

ALTER TABLE account ALTER COLUMN target_amount SET DEFAULT(0)

CALL grab_from_main(10,1000);

SELECT get_hours(6);

