-- migrate:up

CREATE TABLE mentors_specialisms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mentor_id INT NOT NULL,
    specialism_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mentor_id) REFERENCES mentors(id),
    FOREIGN KEY (specialism_id) REFERENCES specialisms(id),
    UNIQUE (mentor_id, specialism_id)
);

-- migrate:down

DROP TABLE IF EXISTS mentor_specialisms;