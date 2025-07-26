-- migrate:up

ALTER TABLE mentors
ADD COLUMN google_id VARCHAR(30) AFTER code;

-- migrate:down

ALTER TABLE mentors
DROP COLUMN google_id;