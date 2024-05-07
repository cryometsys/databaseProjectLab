create table anime(
anime_id number primary key AUTO_INCREMENT,
title varchar2(100) not null,
airing_season varchar2(20),
airing_year number,
episode_count number,
airing_date DATE,
synopsis TEXT,
studio varchar2(50), 
status varchar2(10),
CONSTRAINT check_episode_count 
	CHECK (episode_count >= 0) ); 

create table anime_genre (
anime_id INT,
genre_id INT,
foreign key(anime_id) references anime(anime_id), 
foreign key(genre_id) references genre(genre_id),
PRIMARY KEY (anime_id, genre_id) );

create table genre (
genre_id number primary key AUTO_INCREMENT,
genre_name varchar2(50) NOT NULL
); 

create table user (
user_id INT primary key AUTO_INCREMENT, 
username varchar2(50) NOT NULL UNIQUE, 
password varchar2(255) NOT NULL, 
email varchar2(100) NOT NULL UNIQUE
);

alter table genre add genre_name varchar2(30);

alter table genre modify genre_name varchar2(255);

alter table genre rename column genre_name to genre_name2;

alter table genre drop column genre_name2;

delete from user where email=’some email’

