# Custom Docker Image for PostgreSQL

A robust and production-ready Docker image for PostgreSQL, designed for easy integration,
data persistence, and secure configuration.
Perfect for development, testing, or production environments that require a reliable relational database.

## Features

- Based on the official PostgreSQL 17 image
- Pre-configured for production use with optimized settings
- Support for custom initialization scripts (.sql and .dump files)
- Timezone set to America/Sao_Paulo by default
- Simplified database creation and management
- Volume support for data persistence
- Customizable PostgreSQL configuration

## Usage

### Environment Variables

The following environment variables can be used to configure the PostgreSQL instance:

| Variable          | Description                            | Default               |
|-------------------|----------------------------------------|-----------------------|
| POSTGRES_DB       | Name of the default database to create | Same as POSTGRES_USER |
| POSTGRES_USER     | Username for the default user          | Required              |
| POSTGRES_PASSWORD | Password for the default user          | Required              |
| TZ                | Timezone for the container             | America/Sao_Paulo     |

### Volumes

The image supports the following volume mounts:

| Path                            | Description                                                          |
|---------------------------------|----------------------------------------------------------------------|
| /var/lib/postgresql/data        | PostgreSQL data directory for persistence                            |
| /var/log/postgresql             | PostgreSQL logs directory                                            |
| /scripts                        | Directory for initialization scripts                                 |
| /scripts/init-db                | Directory for database initialization scripts (.sql and .dump files) |
| /etc/postgresql/postgresql.conf | Custom PostgreSQL configuration file                                 |

### Initialization Scripts

The image supports two types of initialization scripts:

1. **Database Dumps (.dump files)**: Place your .dump files in the `/scripts/init-db/` directory.
   The filename should match the database name (e.g., `mydb.dump`).

2. **SQL Scripts (.sql files)**:
    - Place database initialization scripts in `/scripts/init-db/`.
      The filename should match the database name (e.g., `mydb.sql`).
    - Place post-initialization scripts in `/scripts/`. The filename should match the database name (e.g., `mydb.sql`).

## Docker Compose Example

```yaml
services:
  postgres:
    container_name: postgres
    image: 'api.repoflow.io/desiderati/docker/library/postgres:17'
    user: 1000:1000
    ports:
      - '5432:5432'
    command: postgres -c config_file=/etc/postgresql/postgresql.conf
    environment:
      - POSTGRES_DB=test
      - POSTGRES_USER=test
      - POSTGRES_PASSWORD=test
    volumes:
      # For the Postgres image to identify the user configured in the "user: xxxx:xxxx" parameter.
      - /etc/passwd:/etc/passwd:ro
      - ./data:/var/lib/postgresql/data
      - ./logs:/var/log/postgresql
      - ./scripts:/scripts

      # Uncomment the line below if you want to modify any PostgreSQL configuration parameter.
      # Use the file in the image at /etc/postgresql/postgresql.conf as a reference.
      #- ./postgresql.conf:/etc/postgresql/postgresql.conf
    networks:
      - postgres-net

networks:
  postgres-net:
    driver: bridge
```

## Running with Docker

```bash
docker run -d \
  --name postgres \
  -p 5432:5432 \
  -e POSTGRES_DB=mydb \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_PASSWORD=mypassword \
  -v $(pwd)/data:/var/lib/postgresql/data \
  -v $(pwd)/logs:/var/log/postgresql \
  -v $(pwd)/scripts:/scripts \
  api.repoflow.io/desiderati/docker/library/postgres:17
```

## Configuration

The image comes with a default PostgreSQL configuration file at `/etc/postgresql/postgresql.conf`.
You can override this configuration by mounting your own configuration file:

```bash
docker run -d \
  --name postgres \
  -p 5432:5432 \
  -e POSTGRES_DB=mydb \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_PASSWORD=mypassword \
  -v $(pwd)/postgresql.conf:/etc/postgresql/postgresql.conf \
  api.repoflow.io/desiderati/docker/library/postgres:17 \
  postgres -c config_file=/etc/postgresql/postgresql.conf
```

## Troubleshooting

### Connection Issues

If you're having trouble connecting to the PostgreSQL server:

1. Ensure the container is running: `docker ps`
2. Check the container logs: `docker logs postgres`
3. Verify that the port is correctly mapped: `docker port postgres`
4. Make sure your client is using the correct connection parameters
5. Verify that you have the appropriate permissions for the local directory to prevent the following error:
   `initdb: error: could not change permissions of directory "/var/lib/postgresql/data": Operation not permitted`

### Data Persistence

If your data is not persisting between container restarts:

1. Ensure you've mounted the data volume correctly
2. Check that the volume has the correct permissions
3. Verify that the PostgreSQL server is shutting down gracefully

## How to Build

1. Retrieve the login command to use to authenticate your Docker client to your registry:

   `docker login -u <USER> api.repoflow.io`

2. Build your Docker image using the following command. You can skip this step if your image is already built:

   `docker build --progress=plain -t postgres:17 .`

   > Ps.: Remember to disconnect any VPN from your local machine.

3. After the build completes, tag your image, so you can push the image to your repository:

   `docker tag postgres:17 api.repoflow.io/desiderati/docker/postgres:17`
   `docker tag postgres:17 api.repoflow.io/desiderati/docker/postgres:latest`

4. Run the following command to push this image to your repository:

   `docker push api.repoflow.io/desiderati/docker/postgres:17`
   `docker push api.repoflow.io/desiderati/docker/postgres:latest`

### Commands

   ```bash
   docker build --progress=plain -t postgres:17 .
   docker tag postgres:17 api.repoflow.io/desiderati/docker/postgres:17
   docker tag postgres:17 api.repoflow.io/desiderati/docker/postgres:latest
   docker push api.repoflow.io/desiderati/docker/postgres:17
   docker push api.repoflow.io/desiderati/docker/postgres:latest
   ```

## Author

Felipe Desiderati <felipedesiderati@springbloom.dev> (https://github.com/desiderati)

## [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
