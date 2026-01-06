INSERT INTO imdb_large.actors WITH
    (
        SELECT groupArrayDistinct(first_name)
        FROM imdb.actors
    ) AS first_names,
    (
        SELECT groupArrayDistinct(last_name)
        FROM imdb.actors
    ) AS last_names,
    (
        SELECT groupArrayDistinct(gender)
        FROM imdb.actors
    ) AS genders
SELECT
    number AS id,
    first_names[toInt32(floor(randUniform(1, length(first_names))))] AS first_name,
    last_names[toInt32(floor(randUniform(1, length(last_names))))] AS last_name,
    genders[toInt8(floor(randUniform(1, length(genders) + 1)))] AS gender
FROM numbers(1_000_000);


INSERT INTO imdb_large.roles(actor_id, movie_id, role)
WITH
    (
        SELECT groupArrayDistinct(1_000_000)(role)
        FROM imdb.roles
    ) AS roles,
    (
        SELECT groupArrayDistinct(movie_id)
        FROM imdb.genres
    ) AS movies
SELECT
    (rand() mod 1_000_000) AS actor_id,
    movies[toInt32(floor(randUniform(1, length(movies))))] AS movie_id,
    roles[toInt32(floor(randUniform(1, length(roles))))] AS role
FROM numbers(100_000_000);

