/* ============================================================
   Group 13: Bryan G Vera, Cameron J Bergeron, Dalton J Opudo, Lance Lamon Martin
   Local Sports League Management System
   Course: CS-3743 Database Systems

   This script:
   1) Creates the database
   2) Creates all tables in dependency order
   3) Adds PK, FK, UNIQUE, and CHECK constraints
   4) Inserts sample data for testing queries
   ============================================================ */

DROP DATABASE IF EXISTS group13_sports_league;
CREATE DATABASE group13_sports_league;
USE group13_sports_league;

/* ===================== TABLES ===================== */

CREATE TABLE SPORT (
  sport_id INT PRIMARY KEY,
  sport_name VARCHAR(50) NOT NULL,
  sport_description VARCHAR(255)
);

CREATE TABLE SEASON (
  season_id INT PRIMARY KEY,
  sport_id INT NOT NULL,
  season_name VARCHAR(60) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  FOREIGN KEY (sport_id) REFERENCES SPORT(sport_id),
  CHECK (start_date <= end_date)
);

CREATE TABLE TEAM (
  team_id INT PRIMARY KEY,
  team_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE PLAYER (
  player_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  date_of_birth DATE,
  email VARCHAR(100) UNIQUE
);

CREATE TABLE COACH (
  coach_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100) UNIQUE,
  phone_number VARCHAR(15)
);

CREATE TABLE LOCATION (
  location_id INT PRIMARY KEY,
  location_name VARCHAR(100),
  address_line1 VARCHAR(100),
  city VARCHAR(50),
  state CHAR(2),
  zip_code VARCHAR(10)
);

CREATE TABLE TEAM_SEASON (
  team_season_id INT PRIMARY KEY,
  team_id INT,
  season_id INT,
  division_name VARCHAR(50),
  wins INT DEFAULT 0,
  losses INT DEFAULT 0,
  ties INT DEFAULT 0,
  points INT DEFAULT 0,
  UNIQUE (team_id, season_id),
  FOREIGN KEY (team_id) REFERENCES TEAM(team_id),
  FOREIGN KEY (season_id) REFERENCES SEASON(season_id)
);

CREATE TABLE PLAYER_TEAM_SEASON (
  player_season_id INT PRIMARY KEY,
  player_id INT,
  team_season_id INT,
  jersey_number VARCHAR(10),
  UNIQUE (player_id, team_season_id),
  FOREIGN KEY (player_id) REFERENCES PLAYER(player_id),
  FOREIGN KEY (team_season_id) REFERENCES TEAM_SEASON(team_season_id)
);

CREATE TABLE COACH_TEAM_SEASON (
  coach_team_season_id INT PRIMARY KEY,
  coach_id INT,
  team_season_id INT UNIQUE,
  FOREIGN KEY (coach_id) REFERENCES COACH(coach_id),
  FOREIGN KEY (team_season_id) REFERENCES TEAM_SEASON(team_season_id)
);

CREATE TABLE MATCH_GAME (
  match_id INT PRIMARY KEY,
  season_id INT,
  location_id INT,
  home_team_season_id INT,
  away_team_season_id INT,
  match_datetime DATETIME,
  home_score INT,
  away_score INT,
  match_status VARCHAR(20),
  UNIQUE (location_id, match_datetime),
  FOREIGN KEY (season_id) REFERENCES SEASON(season_id),
  FOREIGN KEY (location_id) REFERENCES LOCATION(location_id),
  FOREIGN KEY (home_team_season_id) REFERENCES TEAM_SEASON(team_season_id),
  FOREIGN KEY (away_team_season_id) REFERENCES TEAM_SEASON(team_season_id),
  CHECK (home_team_season_id <> away_team_season_id)
);

CREATE TABLE PLAYER_MATCH_STAT (
  player_match_stat_id INT PRIMARY KEY,
  match_id INT,
  player_id INT,
  goals INT DEFAULT 0,
  assists INT DEFAULT 0,
  fouls INT DEFAULT 0,
  minutes_played INT DEFAULT 0,
  UNIQUE (match_id, player_id),
  FOREIGN KEY (match_id) REFERENCES MATCH_GAME(match_id),
  FOREIGN KEY (player_id) REFERENCES PLAYER(player_id)
);

/* ===================== DATA ===================== */

START TRANSACTION;

/* Expanded sample data is designed to make reporting queries meaningful.
   Counts: 10 sports, 16 seasons, 24 teams, 48 players, 24 coaches,
   15 locations, 24 team-season records, 48 roster assignments,
   30 matches, and 96 player match stat rows. */

/* TABLE NAME : SPORT */
INSERT INTO SPORT VALUES
(1,'Soccer','Youth soccer league'),
(2,'Basketball','Community basketball league'),
(3,'Baseball','City baseball league'),
(4,'Volleyball','Indoor volleyball league'),
(5,'Flag Football','Non-contact football league'),
(6,'Tennis','Tennis league'),
(7,'Hockey','Ice hockey league'),
(8,'Swimming','Competitive swimming program'),
(9,'Track','Track and field program'),
(10,'Rugby','Community rugby league');

/* TABLE NAME : SEASON */
INSERT INTO SEASON VALUES
(111,1,'Spring Soccer 2025','2025-03-01','2025-05-18'),
(112,1,'Fall Soccer 2025','2025-09-01','2025-11-15'),
(113,2,'Winter Basketball 2025','2025-01-05','2025-03-10'),
(114,2,'Summer Basketball 2025','2025-06-01','2025-08-10'),
(115,3,'Spring Baseball 2025','2025-03-15','2025-06-15'),
(116,3,'Fall Baseball 2025','2025-09-01','2025-11-01'),
(117,4,'Fall Volleyball 2025','2025-09-01','2025-11-15'),
(118,5,'Summer Flag Football 2025','2025-06-01','2025-08-10'),
(119,6,'Spring Tennis 2025','2025-03-01','2025-05-01'),
(120,10,'Spring Rugby 2026','2026-03-01','2026-05-15'),
(121,7,'Winter Hockey 2025','2025-12-01','2026-02-01'),
(122,8,'Swimming Season 2025','2025-04-01','2025-06-01'),
(123,9,'Track Season 2025','2025-02-01','2025-04-01'),
(124,4,'Fall Volleyball 2024','2024-09-01','2024-11-15'),
(125,5,'Summer Flag Football 2026','2026-06-01','2026-08-10'),
(126,6,'Spring Tennis 2026','2026-03-01','2026-05-01');

/* TABLE NAME : TEAM */
INSERT INTO TEAM VALUES
(221,'Alamo Strikers'),
(222,'Cactus Kickers'),
(223,'Hilltop Hurricanes'),
(224,'River Runners'),
(225,'Court Kings'),
(226,'Fast Breakers'),
(227,'Hoop Hustlers'),
(228,'Backboard Bandits'),
(229,'Diamond Dynamos'),
(230,'Home Run Heroes'),
(231,'Pitch Perfect'),
(232,'Base Blazers'),
(233,'Spike Squad'),
(234,'Block Party'),
(235,'Serve Aces'),
(236,'Net Breakers'),
(237,'Blitz Brigade'),
(238,'Red Zone Raiders'),
(239,'First Down Force'),
(240,'Goal Line Guardians'),
(241,'Racket Rebels'),
(242,'Smash Squad'),
(243,'Volley Kings'),
(244,'Court Commanders');

/* TABLE NAME : PLAYER */
INSERT INTO PLAYER VALUES
(301,'Liam','Garcia','2010-01-01','liam.garcia@league.org'),
(302,'Emma','Lopez','2011-02-04','emma.lopez@league.org'),
(303,'Noah','Martinez','2012-03-07','noah.martinez@league.org'),
(304,'Sophia','Hernandez','2010-04-10','sophia.hernandez@league.org'),
(305,'Mason','Rivera','2011-05-13','mason.rivera@league.org'),
(306,'Olivia','Torres','2012-06-16','olivia.torres@league.org'),
(307,'Elijah','Perez','2010-07-19','elijah.perez@league.org'),
(308,'Ava','Castillo','2011-08-22','ava.castillo@league.org'),
(309,'Lucas','Morales','2012-09-25','lucas.morales@league.org'),
(310,'Mia','Flores','2010-10-01','mia.flores@league.org'),
(311,'Ethan','Sanchez','2011-11-04','ethan.sanchez@league.org'),
(312,'Isabella','Ramirez','2012-12-07','isabella.ramirez@league.org'),
(313,'Logan','Gonzalez','2010-01-10','logan.gonzalez@league.org'),
(314,'Camila','Reyes','2011-02-13','camila.reyes@league.org'),
(315,'James','Gutierrez','2012-03-16','james.gutierrez@league.org'),
(316,'Amelia','Vega','2010-04-19','amelia.vega@league.org'),
(317,'Benjamin','Cruz','2011-05-22','benjamin.cruz@league.org'),
(318,'Harper','Ortiz','2012-06-25','harper.ortiz@league.org'),
(319,'Daniel','Mendoza','2010-07-01','daniel.mendoza@league.org'),
(320,'Evelyn','Ramos','2011-08-04','evelyn.ramos@league.org'),
(321,'Mateo','Soto','2012-09-07','mateo.soto@league.org'),
(322,'Abigail','Jimenez','2010-10-10','abigail.jimenez@league.org'),
(323,'Samuel','Navarro','2011-11-13','samuel.navarro@league.org'),
(324,'Sofia','Aguilar','2012-12-16','sofia.aguilar@league.org'),
(325,'David','Vargas','2010-01-19','david.vargas@league.org'),
(326,'Victoria','Medina','2011-02-22','victoria.medina@league.org'),
(327,'Joseph','Silva','2012-03-25','joseph.silva@league.org'),
(328,'Luna','Campos','2010-04-01','luna.campos@league.org'),
(329,'Anthony','Delgado','2011-05-04','anthony.delgado@league.org'),
(330,'Grace','Rios','2012-06-07','grace.rios@league.org'),
(331,'Leo','Pena','2010-07-10','leo.pena@league.org'),
(332,'Chloe','Salazar','2011-08-13','chloe.salazar@league.org'),
(333,'Isaac','Valdez','2012-09-16','isaac.valdez@league.org'),
(334,'Nora','Fuentes','2010-10-19','nora.fuentes@league.org'),
(335,'Julian','Cabrera','2011-11-22','julian.cabrera@league.org'),
(336,'Layla','Acosta','2012-12-25','layla.acosta@league.org'),
(337,'Gabriel','Nunez','2010-01-01','gabriel.nunez@league.org'),
(338,'Aria','Herrera','2011-02-04','aria.herrera@league.org'),
(339,'Adrian','Molina','2012-03-07','adrian.molina@league.org'),
(340,'Zoe','Cardenas','2010-04-10','zoe.cardenas@league.org'),
(341,'Aaron','Espinoza','2011-05-13','aaron.espinoza@league.org'),
(342,'Natalie','Rosales','2012-06-16','natalie.rosales@league.org'),
(343,'Sebastian','Pacheco','2010-07-19','sebastian.pacheco@league.org'),
(344,'Aurora','Montoya','2011-08-22','aurora.montoya@league.org'),
(345,'Thomas','Ibarra','2012-09-25','thomas.ibarra@league.org'),
(346,'Elena','Leal','2010-10-01','elena.leal@league.org'),
(347,'Caleb','Quintero','2011-11-04','caleb.quintero@league.org'),
(348,'Maya','Benitez','2012-12-07','maya.benitez@league.org');

/* TABLE NAME : COACH */
INSERT INTO COACH VALUES
(401,'Daniel','Reed','daniel.reed@league.org','210-533-1001'),
(402,'Karen','Flores','karen.flores@league.org','210-235-1002'),
(403,'Marcus','Hill','marcus.hill@league.org','210-895-1003'),
(404,'Angela','Price','angela.price@league.org','210-547-1004'),
(405,'Victor','Santos','victor.santos@league.org','210-231-1005'),
(406,'Rachel','Nguyen','rachel.nguyen@league.org','210-093-1006'),
(407,'Brandon','Lopez','brandon.lopez@league.org','210-890-1007'),
(408,'Sofia','Diaz','sofia.diaz@league.org','210-467-1008'),
(409,'Luis','Garza','luis.garza@league.org','210-789-1009'),
(410,'Monica','Salinas','monica.salinas@league.org','210-555-1010'),
(411,'Evan','Brooks','evan.brooks@league.org','210-555-1011'),
(412,'Tanya','Morris','tanya.morris@league.org','210-555-1012'),
(413,'Jorge','Villarreal','jorge.villarreal@league.org','210-555-1013'),
(414,'Nina','Patel','nina.patel@league.org','210-555-1014'),
(415,'Omar','Khan','omar.khan@league.org','210-555-1015'),
(416,'Kelly','Watson','kelly.watson@league.org','210-555-1016'),
(417,'Hector','Mendez','hector.mendez@league.org','210-555-1017'),
(418,'Priya','Shah','priya.shah@league.org','210-555-1018'),
(419,'Andre','Coleman','andre.coleman@league.org','210-555-1019'),
(420,'Jasmine','Young','jasmine.young@league.org','210-555-1020'),
(421,'Patrick','Owen','patrick.owen@league.org','210-555-1021'),
(422,'Maribel','Rojas','maribel.rojas@league.org','210-555-1022'),
(423,'Chris','Evans','chris.evans@league.org','210-555-1023'),
(424,'Bianca','Wells','bianca.wells@league.org','210-555-1024');

/* TABLE NAME : LOCATION */
INSERT INTO LOCATION VALUES
(501,'Northside Sports Complex','100 Main St','San Antonio','TX','78201'),
(502,'Community Field West','250 Oak Ave','San Antonio','TX','78212'),
(503,'River Park Gym','88 River Rd','San Antonio','TX','78205'),
(504,'Eastside Recreation Center','410 Pine St','San Antonio','TX','78210'),
(505,'Mission Baseball Park','620 Mission Dr','San Antonio','TX','78214'),
(506,'Southside Fields','700 South St','San Antonio','TX','78211'),
(507,'Westside Courts','820 West Ave','San Antonio','TX','78207'),
(508,'Alamo City Arena','900 Arena Blvd','San Antonio','TX','78219'),
(509,'Hill Country Sports Park','1200 Hill Rd','San Antonio','TX','78255'),
(510,'Downtown Tennis Center','300 Center St','San Antonio','TX','78204'),
(511,'Leon Valley Athletic Center','4100 Bandera Rd','San Antonio','TX','78238'),
(512,'Stone Oak Sports Pavilion','19230 Stone Oak Pkwy','San Antonio','TX','78258'),
(513,'Medical Center Courts','7700 Floyd Curl Dr','San Antonio','TX','78229'),
(514,'Brooks City Base Fields','3201 Sidney Brooks','San Antonio','TX','78235'),
(515,'Helotes Community Park','12951 Bandera Rd','Helotes','TX','78023');

/* TABLE NAME : TEAM_SEASON */
INSERT INTO TEAM_SEASON VALUES
(601,221,111,'U14 Soccer',1,0,1,4),
(602,222,111,'U14 Soccer',1,1,0,3),
(603,223,111,'U14 Soccer',0,0,2,2),
(604,224,111,'U14 Soccer',0,1,1,1),
(605,225,113,'Junior Basketball',1,0,1,4),
(606,226,113,'Junior Basketball',1,1,0,3),
(607,227,113,'Junior Basketball',0,1,1,1),
(608,228,113,'Junior Basketball',1,1,0,3),
(609,229,115,'City Baseball',2,0,0,6),
(610,230,115,'City Baseball',0,2,0,0),
(611,231,115,'City Baseball',0,1,1,1),
(612,232,115,'City Baseball',1,0,1,4),
(613,233,117,'Open Volleyball',2,0,0,6),
(614,234,117,'Open Volleyball',0,2,0,0),
(615,235,117,'Open Volleyball',0,2,0,0),
(616,236,117,'Open Volleyball',2,0,0,6),
(617,237,118,'Flag Football',2,0,0,6),
(618,238,118,'Flag Football',0,2,0,0),
(619,239,118,'Flag Football',0,1,1,1),
(620,240,118,'Flag Football',1,0,1,4),
(621,241,119,'Tennis Singles',1,0,1,4),
(622,242,119,'Tennis Singles',0,2,0,0),
(623,243,119,'Tennis Singles',0,1,1,1),
(624,244,119,'Tennis Singles',2,0,0,6);

/* TABLE NAME : COACH_TEAM_SEASON */
INSERT INTO COACH_TEAM_SEASON VALUES
(801,401,601),
(802,402,602),
(803,403,603),
(804,404,604),
(805,405,605),
(806,406,606),
(807,407,607),
(808,408,608),
(809,409,609),
(810,410,610),
(811,411,611),
(812,412,612),
(813,413,613),
(814,414,614),
(815,415,615),
(816,416,616),
(817,417,617),
(818,418,618),
(819,419,619),
(820,420,620),
(821,421,621),
(822,422,622),
(823,423,623),
(824,424,624);

/* TABLE NAME : PLAYER_TEAM_SEASON */
INSERT INTO PLAYER_TEAM_SEASON VALUES
(701,301,601,'2'),
(702,302,601,'4'),
(703,303,602,'5'),
(704,304,602,'7'),
(705,305,603,'8'),
(706,306,603,'9'),
(707,307,604,'10'),
(708,308,604,'11'),
(709,309,605,'12'),
(710,310,605,'13'),
(711,311,606,'15'),
(712,312,606,'16'),
(713,313,607,'18'),
(714,314,607,'19'),
(715,315,608,'20'),
(716,316,608,'21'),
(717,317,609,'22'),
(718,318,609,'23'),
(719,319,610,'24'),
(720,320,610,'27'),
(721,321,611,'28'),
(722,322,611,'30'),
(723,323,612,'31'),
(724,324,612,'33'),
(725,325,613,'34'),
(726,326,613,'35'),
(727,327,614,'40'),
(728,328,614,'42'),
(729,329,615,'44'),
(730,330,615,'45'),
(731,331,616,'50'),
(732,332,616,'55'),
(733,333,617,'1'),
(734,334,617,'3'),
(735,335,618,'6'),
(736,336,618,'14'),
(737,337,619,'17'),
(738,338,619,'25'),
(739,339,620,'26'),
(740,340,620,'29'),
(741,341,621,'32'),
(742,342,621,'36'),
(743,343,622,'37'),
(744,344,622,'38'),
(745,345,623,'39'),
(746,346,623,'41'),
(747,347,624,'43'),
(748,348,624,'46');

/* TABLE NAME : MATCH_GAME */
INSERT INTO MATCH_GAME VALUES
(901,111,501,601,602,'2025-03-08 10:00:00',3,1,'Completed'),
(902,111,502,603,604,'2025-03-15 12:00:00',2,2,'Completed'),
(903,111,503,601,603,'2025-03-22 10:00:00',1,1,'Completed'),
(904,111,504,602,604,'2025-03-29 12:00:00',2,0,'Completed'),
(905,111,505,601,604,'2025-04-05 10:00:00',NULL,NULL,'Scheduled'),
(906,113,506,605,606,'2025-01-11 14:00:00',58,52,'Completed'),
(907,113,507,607,608,'2025-01-18 16:00:00',45,49,'Completed'),
(908,113,508,605,607,'2025-01-25 14:00:00',61,61,'Completed'),
(909,113,509,606,608,'2025-02-01 16:00:00',55,48,'Completed'),
(910,113,510,605,608,'2025-02-08 14:00:00',NULL,NULL,'Scheduled'),
(911,115,511,609,610,'2025-04-05 16:00:00',6,4,'Completed'),
(912,115,512,611,612,'2025-04-12 18:00:00',3,3,'Completed'),
(913,115,513,609,611,'2025-04-19 16:00:00',5,2,'Completed'),
(914,115,514,610,612,'2025-04-26 18:00:00',1,7,'Completed'),
(915,115,515,609,612,'2025-05-03 16:00:00',NULL,NULL,'Scheduled'),
(916,117,501,613,614,'2025-09-06 12:00:00',3,0,'Completed'),
(917,117,502,615,616,'2025-09-13 14:00:00',2,3,'Completed'),
(918,117,503,613,615,'2025-09-20 12:00:00',3,2,'Completed'),
(919,117,504,614,616,'2025-09-27 14:00:00',1,3,'Completed'),
(920,117,505,613,616,'2025-10-04 12:00:00',NULL,NULL,'Scheduled'),
(921,118,506,617,618,'2025-06-07 18:00:00',28,14,'Completed'),
(922,118,507,619,620,'2025-06-14 20:00:00',21,21,'Completed'),
(923,118,508,617,619,'2025-06-21 18:00:00',35,20,'Completed'),
(924,118,509,618,620,'2025-06-28 20:00:00',12,18,'Completed'),
(925,118,510,617,620,'2025-07-05 18:00:00',NULL,NULL,'Scheduled'),
(926,119,511,621,622,'2025-03-15 09:00:00',2,0,'Completed'),
(927,119,512,623,624,'2025-03-22 11:00:00',1,2,'Completed'),
(928,119,513,621,623,'2025-03-29 09:00:00',2,2,'Completed'),
(929,119,514,622,624,'2025-04-05 11:00:00',0,2,'Completed'),
(930,119,515,621,624,'2025-04-12 09:00:00',NULL,NULL,'Scheduled');

/* TABLE NAME : PLAYER_MATCH_STAT */
INSERT INTO PLAYER_MATCH_STAT VALUES
(1001,901,301,2,1,2,70),
(1002,901,302,1,1,0,70),
(1003,901,303,1,1,1,70),
(1004,901,304,0,0,2,70),
(1005,902,305,1,1,1,70),
(1006,902,306,1,1,2,70),
(1007,902,307,1,1,0,70),
(1008,902,308,1,1,1,70),
(1009,903,301,1,1,1,70),
(1010,903,302,0,0,2,70),
(1011,903,305,1,1,2,70),
(1012,903,306,0,0,0,70),
(1013,904,303,1,1,1,70),
(1014,904,304,1,1,2,70),
(1015,904,307,0,0,2,70),
(1016,904,308,0,0,0,70),
(1017,906,309,29,1,0,48),
(1018,906,310,29,1,1,48),
(1019,906,311,26,1,2,48),
(1020,906,312,26,1,0,48),
(1021,907,313,23,1,2,48),
(1022,907,314,22,1,0,48),
(1023,907,315,25,1,1,48),
(1024,907,316,24,1,2,48),
(1025,908,309,31,1,2,48),
(1026,908,310,30,1,0,48),
(1027,908,313,31,1,0,48),
(1028,908,314,30,1,1,48),
(1029,909,311,28,1,2,48),
(1030,909,312,27,1,0,48),
(1031,909,315,24,1,0,48),
(1032,909,316,24,1,1,48),
(1033,911,317,3,1,1,70),
(1034,911,318,3,1,2,70),
(1035,911,319,2,1,0,70),
(1036,911,320,2,1,1,70),
(1037,912,321,2,1,0,70),
(1038,912,322,1,1,1,70),
(1039,912,323,2,1,2,70),
(1040,912,324,1,1,0,70),
(1041,913,317,3,1,0,70),
(1042,913,318,2,1,1,70),
(1043,913,321,1,1,1,70),
(1044,913,322,1,1,2,70),
(1045,914,319,1,1,0,70),
(1046,914,320,0,0,1,70),
(1047,914,323,4,1,1,70),
(1048,914,324,3,1,2,70),
(1049,916,325,2,1,2,60),
(1050,916,326,1,1,0,60),
(1051,916,327,0,0,1,60),
(1052,916,328,0,0,2,60),
(1053,917,329,1,1,1,60),
(1054,917,330,1,1,2,60),
(1055,917,331,2,1,0,60),
(1056,917,332,1,1,1,60),
(1057,918,325,2,1,1,60),
(1058,918,326,1,1,2,60),
(1059,918,329,1,1,2,60),
(1060,918,330,1,1,0,60),
(1061,919,327,1,1,1,60),
(1062,919,328,0,0,2,60),
(1063,919,331,2,1,2,60),
(1064,919,332,1,1,0,60),
(1065,921,333,14,1,0,60),
(1066,921,334,14,1,1,60),
(1067,921,335,7,1,2,60),
(1068,921,336,7,1,0,60),
(1069,922,337,11,1,2,60),
(1070,922,338,10,1,0,60),
(1071,922,339,11,1,1,60),
(1072,922,340,10,1,2,60),
(1073,923,333,18,1,2,60),
(1074,923,334,17,1,0,60),
(1075,923,337,10,1,0,60),
(1076,923,338,10,1,1,60),
(1077,924,335,6,1,2,60),
(1078,924,336,6,1,0,60),
(1079,924,339,9,1,0,60),
(1080,924,340,9,1,1,60),
(1081,926,341,1,1,1,7),
(1082,926,342,1,1,2,7),
(1083,926,343,0,0,0,7),
(1084,926,344,0,0,1,7),
(1085,927,345,1,1,0,7),
(1086,927,346,0,0,1,7),
(1087,927,347,1,1,2,7),
(1088,927,348,1,1,0,7),
(1089,928,341,1,1,0,7),
(1090,928,342,1,1,1,7),
(1091,928,345,1,1,1,7),
(1092,928,346,1,1,2,7),
(1093,929,343,0,0,0,7),
(1094,929,344,0,0,1,7),
(1095,929,347,1,1,1,7),
(1096,929,348,1,1,2,7);

COMMIT;
