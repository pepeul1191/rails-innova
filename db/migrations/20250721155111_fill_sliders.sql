-- migrate:up

INSERT INTO sliders (id, title, subtitle, image_url, activity_url, created, updated) VALUES
(1, '¡Te damos la bienvenida a tu comunidad profesional!', 'Al hacer clic en «Continuar» para unirte o iniciar sesión, aceptas las Condiciones de uso, la Política de privacidad y la Política de cookies de LinkedIn.', 'uploads/sliders/default.webp', '1-como-ganar-amigos-e-influir-en-las-personas', NOW(), NOW()),
(2, 'Echa un vistazo a los artículos colaborativos', 'Queremos impulsar los conocimientos de la comunidad de una forma nueva. Los expertos añadirán información directamente a cada artículo, generado inicialmente con inteligencia artificial.', 'uploads/sliders/default.webp', '5-habitos-de-vida-saludable', NOW(), NOW()),
(3, '¿A quién se dirige LinkedIn?', 'A cualquier persona que quiera orientar su vida profesional.', 'uploads/sliders/default.webp', '16-como-mejorar-tu-marca-personal', NOW(), NOW());

-- migrate:down

TRUNCATE sliders;