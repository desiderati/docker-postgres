# docker-postgres

A robust and production-ready Docker image for PostgreSQL, designed for easy integration, data persistence, and secure configuration. Perfect for development, testing, or production environments that require a reliable relational database.

## How to build

1. Retrieve the login command to use to authenticate your Docker client to your registry:

   `docker login -u <USER> api.repoflow.io`

2. Build your Docker image using the following command. You can skip this step if your image is already built:

   `docker build --progress=plain -t postgres:13.16 .`

   > Ps.: Remember to disconnect any VPM from your local machine.

3. After the build completes, tag your image, so you can push the image to your repository:

   `docker tag postgres:13.16 api.repoflow.io/desiderati/docker/postgres:13.16`
   `docker tag postgres:13.16 api.repoflow.io/desiderati/docker/postgres:latest`

4. Run the following command to push this image to your repository:

   `docker push api.repoflow.io/desiderati/docker/postgres:13.16`
   `docker push api.repoflow.io/desiderati/docker/postgres:latest`

### Example

   ```
   docker build --progress=plain -t postgres:13.16 .
   docker tag postgres:13.16 api.repoflow.io/desiderati/docker/postgres:13.16
   docker tag postgres:13.16 api.repoflow.io/desiderati/docker/postgres:latest
   docker push api.repoflow.io/desiderati/docker/postgres:13.16
   docker push api.repoflow.io/desiderati/docker/postgres:latest
   ```
