-- migrate:up

INSERT IGNORE INTO mentors_specialisms (mentor_id, specialism_id) VALUES
-- Mentor 1: 5 especialidades
(1, 3), (1, 8), (1, 15), (1, 22), (1, 30),
-- Mentor 2: 7 especialidades
(2, 1), (2, 5), (2, 9), (2, 14), (2, 19), (2, 25), (2, 33),
-- Mentor 3: 4 especialidades
(3, 2), (3, 11), (3, 17), (3, 28),
-- Mentor 4: 6 especialidades
(4, 4), (4, 7), (4, 12), (4, 20), (4, 26), (4, 31),
-- Mentor 5: 5 especialidades
(5, 6), (5, 10), (5, 18), (5, 24), (5, 34),
-- Mentor 6: 7 especialidades
(6, 3), (6, 9), (6, 13), (6, 21), (6, 27), (6, 29), (6, 32),
-- Mentor 7: 4 especialidades
(7, 1), (7, 16), (7, 23), (7, 30),
-- Mentor 8: 6 especialidades
(8, 5), (8, 11), (8, 19), (8, 25), (8, 28), (8, 33),
-- Mentor 9: 5 especialidades
(9, 2), (9, 7), (9, 14), (9, 20), (9, 26),
-- Mentor 10: 7 especialidades
(10, 4), (10, 8), (10, 12), (10, 18), (10, 24), (10, 27), (10, 31);

-- migrate:down

TRUNCATE mentors_specialisms;