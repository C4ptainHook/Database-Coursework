-- Receiver block
CREATE TABLE receiver (
id SERIAL PRIMARY KEY,
group_name VARCHAR(255),
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255) NOT NULL,
phone_number VARCHAR(30) UNIQUE NOT NULL,
email VARCHAR(255) UNIQUE
); 
-- Activity block
CREATE TABLE activity(
id SERIAL PRIMARY KEY,
objective VARCHAR(255) NOT NULL,
description TEXT,	
organizer VARCHAR(255) NOT NULL,
start_date DATE NOT NULL,	
end_date DATE
);
CREATE TABLE request (
id SERIAL PRIMARY KEY,
receiver_id INT REFERENCES receiver(id) NOT NULL,
activity_id INT REFERENCES activity(id),
date DATE NOT NULL,
time TIME NOT NULL,
details TEXT
);
CREATE TABLE location (
id SERIAL PRIMARY KEY,
activity_id INT REFERENCES activity(id) NOT NULL,
name VARCHAR(255) NOT NULL,
street VARCHAR(255) NOT NULL,
building_number SMALLINT,
city VARCHAR(255) NOT NULL,
country VARCHAR(255)
);
--Account block
CREATE TABLE account (
id SERIAL PRIMARY KEY,
activity_id INT REFERENCES activity(id) UNIQUE,
type VARCHAR(15) NOT NULL,
current_amount DECIMAL(S20,8) DEFAULT 0,
target_amount DECIMAL(20,8)
);
CREATE TABLE income (
id SERIAL PRIMARY KEY,
account_id INT REFERENCES account(id) NOT NULL,
bank VARCHAR(255) NOT NULL,
date DATE NOT NULL,
time TIME NOT NULL,
amount DECIMAL(18,8) NOT NULL,
comment VARCHAR(255)
);
--Contract block
CREATE TABLE status (
id SERIAL PRIMARY KEY,
name VARCHAR(100) UNIQUE
);
CREATE TABLE supplier (
id SERIAL PRIMARY KEY,
title VARCHAR(255) NOT NULL,
iban VARCHAR(34) NOT NULL UNIQUE,
country VARCHAR(255)
);
CREATE TABLE contract (
id SERIAL PRIMARY KEY,
supplier_id INT REFERENCES supplier(id) NOT NULL,
status_id INT REFERENCES status(id) NOT NULL,
title VARCHAR(255) NOT NULL,
conclude_date DATE NOT NULL,
fulfill_date DATE NOT NULL,
feedback SMALLINT
);
--Item block
CREATE TABLE category (
id SERIAL PRIMARY KEY,
name VARCHAR(255) NOT NULL UNIQUE
);
CREATE TABLE item (
id SERIAL PRIMARY KEY,
account_id INT REFERENCES account(id) NOT NULL,
request_id INT REFERENCES request(id),
contract_id INT REFERENCES contract(id),
naming VARCHAR(255) NOT NULL,
price DECIMAL(18,8),
quantity INT NOT NULL,
category_id INT REFERENCES category(id)
); 
--Volunteer block
CREATE TABLE volunteer (
id SERIAL PRIMARY KEY,
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255) NOT NULL,
date_of_birth DATE NOT NULL,
gender CHAR(1),
phone_number VARCHAR(30) UNIQUE NOT NULL,
email VARCHAR(255) UNIQUE,	
registration_date TIMESTAMP DEFAULT NOW(),
password VARCHAR(255) NOT NULL,
last_login_date TIMESTAMP DEFAULT NOW(),
active BOOLEAN DEFAULT true
);
--Competency block
CREATE TABLE critical_competency (
id SERIAL PRIMARY KEY,
name VARCHAR(255) NOT NULL,
level VARCHAR(100) NOT NULL,
CONSTRAINT comp_level_identity UNIQUE (name,level)
);
--Task block
CREATE TABLE task (
id SERIAL PRIMARY KEY,
activity_id INT REFERENCES activity(id) NOT NULL,
description TEXT NOT NULL,
duration SMALLINT NOT NULL,
importance SMALLINT,	
status_id INT REFERENCES status(id) NOT NULL
);
CREATE TABLE task_log (
id SERIAL PRIMARY KEY,
task_id INT REFERENCES task(id) NOT NULL,
volunteer_id INT REFERENCES volunteer(id) NOT NULL,
date DATE NOT NULL,
time TIME NOT NULL,	
status_id INT REFERENCES status(id)	NOT NULL
);
--Many-to-many tables
CREATE TABLE task_competency (
competency_id INT REFERENCES critical_competency(id),
task_id INT REFERENCES task(id),
CONSTRAINT task_competency_dual_pkey PRIMARY KEY(competency_id, task_id)	
);
CREATE TABLE volunteer_competency (
volunteer_id INT REFERENCES volunteer(id),
competency_id INT REFERENCES critical_competency(id),
CONSTRAINT volunteer_competency_dual_pkey PRIMARY KEY(volunteer_id, competency_id)	
);
CREATE TABLE volunteer_task (
volunteer_id INT REFERENCES volunteer(id),
task_id INT REFERENCES task(id),
CONSTRAINT volunteer_task_dual_pkey PRIMARY KEY(volunteer_id, task_id)	
);

