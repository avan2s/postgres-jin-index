create extension if not exists pg_trgm;

CREATE TABLE
  t_hash AS
SELECT
  id,
  md5(id ::text)
FROM
  generate_series(1, 50000000) AS id;

SELECT
  count (id)
from
  t_hash;

DROP index
  idx_gin;

CREATE INDEX
  idx_gin ON t_hash USING gin (md5 gin_trgm_ops);

select
  pg_size_pretty(pg_total_relation_size('t_hash')) as table_size_t_hash,
  pg_size_pretty(pg_total_relation_size('idx_gin')) as index_size_idx_gin;

  select
  pg_size_pretty(pg_total_relation_size('t_payload')) as table_size_t_payload,
  pg_size_pretty(pg_total_relation_size('idx_gin_t_hash')) as table_size_t_hash,
  pg_size_pretty(pg_total_relation_size('idx_gin_t_payload')) as idx_gin_t_payload,
  pg_size_pretty(pg_total_relation_size('idx_tsvector_t_payload')) as idx_gin_t_payload;



SELECT id,to_tsvector('simple',p_content) from t_payload where p_content ilike '%foobau5%';
SELECT to_tsvector('english','hello this is foobar 2323413. Iam a king') @@ plainto_tsquery('2323413');
SELECT to_tsvector('simple','hello this is foobar 2323413. Iam a king') @@ plainto_tsquery('2323413');
SELECT to_tsvector('simple','<tag1>32451</tag1><tag2>foobars are cool<tag2>') @@ plainto_tsquery('325');

SELECT to_tsvector('german','Brotdose Lunch Box Kinder,1400ml Bento Box mit 3 FäChern,Auslaufsicher Vesperdose für Mikrowellen und Spülmaschinen,Brotdosen für Schule Arbeit Picknick Reisen (Rosa)') @@ to_tsquery('brote mit reis und beton');


select
  pg_size_pretty(pg_total_relation_size('idx_gin'));

SELECT
  *
from
  t_hash
where
  id = 42003123;

SELECT
  *
from
  t_hash
where
  md5 ilike '%80C6ee8%';


idx_tsvector_t_payload

SELECT
  id,
  md5(id ::text)
FROM
  generate_series(1, 50) AS id;

DROP table
  t_payload;

CREATE TABLE
  t_payload AS
SELECT
  id,
  words.w FROM generate_series(1, 50) AS id
  JOIN LATERAL (
    SELECT
      array_to_string(
        array(
          select
            substr(
              'a  bcde fgh ijklm nopqrs tuv wxyzA BC DEFG HIJKL MNOP QRSTUVW XYZ0123 456789',
              ((random() * (76 -1) + 1) ::integer),
              1
            )
          from
            generate_series(1, 500)
        ),
        ''
      ) WHERE id is not distinct from id
  ) as words(w) ON true

  
  
with
  symbols(characters) as (
    VALUES
      (
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
      )
  )
select
  string_agg(
    substr(
      characters,
      (random() * length(characters) + 1):: INTEGER,
      1
    ),
    ''
  )
from
  symbols
  join generate_series(1, 12) as word(chr_idx) on 1 = 1 -- word length
  join generate_series(1, 10) as words(idx) on 1 = 1 -- # of words
group by
  idx


  select
  pg_size_pretty(pg_total_relation_size('t_payload')) as table_size_t_hash;

CREATE INDEX
  idx_gin_t_payload ON t_payload USING gin (p_content gin_trgm_ops);
  
CREATE INDEX idx_tsvector_t_payload ON t_payload USING GIN (to_tsvector('english', p_content));

CREATE INDEX idx_tsvector_t_payload ON t_payload USING GIN (to_tsvector('simple', p_content));