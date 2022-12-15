\qecho 'Creating user...'

CREATE USER pedscreen WITH PASSWORD 'pedscreen';
-- TODO: make use of PEDSCREEN_PASSWORD environment variable, specified in .env file
-- CREATE USER pedscreen WITH PASSWORD '${PEDSCREEN_PASSWORD}';

\qecho 'Creating database...'
CREATE DATABASE pedscreen;
GRANT ALL ON DATABASE pedscreen TO pedscreen;

\connect pedscreen;

\qecho 'Creating schema...'
CREATE SCHEMA pedscreen;
GRANT USAGE ON SCHEMA pedscreen to pedscreen;
GRANT CREATE ON SCHEMA pedscreen to pedscreen;
