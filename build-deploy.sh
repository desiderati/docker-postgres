docker build --progress=plain -t postgres:17 .
docker tag postgres:17 api.repoflow.io/desiderati/docker/postgres:17
docker tag postgres:17 api.repoflow.io/desiderati/docker/postgres:latest
docker tag postgres:17 api.repoflow.io/desiderati/docker/postgres:17
docker tag postgres:17 api.repoflow.io/desiderati/docker/postgres:latest
docker push api.repoflow.io/desiderati/docker/postgres:17
docker push api.repoflow.io/desiderati/docker/postgres:latest
