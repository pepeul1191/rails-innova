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

    # database
    DB=mysql://root:123@127.0.0.1:3306/innova
    # oauth service
    GOOGLE_CLIENT_ID=XYZ
    GOOGLE_CLIENT_SECRET=XYZ
    # file service
    X_AUTH_FILES_SERVICE=dXNlci1zdGlja3lfc2VjcmV0XzEyMzQ1Njc
    URL_FILES_SERVICE=http://localhost:8090/
    # access service
    X_AUTH_ACCESS_SERVICE=dXNlci1zdGlja3lfc2VjcmV0XzEyMzQ1Njc
    URL_ACCESS_SERVICE=http://localhost:8080/

### Migraciones con DBMATE

Crear migración:

    $ npm run db:new <nombre-migración>

Ejecutar

    $ npm run db:up

Deshacer

    $ npm run db:rollback

### Imágenes de PlantUML

Generar UMLs:

    $ chmod +x scripts/render_puml.sh
    $ scripts/render_puml.sh

---

## Documentación

Diagrama de clases

![Diagrama UML](./docs/pics/class_diagram.png)