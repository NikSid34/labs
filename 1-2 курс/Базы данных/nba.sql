CREATE DATABASE NBA character set utf8 collate utf8_general_ci;

CREATE TABLE teams (
  title VARCHAR(30) NOT NULL  PRIMARY KEY,
  arena VARCHAR(30) NOT NULL,
  year_of_foundation YEAR NOT NULL,
  coach VARCHAR(30) NOT NULL,
  championships INT NOT NULL,
  conference VARCHAR(30) NOT NULL,
  division VARCHAR(30) NOT NULL,
  location VARCHAR(30) NOT NULL,
KEY (arena),
KEY (coach)
);


CREATE TABLE players (
  name VARCHAR(30) NOT NULL,
  surname VARCHAR(30) NOT NULL,
  team VARCHAR(30) NOT NULL,
  height VARCHAR(4) NOT NULL,
  weight INT NOT NULL,
  position VARCHAR(2) NOT NULL,
  age INT NOT NULL,
  nation VARCHAR(30) NOT NULL,
KEY (team),
PRIMARY KEY (name,surname),
FOREIGN KEY (team) REFERENCES teams (title)
);


CREATE TABLE arenas (
  title VARCHAR(30) NOT NULL PRIMARY KEY,
  year_of_foundation YEAR NOT NULL,
  capacity INT NOT NULL,
  team VARCHAR(30) NOT NULL,
  location VARCHAR(30) NOT NULL,
FOREIGN KEY (title) REFERENCES teams (arena)
);


CREATE TABLE coaches (
  name VARCHAR(15) NOT NULL,
  surname VARCHAR(15) NOT NULL,
  team VARCHAR(30) NOT NULL,
  age INT NOT NULL,
  experience INT NOT NULL,
PRIMARY KEY (surname),
FOREIGN KEY (surname) REFERENCES teams (coach)
);


insert into teams (title, arena, year_of_foundation, coach, championships, conference, division, location) values ("Golden State Warriors", "Chase Center", 1946, "Kerr", 6, "Western", "Pacific", "San Francisco" ), ("Lakers", "Staples Center", 1947, "Vogel", 17, "Western", "Pacific", "Los Angeles" ), ("Nets", "Barclays Center", 1967, "Nash", 2, "Eastern", "Atlantic", "Brooklyn" ), ("Mavericks", "American Airlines Center", 1980, "Kidd", 1, "Western", "Southwest", "Dallas" ), ("Celtics", "TD Garden", 1946, "Udoka", 17, "Eastern", "Atlantic", "Boston" ), ("Bulls", "United Center", 1966, "Donovan", 6, "Eastern", "Central", "Chicago" ), ("Bucks", "Fiserv Forum", 1968, "Budenholzer", 2, "Eastern", "Central", "Milwaukee" ),  ("Nuggets", "Ball Arena", 1967, "Malone", 0, "Western", "Northwest", "Denver"), ("Heat", "FTX Arena", 1988, "Spoelstra", 3, "Eastern", "Southeast", "Miami");

insert into players (name, surname, team, height, weight, position, age, nation) values ("Curry", "Stephen", "Golden State Warriors", "6'3", 185, "PG", 33, "USA" ), ("James", "LeBron", "Lakers", "6'9", 250, "SF", 36, "USA" ), ("Durant", "Kevin", "Nets", "6'10", 240, "SF", 33, "USA"),  ("Antetokounmpo", "Giannis", "Bucks", "6'11", 242, "PF", 26, "Greece"),  ("Thompson", "Klay", "Golden State Warriors", "6'6", 215, "SG", 31, "USA"), ("Davis", "Anthony", "Lakers", "6'10", 253, "C", 28, "USA" ), ("Doncic", "Luka", "Mavericks", "6'7", 230, "PG", 22, "Slovenia" ), ("Porzingis", "Kristaps", "Mavericks", "7'3", 240, "PF", 26, "Latvia" ), ("Tatum", "Jason", "Celtics", "6'8", 210, "SF", 33, "USA" ), ("Vucevic", "Nikola", "Bulls", "6'11", 260, "C", 30, "Montenegrin" );

insert into arenas (title,  year_of_foundation, capacity, team, location ) values ("Chase center", 2019, 18050, "Golden State Warriors","San Francisco"), ("Staples Center", 1999, 19000, "Lakers","Los Angeles"), ("Barclays Center", 2012, 18100, "Nets", "Brooklyn"),  ("American Airlines Center", 2001, 20000, "Mavericks", "Dallas"), ("TD Garden", 1995, 18600, "Celtics", "Boston"), ("United Center", 1994, 20900, "Bulls", "Chicago"), ("Fiserv Forum", 2018, 17500, "Bucks", "Milwaukee"), ("Ball Arena", 1999, 18000, "Nuggets", "Denver"), ("FTX Arena", 1999, 16500, "Heat", "Miami");

insert into coaches (name, surname, team, age, experience) values ("Steve", "Kerr", "Golden State Warriors", 56, 7), ("Frank", "Vogel", "Lakers", 48, 20),  ("Steve", "Nash", "Nets", 47, 1),  ("Jason", "Kidd", "Mavericks", 48, 8),  ("Ime", "Udoka", "Celtics", 44, 9),  ("Billy", "Donovan", "Bulls", 56, 31), ("Mike", "Budenholzer", "Bucks", 52, 28),("Michael", "Malone", "Denver", 50, 28), ("Erik", "Spoelstra", "Heat", 50, 28);


SELECT DISTINCT team FROM players;

SELECT DISTINCT nation FROM players WHERE nation!="USA";

SELECT conference, SUM(championships) as championships FROM teams GROUP BY conference;

SELECT division, SUM(championships ) as championships FROM teams GROUP BY division HAVING championships >1;

SELECT * FROM coaches ORDER BY experience DESC;

SELECT surname FROM players UNION  SELECT surname FROM coaches;


SELECT surname, name, title, coach, conference, division, location FROM players INNER JOIN teams ON players.team = teams.title;

SELECT surname, name, title, coach, conference, division, location FROM players LEFT OUTER JOIN teams ON players.team = teams.title;

SELECT surname, name, title, coach, conference, division, location FROM players RIGHT OUTER JOIN teams ON players.team = teams.title;

SELECT surname, name, title, coach, conference, division, location FROM players FULL OUTER JOIN teams ON players.team = teams.title;

SELECT surname, name, title, coach, conference, division, location FROM players CROSS JOIN teams;


delimiter $$
CREATE PROCEDURE championships_by_division()
 BEGIN
  SELECT division, SUM(championships ) as championships FROM teams GROUP BY division HAVING championships >1;
 END$$
delimiter ;
CALL championships_by_division();

delimiter $$
CREATE PROCEDURE get_team_by_title(IN a varchar(30))
 BEGIN
  SELECT * FROM teams WHERE title=a;
 END$$
delimiter ;
CALL get_team_by_title('Lakers');

delimiter $$
CREATE PROCEDURE average_weight(OUT a INT)
 BEGIN
  SELECT AVG(weight) INTO a FROM players;
 END$$
delimiter ;
CALL average_weight(@a);
SELECT (@a) AS average_weight;

delimiter $$
CREATE PROCEDURE max_championships_in_division(IN t VARCHAR(30), OUT a INT)
 BEGIN
  SELECT MAX(championships) INTO a FROM teams WHERE division=t;
 END$$
delimiter ;
CALL max_championships_in_division('Pacific', @a);
SELECT (@a) AS max_championships;


CREATE VIEW heavy_players
 AS 
  SELECT surname, name, weight FROM players ORDER BY weight DESC LIMIT 3;

CREATE VIEW w_conference
 AS
  SELECT * FROM teams WHERE conference = "Western"
  WITH  CHECK OPTION;

CREATE VIEW e_conference0
 AS
  SELECT * FROM teams WHERE conference = "Eastern";

CREATE VIEW e_conference
 AS
  SELECT * FROM e_conference0 
  WITH LOCAL CHECK OPTION;



SET TRANSACTION 
 ISOLATION LEVEL READ COMMITTED;
 UPDATE players SET age=age+1;
 UPDATE coaches SET age=age+1;
 UPDATE coaches SET experience=experience +1;
 SELECT * FROM coaches;
 COMMIT;

SET TRANSACTION 
 ISOLATION LEVEL SERIALIZABLE;
  insert into teams (title, arena, year_of_foundation, coach, championships, conference, division, location) values ("Spurs", "AT&T Center", 1967, "Popovich", 5, "Western", "Southwest", "San Antonio");
 CALL get_team_by_title('Spurs');
COMMIT;



CREATE USER 'first' IDENTIFIED BY '123';

CREATE USER 'second' IDENTIFIED BY '123';
