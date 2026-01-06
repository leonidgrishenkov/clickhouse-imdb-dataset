CREATE DATABASE imdb_large ON CLUSTER '{cluster}';

CREATE TABLE imdb_large.actors_local ON CLUSTER '{cluster}'
(
    id         UInt32,
    first_name String,
    last_name  String,
    gender     FixedString(1)
) ENGINE = ReplicatedMergeTree
ORDER BY (id, first_name, last_name, gender);

CREATE TABLE imdb_large.actors ON CLUSTER '{cluster}'
AS imdb_large.actors_local
ENGINE = Distributed('{cluster}', 'imdb_large', 'actors_local', rand());


CREATE TABLE imdb_large.roles_local ON CLUSTER '{cluster}'
(
    created_at DateTime DEFAULT now(),
    actor_id   UInt32,
    movie_id   UInt32,
    role       String
) ENGINE = ReplicatedMergeTree
ORDER BY (actor_id, movie_id);

CREATE TABLE imdb_large.roles ON CLUSTER '{cluster}'
AS imdb_large.roles_local
ENGINE = Distributed('{cluster}', 'imdb_large', 'roles_local', rand());
