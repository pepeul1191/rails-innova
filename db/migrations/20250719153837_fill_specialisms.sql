-- migrate:up

INSERT INTO specialisms (id, name, created, updated) VALUES
(1, 'Administración', NOW(), NOW()),
(2, 'Asesoría legal', NOW(), NOW()),
(3, 'Canales de distribución', NOW(), NOW()),
(4, 'Comportamiento del consumidor', NOW(), NOW()),
(5, 'Derecho comercial', NOW(), NOW()),
(6, 'Derecho laboral', NOW(), NOW()),
(7, 'Derecho tecnológico', NOW(), NOW()),
(8, 'E-commerce', NOW(), NOW()),
(9, 'Emprendimiento', NOW(), NOW()),
(10, 'Estrategia comercial', NOW(), NOW()),
(11, 'Estrategia y modelos de negocio', NOW(), NOW()),
(12, 'Evaluación de proyectos', NOW(), NOW()),
(13, 'Executive Branding', NOW(), NOW()),
(14, 'Flujo de caja y proyección', NOW(), NOW()),
(15, 'Gestión de marca', NOW(), NOW()),
(16, 'Gestión de proyectos', NOW(), NOW()),
(17, 'Marketing de servicios', NOW(), NOW()),
(18, 'Marketing digital', NOW(), NOW()),
(19, 'Marketing estratégico', NOW(), NOW()),
(20, 'Modelo predictivo', NOW(), NOW()),
(21, 'Narrativas transmedia y audiovisuales', NOW(), NOW()),
(22, 'Operaciones/logística', NOW(), NOW()),
(23, 'Planeamiento comercial y marketing', NOW(), NOW()),
(24, 'Planeamiento estratégico y financiero', NOW(), NOW()),
(25, 'Producción y realización publicitaria', NOW(), NOW()),
(26, 'Prototipado de apps y websites', NOW(), NOW()),
(27, 'Propiedad intelectual', NOW(), NOW()),
(28, 'Protección de datos personales', NOW(), NOW()),
(29, 'Sostenibilidad e impacto', NOW(), NOW()),
(30, 'Storytelling', NOW(), NOW()),
(31, 'Técnicas audiovisuales', NOW(), NOW()),
(32, 'Transformación digital', NOW(), NOW()),
(33, 'Valorización de startups e innovación', NOW(), NOW()),
(34, 'Ventas B2B/B2C, adquisición de clientes', NOW(), NOW());

-- migrate:down

TRUNCATE specialisms;