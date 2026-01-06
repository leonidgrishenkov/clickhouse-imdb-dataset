-- sqlfluff:dialect:clickhouse

CREATE DATABASE `imdb` on cluster '{cluster}';

/*
* Actors
*/
CREATE TABLE imdb.actors_local on cluster '{cluster}'
(
    id         UInt32,
    first_name String,
    last_name  String,
    gender     FixedString(1)
) ENGINE = ReplicatedMergeTree 
ORDER BY (id, first_name, last_name, gender)
;

create table imdb.actors on cluster '{cluster}'
as imdb.actors_local
engine = Distributed('{cluster}', 'imdb', 'actors_local', intHash64(id));

/*
* Directors
*/
CREATE TABLE imdb.directors_local on cluster '{cluster}'
(
    id         UInt32,
    first_name String,
    last_name  String
) ENGINE = ReplicatedMergeTree 
ORDER BY (id, first_name, last_name)
;

CREATE TABLE imdb.directors on cluster '{cluster}'
as imdb.directors_local
engine = Distributed('{cluster}', 'imdb', 'directors_local', intHash64(id));


/*
* Genres
*/
CREATE TABLE imdb.genres_local on cluster '{cluster}'
(
    movie_id UInt32,
    genre    String
) ENGINE = ReplicatedMergeTree 
ORDER BY (movie_id, genre)
;

CREATE TABLE imdb.genres on cluster '{cluster}'
as imdb.genres_local
engine = Distributed('{cluster}', 'imdb', 'genres_local', intHash64(movie_id));

/*
* Movie directors
*/
CREATE TABLE imdb.movie_directors_local on cluster '{cluster}'
(
    director_id UInt32,
    movie_id    UInt64
) ENGINE = ReplicatedMergeTree 
ORDER BY (director_id, movie_id)
;

CREATE TABLE imdb.movie_directors on cluster '{cluster}'
as imdb.movie_directors_local
engine = Distributed('{cluster}', 'imdb', 'movie_directors_local', intHash64(director_id));

/*
* Movies
*/
CREATE TABLE imdb.movies_local on cluster '{cluster}'
(
    id   UInt32,
    name String,
    year UInt32,
    rank Float32 DEFAULT 0
) ENGINE = ReplicatedMergeTree 
ORDER BY (id, name, year)
;

CREATE TABLE imdb.movies on cluster '{cluster}'
as imdb.movies_local
engine = Distributed('{cluster}', 'imdb', 'movies_local', intHash64(id));


/*
* Roles
*/
CREATE TABLE imdb.roles_local on cluster '{cluster}'
(
    actor_id   UInt32,
    movie_id   UInt32,
    role       String,
    created_at DateTime DEFAULT now()
) ENGINE = ReplicatedMergeTree 
ORDER BY (actor_id, movie_id)
;

CREATE TABLE imdb.roles on cluster '{cluster}'
as imdb.roles_local
engine = Distributed('{cluster}', 'imdb', 'roles_local', intHash64(actor_id));
