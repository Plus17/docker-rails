# Docker Rails
Docker image to develop with Ruby on Rails

Current versions:

**Ruby** 3.1.2

**Rails** 7.0.3

Dockerize your Rails project quickly with docker-compose using this image.

Example:

```yaml
version: "3.7"

services:
  rails:
    image: plus17/rails-dev-environment:3.1.2-7.0.3
    # {EXPOSE_TO:DOCKER_PORT}
    ports:
      - "3000:3000"
    volumes:
      - ./:/app/src
    depends_on:
      - postgres
    working_dir: /app/src

  postgres:
    image: postgres:12-alpine
    ports:
      - ${DATABASE_EXTERNAL_PORT:-5432}:5432
    volumes:
      - db-volume:/var/lib/postgresql/data/pgdata
    restart: always
    # In Postgres 12, there is no default value for the password.
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_USER: postgres
      PGDATA: /var/lib/postgresql/data/pgdata

volumes:
  db-volume:
```
