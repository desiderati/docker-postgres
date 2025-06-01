docker build --progress=plain -t postgres:13.16 .
docker tag postgres:13.16 api.repoflow.io/desiderati/docker/postgres:13.16
docker tag postgres:13.16 api.repoflow.io/desiderati/docker/postgres:latest
docker tag postgres:13.16 api.repoflow.io/desiderati/docker/postgres:13.16
docker tag postgres:13.16 api.repoflow.io/desiderati/docker/postgres:latest
docker push api.repoflow.io/desiderati/docker/postgres:13.16
docker push api.repoflow.io/desiderati/docker/postgres:latest
