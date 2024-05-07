CREATE OR REPLACE PROCEDURE insert_user(
	p_username in varchar2(50), 
	p_email in varchar22(100)
)IS BEGIN
insert into user(username, email) values (p_username, p_email) default (user_role) for user_role;
END;
/

DECLARE l_cursor SYS_REFCURSOR;
l_row_count number;
BEGIN
	OPEN l_cursor for select * from anime;   
	LOOP 
		fetch l_cursor into l_record;
		EXIT when l_cursor%NOTFOUND;
	l_row_count := l_row_count + 1;
	END LOOP; 
	CLOSE l_cursor;
	DBMS_OUTPUT.PUT_LINE('Total Anime: ' || l_row_count);
END;
/

CREATE OR REPLACE FUNCTION format_title(
	p_title varchar2(200)
) RETURN varchar2(200) IS BEGIN
RETURN UPPER(p_title);
END;
/

CREATE OR REPLACE PROCEDURE update_user_email (
	p_username IN VARCHAR2(50),
	p_new_email IN VARCHAR2(100)
)
CREATE OR REPLACE PROCEDURE update_episode_status (
	p_anime_id number,
	p_episode_number number, 
	p_new_status varchar2(20)
) IS l_current_status varchar2(20);
BEGIN
	select episode_status into l_current_status from anime_episodes where
	anime_id = p_anime_id and episode_number = p_episode_number;
	IF l_current_status = 'Airing' 
	THEN
		Update anime_episodes set episode_status = p_new_status where anime_id = p_anime_id and episode_number = p_episode_number;
		DBMS_OUTPUT.PUT_LINE('Episode status updated to: ' || p_new_status);
	ELSE
		DBMS_OUTPUT.PUT_LINE('Episode status is already: ' || l_current_status);
	END IF;
END;
/

CREATE OR REPLACE PROCEDURE update_genre_names(
	p_old_name VARCHAR2(50),
	p_new_name VARCHAR2(50)
) IS l_genre_id NUMBER;
l_genre_list VARCHAR2(2000) := 'Genres updated: ';
BEGIN
	FOR rec IN (SELECT genre_id FROM genre WHERE genre_name = p_old_name)
	LOOP
		l_genre_id := rec.genre_id;
		UPDATE genre SET genre_name = p_new_name WHERE genre_id = l_genre_id; 
		l_genre_list := l_genre_list || l_genre_id || ', ';   
	END LOOP;
	l_genre_list := SUBSTR(l_genre_list, 1, LENGTH(l_genre_list) - 2);
	DBMS_OUTPUT.PUT_LINE(l_genre_list);
END;
/

CREATE OR REPLACE TRIGGER update_watchlist_completion
BEFORE UPDATE ON watchlist
FOR EACH ROW
DECLARE
  l_total_episodes NUMBER;
  l_watched_episodes NUMBER := 0;
BEGIN
  IF :NEW.completed = TRUE THEN
    SELECT COUNT(*) AS total_episodes
    INTO l_total_episodes
    FROM anime_episodes
    WHERE anime_id = :OLD.anime_id;
    SELECT COUNT(*) AS watched_episodes
    FROM user_watched_episodes
    WHERE user_id = :OLD.user_id
    AND anime_id = :OLD.anime_id;
    l_watched_episodes := l_watched_episodes;
    IF l_watched_episodes < l_total_episodes THEN
      RAISE APPLICATION_ERROR(-20001, 'All episodes must be watched to mark complete');
    END IF;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER update_anime_rating
AFTER UPDATE ON user_ratings
FOR EACH ROW
DECLARE
  l_anime_id NUMBER := :OLD.anime_id;
  l_avg_rating NUMBER;
BEGIN
  SELECT AVG(rating) AS avg_rating
  INTO l_avg_rating
  FROM user_ratings
  WHERE anime_id = l_anime_id;
  UPDATE anime
  SET average_rating = l_avg_rating
  WHERE anime_id = l_anime_id;
END;
/
