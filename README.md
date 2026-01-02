This repo contains DDL and DML queries for IMDb dataset taken from [Clickhouse DBT Integration Guide](https://clickhouse.com/docs/integrations/dbt/guides)
Database schema:

![schema](.github/images/schema.png)

Execute DDL and DML scripts:

```sh
docker cp ./clickhouse/ clickhouse-01:/tmp/ \
    && docker exec -it clickhouse-01 ch client --interactive --queries-file /tmp/clickhouse/sharded/ddl.sql /tmp/clickhouse/common/dml.sql
```

