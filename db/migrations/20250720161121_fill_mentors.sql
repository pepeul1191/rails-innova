-- migrate:up

INSERT INTO mentors (id, code, full_name, charge, email, image_url, linkedln_url) VALUES (1, '349281', 'Jhonatan Wong Velásquez', 'Mentor en Innovación Abierta', 'jhonatan.wong@ulima.edu.pe', 'uploads/mentors/default.png ', 'https://pe.linkedin.com/in/jhonatanwong ');
INSERT INTO mentors (id, code, full_name, charge, email, image_url, linkedln_url) VALUES (2, '762348', 'Eduardo López de Sá', 'Mentor en Emprendimiento', 'eduardo.lopez@ulima.edu.pe', 'uploads/mentors/default.png ', 'https://pe.linkedin.com/in/eduardolopezs ');
INSERT INTO mentors (id, code, full_name, charge, email, image_url, linkedln_url) VALUES (3, '128374', 'María del Carmen Martínez', 'Mentor en Gestión de Proyectos', 'maria.martinez@ulima.edu.pe', 'uploads/mentors/default.png ', 'https://pe.linkedin.com/in/mariacarmenmartinez ');
INSERT INTO mentors (id, code, full_name, charge, email, image_url, linkedln_url) VALUES (4, '932187', 'Carlos Arturo Rojas', 'Mentor en Tecnología y Desarrollo', 'carlos.rojas@ulima.edu.pe', 'uploads/mentors/default.png ', 'https://pe.linkedin.com/in/carlosarturorojas ');
INSERT INTO mentors (id, code, full_name, charge, email, image_url, linkedln_url) VALUES (5, '561234', 'Patricia Zeña Villarreal', 'Mentor en Marketing Digital', 'patricia.zena@ulima.edu.pe', 'uploads/mentors/default.png ', 'https://pe.linkedin.com/in/patriciavillarreal ');
INSERT INTO mentors (id, code, full_name, charge, email, image_url, linkedln_url) VALUES (6, '234871', 'Jorge Luis Chávez', 'Mentor en Innovación Tecnológica', 'jorge.chavez@ulima.edu.pe', 'uploads/mentors/default.png ', 'https://pe.linkedin.com/in/jorgeluischavez ');
INSERT INTO mentors (id, code, full_name, charge, email, image_url, linkedln_url) VALUES (7, '872345', 'Miguel Ángel Ríos', 'Mentor en Estrategia Empresarial', 'miguel.rios@ulima.edu.pe', 'uploads/mentors/default.png ', 'https://pe.linkedin.com/in/miguelangelrios ');
INSERT INTO mentors (id, code, full_name, charge, email, image_url, linkedln_url) VALUES (8, '651238', 'Claudia Patricia Sánchez', 'Mentor en Gestión del Cambio', 'claudia.sanchez@ulima.edu.pe', 'uploads/mentors/default.png ', 'https://pe.linkedin.com/in/claudiapatriciasanchez ');
INSERT INTO mentors (id, code, full_name, charge, email, image_url, linkedln_url) VALUES (9, '451239', 'Ricardo Andrés Vargas', 'Mentor en Innovación Educativa', 'ricardo.vargas@ulima.edu.pe', 'uploads/mentors/default.png ', 'https://pe.linkedin.com/in/ricardoandresvargas ');
INSERT INTO mentors (id, code, full_name, charge, email, image_url, linkedln_url) VALUES (10, '102938', 'Mireya del Pilar Valverde', 'Mentor en Comunicación Estratégica', 'mireya.valverde@ulima.edu.pe', 'uploads/mentors/default.png ', 'https://pe.linkedin.com/in/mireyadelpilarvalverde ');

-- migrate:down

TRUNCATE mentors;