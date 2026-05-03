**Data Dictionary:**

&#x20;

**SPORT** 

Column "sport\_id" is INT, primary key 

Column "sport\_name" is VARCHAR(50), not null 

Column "sport\_description" is VARCHAR(255)

&#x20;

**SEASON** 

Column "season\_id" is INT, primary key 

Column "sport\_id" is INT, foreign key references SPORT(sport\_id) 

Column "season\_name" is VARCHAR(60), not null 

Column "start\_date" is DATE, not null 

Column “end\_date” is DATE, not null

&#x20;

**TEAM** 

Column "team\_id" is INT, primary key 

Column "team\_name" is VARCHAR(100), not null, unique

&#x20;

**TEAM\_SEASON** 

Column "team\_season\_id" is INT, primary key 

Column "team\_id" is INT, foreign key references TEAM(team\_id) 

Column "season\_id" is INT, foreign key references SEASON(season\_id) 

Column "division\_name" is VARCHAR(50), not null 

Column "wins" is INT, default 0 

Column "losses" is INT, default 0 

Column "ties" is INT, default 0 

Column "points" is INT, default 0

&#x20;

**PLAYER** 

Column "player\_id" is INT, primary key 

Column "first\_name" is VARCHAR(50), not null 

Column "last\_name" is VARCHAR(50), not null 

Column "date\_of\_birth" is DATE, not null 

Column "email" is VARCHAR(100), unique

&#x20;

**PLAYER\_TEAM\_SEASON** 

Column "player\_team\_season\_id" is INT, primary key 

Column "player\_id" is INT, foreign key references PLAYER(player\_id) 

Column "team\_season\_id" is INT, foreign key references TEAM\_SEASON(team\_season\_id) 

Column "jersey\_number" is VARCHAR(10)

&#x20;

**COACH** 

Column "coach\_id" is INT, primary key 

Column "first\_name" is VARCHAR(50), not null 

Column "last\_name" is VARCHAR(50), not null 

Column "email" is VARCHAR(100), unique 

Column "phone\_number" is VARCHAR(15)

&#x20;

**COACH\_TEAM\_SEASON** 

Column "coach\_team\_season\_id" is INT, primary key 

Column "coach\_id" is INT, foreign key references COACH(coach\_id) 

Column "team\_season\_id" is INT, foreign key references TEAM\_SEASON(team\_season\_id) 

Column "role" is VARCHAR(50)

&#x20;

**LOCATION** 

Column "location\_id" is INT, primary key 

Column "location\_name" is VARCHAR(100), not null 

Column "address\_line1" is VARCHAR(100), not null 

Column "city" is VARCHAR(50), not null 

Column "state" is CHAR(2), not null 

Column "zip\_code" is VARCHAR(10), not null

&#x20;

**MATCH\_GAME** 

Column "match\_id" is INT, primary key 

Column "season\_id" is INT, foreign key references SEASON(season\_id) 

Column "location\_id" is INT, foreign key references LOCATION(location\_id) 

Column "home\_team\_season\_id" is INT, foreign key references TEAM\_SEASON(team\_season\_id) 

Column "away\_team\_season\_id" is INT, foreign key references TEAM\_SEASON(team\_season\_id) 

Column "match\_datetime" is DATETIME, not null 

Column "home\_score" is INT 

Column "away\_score" is INT 

Column "match\_status" is VARCHAR(20), not null

&#x20;

**PLAYER\_MATCH\_STAT** 

Column "player\_match\_stat\_id" is INT, primary key 

Column "match\_id" is INT, foreign key references MATCH(match\_id) 

Column "player\_id" is INT, foreign key references PLAYER(player\_id) 

Column "goals" is INT, default 0 

Column "assists" is INT, default 0 

Column "fouls" is INT, default 0 

Column "minutes\_played" is INT, default 0 



