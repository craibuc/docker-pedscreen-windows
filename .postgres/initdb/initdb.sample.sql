\qecho 'Creating user...'

CREATE USER pedscreen WITH PASSWORD 'pedscreen';

\qecho 'Creating database...'
CREATE DATABASE pedscreen;
GRANT ALL ON DATABASE pedscreen TO pedscreen;

\connect pedscreen;

\qecho 'Creating schema...'
CREATE SCHEMA pedscreen;
GRANT USAGE ON SCHEMA pedscreen to pedscreen;
GRANT CREATE ON SCHEMA pedscreen to pedscreen;
