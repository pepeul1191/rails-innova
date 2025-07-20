# Gestión de Ticktes - Ruby/MongoDB

- [Documentación](#documentación)

Ejecución del servidor:

    $ gem install bundler
    $ bundler install
    $ npm install
    $ npm run dev

Crear backup de la base de datos MongoDB:

    $ sudo mongodump --db tickets --out db/

Restaurar backup de la base de datos MongoDB:

    $ sudo mongorestore --db tickets db/tickets

### Variables de entorno

    GOOGLE_CLIENT_ID=XYZ
    GOOGLE_CLIENT_SECRET=XYZ
    DB=mysql://root:password@127.0.0.1:3306/mydatabase

### Migraciones con DBMATE

Crear migración:

    $ npm run db:new <nombre-migración>

Ejecutar

    $ npm run db:up

Deshacer

    $ npm run db:rollback

### Imágenes de PlantUML

Generar UMLs:

    $ chmod +x scripts/render_all_puml.sh
    $ scripts/render_all_puml.sh

---

## Documentación

Diagrama de clases

![Diagrama UML](./docs/pics/class_diagram.png)