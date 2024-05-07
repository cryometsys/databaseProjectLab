insert into anime values(‘Gintama’, ‘spring’, 2006, 201, ‘04/04/2006’, ‘some details’, ‘sunrise’, ‘finished’);

update user set username=’newName’
where email=’abcd(@)example(.)com’;

delete from user where email=’some email’

select anime_id, episodes_watched
from watchlist 
where user_id=(select user_id 
	from user 
	where username=’x’);

select count(*) from user;

select title, anime_id from anime where title like 'E%';

select title, anime_id
from anime a
where a.status = ‘finished’ union 
select title, anime_id 
from anime a where a.episode_count > 100;

select title, anime_id from anime a where anime_id in 
	(select anime_id from watchlist where username = 'x') intersect
	select title, anime_id from anime a where anime_id in 
		(select anime_id from watchlist where username = 'y');

select title, anime_id from anime a except
select title, anime_id from anime a 
inner join watchlist w ON a.anime_id = w.anime_id where w.username = 'x';

WITH genre_counts AS (
	Select g.genre_name, count(DISTINCT w.user_id) as total_watchers
	from genre g inner join
	anime_genre ag ON g.genre_id = ag.genre_id inner join
	anime a ON ag.anime_id = a.anime_id
	inner join watchlist w on a.anime_id = w.anime_id group by g.genre_name)
select genre_name, total_watchers from genre_counts order by total_watchers DESC limit 3;

select title, anime_id from anime a where airing_year = 2023 and airing_season = 'Fall' and
	(genre IN ('Action', 'Adventure'));

select username from user u where user_id not in
	(select user_id from watchlist w inner join
	anime_genre ag on w.anime_id = ag.anime_id inner join 
	genre g ON ag.genre_id = g.genre_id where g.genre_name = 'romance');

select title, initcap(lower(title)) AS standardized_title from anime;

select title, anime_id from anime where upper(title) like upper('%FULLMETA %ALCHEMIST%');

select title, studio, concat(title, ' (', studio, ')') as title_with_studio from anime;

select * from recommended_anime where username = 'x';

select a.title, a.anime_id 
from anime a inner join 
anime_genre ag ON a.anime_id = ag.anime_id inner join 
genre g ON ag.genre_id = g.genre_id 
where g.genre_name = ‘adventure’ group by a.title, a.anime_id;
