DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TABLE Nationality (
    id_nationality SERIAL PRIMARY KEY,
    name_nationality VARCHAR(30) NOT NULL
);

ALTER TABLE Nationality
ADD CONSTRAINT unique_nationality_name UNIQUE (name_nationality);

CREATE TABLE Position (
    id_position SERIAL PRIMARY KEY,
    name_position VARCHAR(15) NOT NULL
);

ALTER TABLE Position
ADD CONSTRAINT unique_position_name UNIQUE (name_position);

CREATE TABLE Opponent (
    id_opponent SERIAL PRIMARY KEY,
    name_opponent VARCHAR(30) NOT NULL
);

ALTER TABLE Opponent
ADD CONSTRAINT unique_opponent_name UNIQUE (name_opponent);

CREATE TABLE Sponsor (
    id_sponsor SERIAL PRIMARY KEY,
    name_sponsor VARCHAR(30) NOT NULL
);

ALTER TABLE Sponsor
ADD CONSTRAINT unique_sponsor_name UNIQUE (name_sponsor);

CREATE TABLE League (
    id_league SERIAL PRIMARY KEY,
    name_league VARCHAR(30) NOT NULL
);

ALTER TABLE League
ADD CONSTRAINT unique_league_name UNIQUE (name_league);

CREATE TABLE Guide (
    id_guide SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    patronymic VARCHAR(30) NOT NULL,
    surname VARCHAR(30) NOT NULL,
    passport_data VARCHAR(80) NOT NULL,
    date_of_birth DATE NOT NULL,
    telephone VARCHAR(20) NOT NULL
);


ALTER TABLE Guide
ADD CONSTRAINT chk_telephone_guide CHECK (telephone ~ '^\+\d{1,2}\(\d{3}\)-\d{3}-\d{2}-\d{2}$');--чек телефона

ALTER TABLE Guide
ADD CONSTRAINT unique_passport_data_guide UNIQUE (passport_data);

CREATE TABLE Coaching_staff (
    id_coach_staff SERIAL PRIMARY KEY,
    date_statements DATE NOT NULL,
    id_guide INT NOT NULL
);

CREATE TABLE Competition (
    id_competition SERIAL PRIMARY KEY,
    place INT,
    prize_money DECIMAL(10, 2),
    id_league INT NOT NULL,
	date_competition DATE NOT NULL
);
ALTER TABLE Competition
ADD CONSTRAINT chk_date_competition CHECK (date_competition > '1950-01-01');

ALTER TABLE Competition
ADD CONSTRAINT chk_competition_place CHECK (place >= 1); -- Место должно быть положительным

ALTER TABLE Competition
ADD CONSTRAINT chk_prize_money CHECK (prize_money >= 0);--чек приз

CREATE TABLE Player (
    id_player SERIAL PRIMARY KEY,
    surname VARCHAR(30) NOT NULL,
    name VARCHAR(30) NOT NULL,
    passport_data VARCHAR(80) NOT NULL,
    date_of_birth DATE NOT NULL,
    number_player INT NOT NULL,
    height DECIMAL(5, 2), --
    weight DECIMAL(5, 2), --
    telephone VARCHAR(20) NOT NULL, --
    id_nationality INT NOT NULL,
    id_position INT NOT NULL,
    salary DECIMAL(10, 2), --
    patronymic VARCHAR(255),
	gender VARCHAR(30)
);

ALTER TABLE Player
ADD CONSTRAINT unique_passport_data_player UNIQUE (passport_data);

ALTER TABLE Player
ADD CONSTRAINT chk_height CHECK (height > 160); -- рост 

ALTER TABLE Player
ADD CONSTRAINT chk_weight CHECK (weight > 65 AND weight <110); -- вес 

ALTER TABLE Player
ADD CONSTRAINT chk_telephone_player CHECK (telephone ~ '^\+\d{1,2}\(\d{3}\)-\d{3}-\d{2}-\d{2}$');--чек телефона

ALTER TABLE Player
ADD CONSTRAINT chk_salary CHECK (salary > 15000);--зп

ALTER TABLE Player
ADD CONSTRAINT chk_player_number CHECK (number_player > 0); -- Номер игрока должен быть положительным

CREATE TABLE Contract (
    id_contract SERIAL PRIMARY KEY,
    id_player INT NOT NULL,
    date_of_conclusion DATE NOT NULL, -- <
    period_of_validity INT NOT NULL,
    id_sponsor INT,
    annual_payment DECIMAL(10, 2) --
);

ALTER TABLE Contract
ADD CONSTRAINT chk_annual_payment CHECK (annual_payment > 0);--зп

ALTER TABLE Contract
ADD CONSTRAINT chk_date_of_conclusion CHECK (date_of_conclusion > '1950-01-01');

ALTER TABLE Contract
ADD CONSTRAINT chk_contract_period CHECK (period_of_validity > 0); -- Период действия контракта должен быть положительным

CREATE TABLE ContractL (
    id_contract SERIAL PRIMARY KEY,
    annual_payment DECIMAL(10,2),
    period_validity INT NOT NULL,
    id_sponsor INT,
    id_competition INT
);


ALTER TABLE ContractL
ADD CONSTRAINT chk_contract_period CHECK (period_validity > 0); -- Период действия контракта должен быть положительным


CREATE TABLE Player_Staff (
    id_player_staff SERIAL PRIMARY KEY,
    id_player INT NOT NULL,
    id_staff INT NOT NULL
);

CREATE TABLE Staff (
    id_staff SERIAL PRIMARY KEY,
    date_of_conclusion DATE,
    id_guide INT NOT NULL,
    period_validity INT NOT NULL
);

CREATE TABLE Coaching_staff_Staff (
    id_coach_staff_staff SERIAL PRIMARY KEY,
    id_coach_staff INT,
    id_staff INT
);


CREATE TABLE Match (
    id_match SERIAL PRIMARY KEY,
    number_goals_scored INT,
    number_missed_pucks INT,
    number_tickets_sold INT,
    tactics VARCHAR(255),
    scheme VARCHAR(255),
    id_competition INT NOT NULL,
    id_opponent INT NOT NULL,
	date_match DATE NOT NULL,
	id_staff INT NOT NULL
);

ALTER TABLE Match
ADD CONSTRAINT chk_date_match CHECK (date_match > '1950-01-01');

ALTER TABLE Match
ADD CONSTRAINT chk_match_goals_scored CHECK (number_goals_scored >= 0); -- Количество голов не может быть отрицательным

ALTER TABLE Match
ADD CONSTRAINT chk_match_missed_pucks CHECK (number_missed_pucks >= 0); -- Количество пропущенных шайб не может быть отрицательным

ALTER TABLE Match
ADD CONSTRAINT chk_match_tickets_sold CHECK (number_tickets_sold >= 0); -- Количество проданных билетов не может быть отрицательным


CREATE TABLE Coach (
    id_coach SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    patronymic VARCHAR(30),
    surname VARCHAR(30) NOT NULL,
    passport_data VARCHAR(80) NOT NULL,
    date_of_birth DATE NOT NULL, --
    telephone VARCHAR(20), --
    license VARCHAR(100),
    date_of_acceptance DATE NOT NULL,--
    id_coach_staff INT NOT NULL
);

ALTER TABLE Coach
ADD CONSTRAINT chk_date_of_birth_coach CHECK (date_of_birth > '1900-01-01');

ALTER TABLE Coach
ADD CONSTRAINT chk_date_of_acceptance_coach CHECK (date_of_acceptance > '1900-01-01');

ALTER TABLE Coach
ADD CONSTRAINT chk_telephone_coach CHECK (telephone ~ '^\+\d{1,2}\(\d{3}\)-\d{3}-\d{2}-\d{2}$');--чек телефона

ALTER TABLE Coach
ADD CONSTRAINT unique_passport_data_coach UNIQUE (passport_data);




ALTER TABLE Match
ADD CONSTRAINT fk_staff_match FOREIGN KEY (id_staff) REFERENCES Staff(id_staff);

ALTER TABLE Player
ADD CONSTRAINT fk_player_nationality FOREIGN KEY (id_nationality) REFERENCES Nationality(id_nationality);

ALTER TABLE Player
ADD CONSTRAINT fk_player_position FOREIGN KEY (id_position) REFERENCES Position(id_position);

ALTER TABLE Contract
ADD CONSTRAINT fk_contract_player FOREIGN KEY (id_player) REFERENCES Player(id_player);

ALTER TABLE Contract
ADD CONSTRAINT fk_contract_sponsor FOREIGN KEY (id_sponsor) REFERENCES Sponsor(id_sponsor);

ALTER TABLE ContractL
ADD CONSTRAINT fk_contract_competition FOREIGN KEY (id_competition) REFERENCES Competition(id_competition);

ALTER TABLE ContractL
ADD CONSTRAINT fk_contract_sponsor FOREIGN KEY (id_sponsor) REFERENCES Sponsor(id_sponsor);

ALTER TABLE Competition
ADD CONSTRAINT fk_competition_league FOREIGN KEY (id_league) REFERENCES League(id_league);

ALTER TABLE Match
ADD CONSTRAINT fk_match_competition FOREIGN KEY (id_competition) REFERENCES Competition(id_competition);

ALTER TABLE Match
ADD CONSTRAINT fk_match_opponent FOREIGN KEY (id_opponent) REFERENCES Opponent(id_opponent);

ALTER TABLE Coach
ADD CONSTRAINT fk_coach_staff FOREIGN KEY (id_coach_staff) REFERENCES Coaching_staff(id_coach_staff);

ALTER TABLE Coaching_staff
ADD CONSTRAINT fk_coaching_staff_guide FOREIGN KEY (id_guide) REFERENCES Guide(id_guide);

ALTER TABLE Player_Staff
ADD CONSTRAINT fk_player FOREIGN KEY (id_player) REFERENCES Player(id_player);

ALTER TABLE Player_Staff
ADD CONSTRAINT fk_staff FOREIGN KEY (id_staff) REFERENCES Staff(id_staff);

ALTER TABLE Staff
ADD CONSTRAINT fk_guide_staff FOREIGN KEY (id_guide) REFERENCES Guide(id_guide);

ALTER TABLE Coaching_staff_Staff
ADD CONSTRAINT fk_coach_staff FOREIGN KEY (id_coach_staff) REFERENCES Coaching_staff(id_coach_staff);

ALTER TABLE Coaching_staff_Staff
ADD CONSTRAINT fk_staff_coach_staff FOREIGN KEY (id_staff) REFERENCES Staff(id_staff);

-- Nationality
INSERT INTO Nationality (name_nationality) 
VALUES ('Русский'), ('Американец'), ('Француз'), ('Немец'), ('Итальянец');

-- Position
INSERT INTO Position (name_position) 
VALUES ('Вратарь'), ('Защитник'), ('Нападающий'), ('Полузащитник');

-- Opponent
INSERT INTO Opponent (name_opponent) 
VALUES ('Команда А'), ('Команда Б'), ('Команда В'), ('Команда Г'), ('Команда Д');

-- Sponsor
INSERT INTO Sponsor (name_sponsor) 
VALUES ('Спонсор ?1_'), ('Спонсор *%2'), ('Спонсор 3'), ('Спонсор 4'), ('Спонсор 5');

-- League
INSERT INTO League (name_league) 
VALUES ('Лига 1'), ('Лига 2'), ('Лига 3'), ('Лига 4'), ('Лига 5');

-- Guide
INSERT INTO Guide (name, patronymic, surname, passport_data, date_of_birth, telephone) 
VALUES 
('Иван', 'Иванович', 'Иванов', '1234 567890', '1975-04-25', '+7(495)-123-45-67'),
('Петр', 'Петрович', 'Петров', '9876 543210', '1980-06-15', '+7(499)-234-56-78'),
('Олег', 'Алексеевич', 'Смирнов', '6543 210987', '1985-02-10', '+7(495)-876-54-32'),
('Дмитрий', 'Сергеевич', 'Ковалев', '5432 109876', '1990-08-19', '+7(495)-765-43-21'),
('Андрей', 'Михайлович', 'Николаев', '4321 098765', '1992-11-22', '+7(495)-654-32-10');

-- Coaching_staff
INSERT INTO Coaching_staff (date_statements, id_guide) 
VALUES 
('2022-01-01', (SELECT id_guide FROM Guide WHERE passport_data = '1234 567890')), 
('2023-05-10', (SELECT id_guide FROM Guide WHERE passport_data = '9876 543210')), 
('2023-07-15', (SELECT id_guide FROM Guide WHERE passport_data = '6543 210987')), 
('2024-02-01', (SELECT id_guide FROM Guide WHERE passport_data = '5432 109876')), 
('2024-03-22', (SELECT id_guide FROM Guide WHERE passport_data = '4321 098765'));

-- Competition
INSERT INTO Competition (place, prize_money, id_league, date_competition) 
VALUES 
(1, 1000000, (SELECT id_league FROM League WHERE name_league = 'Лига 1'), '2023-08-12'),
(2, 500000, (SELECT id_league FROM League WHERE name_league = 'Лига 2'), '2023-09-12'),
(3, 300000, (SELECT id_league FROM League WHERE name_league = 'Лига 3'), '2023-10-12'),
(4, 200000, (SELECT id_league FROM League WHERE name_league = 'Лига 4'), '2023-11-12'),
(5, 100000, (SELECT id_league FROM League WHERE name_league = 'Лига 5'), '2024-01-12');

-- Player
INSERT INTO Player (surname, name, passport_data, date_of_birth, number_player, height, weight, telephone, id_nationality, id_position, salary, patronymic, gender)
VALUES 
('Сидоров', 'Алексей', '1111 222233', '2004-03-20', 10, 185.5, 80.0, '+7(926)-111-22-33', 
	(SELECT id_nationality FROM Nationality WHERE name_nationality = 'Немец'), 
	(SELECT id_position FROM Position WHERE name_position = 'Нападающий'), 200000, 'Петрович', 'Мужчина'),
('Корн', 'Максим', '3333 444455', '1993-07-12', 5, 190.0, 85.5, '+7(916)-222-33-44',  
	(SELECT id_nationality FROM Nationality WHERE name_nationality = 'Итальянец'), 
	(SELECT id_position FROM Position WHERE name_position = 'Защитник'), 250000, 'Иванович', 'Мужчина'),
('Маск', 'Марк', '5555 666677', '2005-04-05', 12, 178.2, 75.0, '+7(905)-555-66-77',  
	(SELECT id_nationality FROM Nationality WHERE name_nationality = 'Американец'), 
	(SELECT id_position FROM Position WHERE name_position = 'Нападающий'), 180000, 'Игоревич', 'Мужчина'),
('Смирнов', 'Олег', '7777 888899', '1990-11-19', 8, 182.5, 79.3, '+7(917)-333-44-55',  
	(SELECT id_nationality FROM Nationality WHERE name_nationality = 'Русский'), 
	(SELECT id_position FROM Position WHERE name_position = 'Вратарь'), 220000, 'Алексеевич', 'Мужчина'),
('Петров', 'Алексей', '9999 000011', '1991-09-27', 6, 187.8, 83.2, '+7(903)-999-00-11',  
	(SELECT id_nationality FROM Nationality WHERE name_nationality = 'Немец'), 
	(SELECT id_position FROM Position WHERE name_position = 'Полузащитник'), 240000, 'Михайлович', 'Мужчина');

-- Contract
INSERT INTO Contract (id_player, date_of_conclusion, period_of_validity, id_sponsor, annual_payment)
VALUES 
((SELECT id_player FROM Player WHERE passport_data = '1111 222233'), '2023-07-01', 3, 
	(SELECT id_sponsor FROM Sponsor WHERE name_sponsor = 'Спонсор ?1_'), 500000),

((SELECT id_player FROM Player WHERE passport_data = '3333 444455'), '2022-11-15', 2,  
	(SELECT id_sponsor FROM Sponsor WHERE name_sponsor = 'Спонсор *%2'), 450000),

((SELECT id_player FROM Player WHERE passport_data = '5555 666677'), '2024-01-20', 4,  
	(SELECT id_sponsor FROM Sponsor WHERE name_sponsor = 'Спонсор 3'), 600000),

((SELECT id_player FROM Player WHERE passport_data = '9999 000011'), '2022-01-20', 4,  
	(SELECT id_sponsor FROM Sponsor WHERE name_sponsor = 'Спонсор 3'), 600000),

((SELECT id_player FROM Player WHERE passport_data = '7777 888899'), '2023-05-05', 3,  
	(SELECT id_sponsor FROM Sponsor WHERE name_sponsor = 'Спонсор 4'), 550000),

((SELECT id_player FROM Player WHERE passport_data = '1111 222233'), '2023-06-05', 2,  
	(SELECT id_sponsor FROM Sponsor WHERE name_sponsor = 'Спонсор 4'), 450000),

((SELECT id_player FROM Player WHERE passport_data = '3333 444455'), '2023-07-05', 1,  
	(SELECT id_sponsor FROM Sponsor WHERE name_sponsor = 'Спонсор 4'), 150000),

((SELECT id_player FROM Player WHERE passport_data = '1111 222233'), '2019-10-26', 5,  
	(SELECT id_sponsor FROM Sponsor WHERE name_sponsor = 'Спонсор 5'), 700000),

((SELECT id_player FROM Player WHERE passport_data = '1111 222233'), '2018-10-26', 3,  
	(SELECT id_sponsor FROM Sponsor WHERE name_sponsor = 'Спонсор 5'), 500000);

-- ContractL
INSERT INTO ContractL (annual_payment, period_validity, id_sponsor, id_competition) 
VALUES 
(300000, 2, (SELECT id_sponsor FROM Sponsor WHERE name_sponsor = 'Спонсор ?1_'), 
	(SELECT id_competition FROM Competition WHERE date_competition = '2023-08-12')),
(400000, 3, (SELECT id_sponsor FROM Sponsor WHERE name_sponsor = 'Спонсор *%2'), 
	(SELECT id_competition FROM Competition WHERE date_competition = '2023-09-12')),
(200000, 1, (SELECT id_sponsor FROM Sponsor WHERE name_sponsor = 'Спонсор 3'), 
	(SELECT id_competition FROM Competition WHERE date_competition = '2023-10-12')),
(450000, 2, (SELECT id_sponsor FROM Sponsor WHERE name_sponsor = 'Спонсор 4'), 
	(SELECT id_competition FROM Competition WHERE date_competition = '2023-11-12')),
(500000, 4, (SELECT id_sponsor FROM Sponsor WHERE name_sponsor = 'Спонсор 5'), 
	(SELECT id_competition FROM Competition WHERE date_competition = '2024-01-12'));
	

-- Staff
INSERT INTO Staff (date_of_conclusion, id_guide, period_validity) 
VALUES 
('2022-01-01', (SELECT id_guide FROM Guide WHERE passport_data = '1234 567890'), 1), 
('2023-05-10', (SELECT id_guide FROM Guide WHERE passport_data = '9876 543210'), 1), 
('2023-07-15', (SELECT id_guide FROM Guide WHERE passport_data = '6543 210987'), 2), 
('2024-02-01', (SELECT id_guide FROM Guide WHERE passport_data = '5432 109876'), 1), 
('2024-03-22', (SELECT id_guide FROM Guide WHERE passport_data = '4321 098765'), 1);

-- Match
INSERT INTO Match (number_goals_scored, number_missed_pucks, number_tickets_sold, tactics, scheme, id_competition, id_opponent, date_match, id_staff)
VALUES 
(3, 1, 5000, 'Атакующая', '4-4-2', (SELECT id_competition FROM Competition WHERE date_competition = '2023-08-12'), 
	(SELECT id_opponent FROM Opponent WHERE name_opponent = 'Команда А'), '2023-07-12',
	(SELECT id_staff FROM Staff WHERE date_of_conclusion = '2022-01-01')),
(2, 2, 4000, 'Защитная', '5-3-2', (SELECT id_competition FROM Competition WHERE date_competition = '2023-09-12'), 
	(SELECT id_opponent FROM Opponent WHERE name_opponent = 'Команда Б'), '2023-08-05',
	(SELECT id_staff FROM Staff WHERE date_of_conclusion = '2023-05-10')),
(4, 0, 6000, 'Атакующая', '4-3-3', (SELECT id_competition FROM Competition WHERE date_competition = '2023-10-12'), 
	(SELECT id_opponent FROM Opponent WHERE name_opponent = 'Команда В'), '2023-09-10',
	(SELECT id_staff FROM Staff WHERE date_of_conclusion = '2023-07-15')),
(1, 3, 3500, 'Контратакующая', '3-5-2', (SELECT id_competition FROM Competition WHERE date_competition = '2023-11-12'), 
	(SELECT id_opponent FROM Opponent WHERE name_opponent = 'Команда Г'), '2023-10-10',
	(SELECT id_staff FROM Staff WHERE date_of_conclusion = '2024-02-01')),
(0, 0, 4500, 'Защитная', '5-4-1', (SELECT id_competition FROM Competition WHERE date_competition = '2024-01-12'), 
	(SELECT id_opponent FROM Opponent WHERE name_opponent = 'Команда Д'),'2023-11-20',
	(SELECT id_staff FROM Staff WHERE date_of_conclusion = '2024-03-22'));

-- Player_Staff
INSERT INTO Player_Staff (id_staff, id_player)
VALUES 
((SELECT id_staff FROM Staff WHERE date_of_conclusion = '2022-01-01'), 
	(SELECT id_player FROM Player WHERE passport_data = '1111 222233')),
((SELECT id_staff FROM Staff WHERE date_of_conclusion = '2022-01-01'), 
	(SELECT id_player FROM Player WHERE passport_data = '3333 444455')),  
((SELECT id_staff FROM Staff WHERE date_of_conclusion = '2023-05-10'), 
	(SELECT id_player FROM Player WHERE passport_data = '3333 444455')), 
((SELECT id_staff FROM Staff WHERE date_of_conclusion = '2023-07-15'), 
	(SELECT id_player FROM Player WHERE passport_data = '1111 222233')), 
((SELECT id_staff FROM Staff WHERE date_of_conclusion = '2024-02-01'), 
	(SELECT id_player FROM Player WHERE passport_data = '5555 666677')), 
((SELECT id_staff FROM Staff WHERE date_of_conclusion = '2024-03-22'), 
	(SELECT id_player FROM Player WHERE passport_data = '7777 888899')), 
((SELECT id_staff FROM Staff WHERE date_of_conclusion = '2024-03-22'), 
	(SELECT id_player FROM Player WHERE passport_data = '1111 222233'));

-- Coach
INSERT INTO Coach (name, patronymic, surname, passport_data, date_of_birth, telephone, license, date_of_acceptance, id_coach_staff)
VALUES 
('Сергей', 'Владимирович', 'Орлов', '5555 666677', '1978-12-05', '+7(495)-555-66-77', 'A-123', '2020-01-15', 
	(SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2022-01-01')),
('Владимир', 'Алексеевич', 'Белоусов', '4444 555566', '1985-07-17', '+7(495)-444-55-66', 'B-456', '2021-05-20', 
	(SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2023-05-10')),
('Андрей', 'Николаевич', 'Соколов', '3333 444455', '1982-09-10', '+7(495)-333-44-55', 'C-789', '2022-11-30', 
	(SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2023-07-15')),
('Олег', 'Сергеевич', 'Миронов', '2222 333344', '1979-03-22', '+7(495)-222-33-44', 'D-012', '2019-08-25', 
	(SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2024-02-01')),
('Дмитрий', 'Иванович', 'Лебедев', '1111 222233', '1988-01-19', '+7(495)-111-22-33', 'E-345', '2023-02-10', 
	(SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2024-03-22')),
('Алексей', 'Сергеевич', 'Козлов', '1111 333344', '1990-06-14', NULL, 'E-346', '2023-03-15', 
    (SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2024-03-22')),
('Марина', 'Петровна', 'Смирнова', '1111 444455', '1985-11-25', '+7(495)-333-44-55', 'E-347', '2023-04-18', 
    (SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2024-03-22')),
('Иван', 'Иванович', 'Иванов', '1111 555566', '1993-02-07', '+7(495)-444-55-66', 'E-348', '2023-05-20', 
    (SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2022-01-01')),
('Екатерина', 'Владимировна', 'Новикова', '1111 666677', '1992-07-13', '+7(495)-555-66-77', 'E-349', '2023-06-25', 
    (SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2024-03-22')),
('Николай', 'Викторович', 'Зайцев', '1111 777788', '1987-09-19', '+7(495)-666-77-88', 'E-350', '2023-07-30', 
    (SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2024-03-22'));

-- Coaching_staff_Staff
INSERT INTO Coaching_staff_Staff (id_staff, id_coach_staff)
VALUES 
((SELECT id_staff FROM Staff WHERE date_of_conclusion = '2022-01-01'), 
	(SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2022-01-01')), 
((SELECT id_staff FROM Staff WHERE date_of_conclusion = '2023-05-10'), 
	(SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2023-05-10')), 
((SELECT id_staff FROM Staff WHERE date_of_conclusion = '2023-07-15'), 
	(SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2023-07-15')), 
((SELECT id_staff FROM Staff WHERE date_of_conclusion = '2024-02-01'), 
	(SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2024-02-01')), 
((SELECT id_staff FROM Staff WHERE date_of_conclusion = '2024-03-22'), 
	(SELECT id_coach_staff FROM Coaching_staff WHERE date_statements = '2024-03-22'));