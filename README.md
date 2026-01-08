This repo contains DDL and DML queries for IMDb dataset taken from
[Clickhouse DBT Integration Guide](https://clickhouse.com/docs/integrations/dbt/guides).

Database schema:

![schema](.github/images/schema.png)

Execute DDL and DML scripts:

```sh
docker cp ./clickhouse/ clickhouse-01:/tmp/

docker exec -it clickhouse-01 ch client --interactive --queries-file /tmp/clickhouse/sharded/imdb/ddl.sql /tmp/clickhouse/sharded/imdb/dml.sql

docker exec -it clickhouse-01 ch client --interactive --queries-file /tmp/clickhouse/sharded/imdb_large/ddl.sql /tmp/clickhouse/sharded/imdb_large/dml.sql
```

`imdb_large` database contains tables mentioned in
[this guide](https://clickhouse.com/blog/clickhouse-fully-supports-joins-hash-joins-part2).

# Queries

Execute the following query to compute a summary of each actor, ordered by the most movie appearances, and to confirm
the data was loaded successfully:

```sql
SELECT id,
       any(actor_name)          AS name,
       uniqExact(movie_id)    AS num_movies,
       avg(rank)                AS avg_rank,
       uniqExact(genre)         AS unique_genres,
       uniqExact(director_name) AS uniq_directors,
       max(created_at)          AS updated_at
FROM (
         SELECT imdb.actors.id  AS id,
                concat(imdb.actors.first_name, ' ', imdb.actors.last_name)  AS actor_name,
                imdb.movies.id AS movie_id,
                imdb.movies.rank AS rank,
                genre,
                concat(imdb.directors.first_name, ' ', imdb.directors.last_name) AS director_name,
                created_at
         FROM imdb.actors
                  GLOBAL JOIN imdb.roles ON imdb.roles.actor_id = imdb.actors.id
                  GLOBAL LEFT OUTER JOIN imdb.movies ON imdb.movies.id = imdb.roles.movie_id
                  GLOBAL LEFT OUTER JOIN imdb.genres ON imdb.genres.movie_id = imdb.movies.id
                  GLOBAL LEFT OUTER JOIN imdb.movie_directors ON imdb.movie_directors.movie_id = imdb.movies.id
                  GLOBAL LEFT OUTER JOIN imdb.directors ON imdb.directors.id = imdb.movie_directors.director_id
         )
GROUP BY id
ORDER BY num_movies DESC
LIMIT 5;
```
