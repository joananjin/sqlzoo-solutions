/*The nobel table can be used to practice more subquery*/ --#1

--#1
/*
紅十字國際委員會 (International Committee of the Red Cross) 曾多次獲得和平獎。 試找出與紅十字國際委員會同年得獎的文學獎(Literature)得獎者和年份。
*/

select winner , yr
from nobel where yr in
(select yr from nobel where winner='International Committee of the Red Cross')
and subject = 'Literature';


--#2
/*
日本物理學家益川敏英 (Toshihide Maskawa) 曾獲得物理獎。同年還有兩位日本人一同獲得物理獎。試列出這2位日本人的名稱。
*/
select winner from nobel
where yr in
(select yr from nobel where winner='Toshihide Maskawa' and subject='Physics')
and subject='Physics'
and winner != 'Toshihide Maskawa';

--#3
/*
首次頒發的經濟獎 (Economics)的得獎者是誰?
*/

select winner from nobel
where yr =
(select min(yr) from nobel where subject = 'Economics')
and subject = 'Economics';

--#4
/*
哪幾年頒發了物理獎，但沒有頒發化學獎?
*/
select  DISTINCT yr from nobel
where yr in (select yr from nobel where subject='Physics' )
and yr not in (select yr from nobel where subject='Chemistry');

--#5

/*
哪幾年的得獎者人數多於12人呢? 列出得獎人數多於12人的年份，獎項和得獎者。
*/

select yr,subject,winner from nobel
where yr in
(select yr from nobel
group by yr
having count(*)>12);

--#6
/*
哪些得獎者獲獎多於1次呢？他們是哪一年獲得哪項獎項呢？ 列出他們的名字，獲獎年份及獎項。先按名字，再按年份順序排序。
*/
select winner,yr,subject from nobel
where winner in
(select winner from nobel
group by winner
having count(*)>1)
order by winner,yr;
