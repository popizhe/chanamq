DROP KEYSPACE chanamq;

CREATE KEYSPACE chanamq WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': '1'}  AND DURABLE_WRITES = true;

USE chanamq;

CREATE TABLE IF NOT EXISTS msgs (
  id bigint, -- msg id
  tstamp bigint,
  header blob, -- (channel -> dateCrawled)
  body blob,
  exchange text,
  routing text,
  durable boolean,
  refer int, -- refer count

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS queues (
  id text, -- queue id/name
  offset bigint,
  msgid bigint,
  size int, -- body size

  PRIMARY KEY (id, offset)
) WITH CLUSTERING ORDER BY (offset ASC);

CREATE TABLE IF NOT EXISTS queue_metas (
  id text, -- queue id/name
  lconsumed bigint, -- last consumed offset 
  consumers set<text>, -- consumers 
  durable boolean,
  ttl bigint, 

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS queue_unacks (
  id text, -- queue id/name
  offset bigint,
  msgid bigint,
  size int, -- body size

  PRIMARY KEY (id, msgid)
);

CREATE TABLE IF NOT EXISTS queues_deleted (
  id text, -- queue id/name
  offset bigint,
  msgid bigint,
  size int, -- body size

  PRIMARY KEY (id, offset)
) WITH CLUSTERING ORDER BY (offset ASC);

CREATE TABLE IF NOT EXISTS queue_metas_deleted (
  id text, -- queue id/name
  lconsumed bigint, -- last consumed offset 
  nconsumer int, -- consumer count
  durable boolean,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS queue_unacks_deleted (
  id text, -- queue id/name
  offset bigint,
  msgid bigint,
  size int, -- body size

  PRIMARY KEY (id, msgid)
);

CREATE TABLE IF NOT EXISTS exchanges (
  id text, -- exchange id/name
  tpe text,
  durable boolean,
  autodel boolean,
  internal boolean,
  args map<text, text>,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS binds (
  id text, -- exchange id/name
  queue text,
  key text, -- routing key
  args map<text, text>,

  PRIMARY KEY (id, queue, key)
);

CREATE TABLE IF NOT EXISTS vhosts (
  id text, -- exchange id/name
  active boolean,

  PRIMARY KEY (id)
);
