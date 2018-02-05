/*
Seventh section of sqlzoo, more JOIN
*/


--#1
/*
List the films where the yr is 1962 [Show id, title]
列出1962年首影的電影， [顯示 id, title]
*/
SELECT id, title
FROM movie
WHERE yr=1962

--#2
/*
Give year of 'Citizen Kane'.
電影大國民 'Citizen Kane' 的首影年份。
*/
SELECT yr
FROM movie
WHERE title = 'Citizen Kane'

--#3
/*
List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title).
列出全部Star Trek星空奇遇記系列的電影，包括id, title 和 yr(此系統電影都以Star Trek為電影名稱的開首)。按年份順序排列。Order results by year.
*/
SELECT id, title, yr
FROM movie
WHERE title LIKE '%star trek%'
ORDER BY yr

--#4
/*
What are the titles of the films with id 11768, 11955, 21191
id是 11768, 11955, 21191 的電影是什麼名稱?
*/
SELECT title
FROM movie
WHERE id IN ( 11768, 11955, 21191)

--#5
/*
What id number does the actor 'Glenn Close' have?
女演員'Glenn Close'的編號 id是什麼?
*/
SELECT id
FROM actor
WHERE name = 'Glenn Close'

--#6
/*
What is the id of the film 'Casablanca'
電影北非諜影'Casablanca' 的編號 id是什麼?
*/
SELECT id
FROM movie
WHERE title = 'Casablanca'

--#7
/*
Obtain the cast list for 'Casablanca'.

what is a cast list?
Use movieid=11768 this is the value that you obtained in the previous question.

列出電影北非諜影 'Casablanca'的演員名單。

什麼是演員名單?
演員名單,即是電影中各演員的真實姓名清單。

使用 movieid=11768, 這是你上一題得到的結果。
*/
SELECT name
FROM actor, casting
WHERE id=actorid AND movieid = (SELECT id FROM movie WHERE title = 'Casablanca')

--#8
/*
Obtain the cast list for the film 'Alien'
顯示電影異型'Alien' 的演員清單。
*/
SELECT name
FROM actor
  JOIN casting ON (id=actorid AND movieid = (SELECT id FROM movie WHERE title = 'Alien'))

--#9
/*
List the films in which 'Harrison Ford' has appeared
列出演員夏里遜福 'Harrison Ford' 曾演出的電影。
*/
SELECT title
FROM movie
  JOIN casting ON (id=movieid AND actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford'))

--#10
/*
List the films where 'Harrison Ford' has appeared - but not in the star role.
[Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
列出演員夏里遜福 'Harrison Ford' 曾演出的電影，但他不是第1主角。
*/
SELECT title
FROM movie
    JOIN casting ON (id=movieid AND actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford') AND ord != 1)

--#11
/*
List the films together with the leading star for all 1962 films.
列出1962年首影的電影及它的第1主角。
*/
SELECT title, name
FROM movie JOIN casting ON (id=movieid)
JOIN actor ON (actor.id = actorid)
WHERE ord=1 AND  yr = 1962

SELECT title,
       name
FROM movie a
JOIN
  (SELECT *
   FROM actor
   JOIN casting ON id=actorid
   WHERE ord=1) b ON b.movieid=a.id
WHERE yr=1962

--#12
/*
Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
尊·特拉華達'John Travolta'最忙是哪一年? 顯示年份和該年的電影數目。
*/
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
WHERE name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 WHERE name='John Travolta'
 GROUP BY yr) AS t)

--#13
/*
List the film title and the leading actor for all of the films 'Julie Andrews' played in.
列出演員茱莉·安德絲'Julie Andrews'曾參與的電影名稱及其第1主角。

是否列了電影 "Little Miss Marker"兩次?
她於1980再參與此電影Little Miss Marker. 原作於1934年,她也有參與。 電影名稱不是獨一的。在子查詢中使用電影編號。
*/
SELECT title, name FROM movie
JOIN casting x ON movie.id = movieid
JOIN actor ON actor.id =actorid
WHERE ord=1 AND movieid IN
(SELECT movieid FROM casting y
JOIN actor ON actor.id=actorid
WHERE name='Julie Andrews')

--#14
/*
Obtain a list in alphabetical order of actors who've had at least 30 starring roles.
列出按字母順序，列出哪一演員曾作30次第1主角。
*/
SELECT name
FROM actor
  JOIN casting ON (id = actorid AND (SELECT COUNT(ord) FROM casting WHERE actorid = actor.id AND ord=1)>=30)
GROUP BY name

SELECT name
FROM casting
JOIN actor ON casting.actorid=actor.id
WHERE casting.ord=1
GROUP BY name
HAVING count(*)>=30
ORDER BY name

--#15
/*
List the films released in the year 1978 ordered by the number of actors in the cast.
列出1978年首影的電影名稱及角色數目，按此數目由多至少排列。
*/
SELECT title, COUNT(actorid) as cast
FROM movie JOIN casting on id=movieid
WHERE yr = 1978
GROUP BY title
ORDER BY cast DESC

SELECT title,
       count(*) AS total
FROM movie
JOIN casting ON id=movieid
WHERE yr=1978
GROUP BY title
ORDER BY total DESC

--#16
/*
List all the people who have worked with 'Art Garfunkel'.
列出曾與演員亞特·葛芬柯'Art Garfunkel'合作過的演員姓名。
*/
SELECT DISTINCT name
FROM actor JOIN casting ON id=actorid
WHERE movieid IN (SELECT movieid FROM casting JOIN actor ON (actorid=id AND name='Art Garfunkel')) AND name != 'Art Garfunkel'
GROUP BY name
