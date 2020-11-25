# Archived Dockerfiles

I'm putting these files here for "safekeeping" for now and for quick reference if needed. I'm moving to an ARG-driven approach for building specific versions of Sonar Scanner which allows me to use a single Dockerfile and increment the version more easily.

# Build instructions

Here are the older vesrion of the Docker build instructions as well, for future reference.

These sections are here so Mitch can quickly run Docker commands without having to reconstruct them all the time. You don't have to worry about this stuff unless you really want to. But keeping them up to date is nice if you do PR's... :smile:

Run these commands to build Docker images:

```
docker build -t newtmitch/sonar-scanner:latest -f Dockerfile.sonarscanner-4.0.0-full . && \
docker tag newtmitch/sonar-scanner:latest newtmitch/sonar-scanner:4.0.0 && \
    docker tag newtmitch/sonar-scanner:latest newtmitch/sonar-scanner:4.0 && \
    docker tag newtmitch/sonar-scanner:latest newtmitch/sonar-scanner:4 && \

docker build -t newtmitch/sonar-scanner:4.0.0-alpine -f Dockerfile.sonarscanner-4.0.0-alpine . && \
docker tag newtmitch/sonar-scanner:4.0.0-alpine newtmitch/sonar-scanner:alpine && \
    docker tag newtmitch/sonar-scanner:4.0.0-alpine newtmitch/sonar-scanner:4.0-alpine && \
    docker tag newtmitch/sonar-scanner:4.0.0-alpine newtmitch/sonar-scanner:4-alpine && \

docker build -t newtmitch/sonar-scanner:3.3.0 -f Dockerfile.sonarscanner-3.3.0-full . && \
    docker tag newtmitch/sonar-scanner:3.3.0 newtmitch/sonar-scanner:3.3 && \
    docker tag newtmitch/sonar-scanner:3.3.0 newtmitch/sonar-scanner:3 && \

docker build -t newtmitch/sonar-scanner:3.3.0-alpine -f Dockerfile.sonarscanner-3.3.0-alpine . && \
    docker tag newtmitch/sonar-scanner:3.3.0-alpine newtmitch/sonar-scanner:3.3-alpine && \
    docker tag newtmitch/sonar-scanner:3.3.0-alpine newtmitch/sonar-scanner:3-alpine && \

docker build -t newtmitch/sonar-scanner:3.2.0 -f Dockerfile.sonarscanner-3.2.0-full . && \
docker tag newtmitch/sonar-scanner:3.2.0 newtmitch/sonar-scanner:3.2 && \

docker build -t newtmitch/sonar-scanner:3.2.0-alpine -f Dockerfile.sonarscanner-3.2.0-alpine . && \
docker tag newtmitch/sonar-scanner:3.2.0-alpine newtmitch/sonar-scanner:3.2-alpine && \

docker build -t newtmitch/sonar-scanner:3.0.3 -f Dockerfile.sonarscanner-3.0.3-full . && \
docker tag newtmitch/sonar-scanner:3.0.3 newtmitch/sonar-scanner:3.0 && \

docker build -t newtmitch/sonar-scanner:3.0.3-alpine -f Dockerfile.sonarscanner-3.0.3-alpine .
```

### Pushing Docker Images

```
docker push newtmitch/sonar-scanner:latest && \
docker push newtmitch/sonar-scanner:4.0.0 && \
docker push newtmitch/sonar-scanner:4.0 && \
docker push newtmitch/sonar-scanner:4 && \

docker push newtmitch/sonar-scanner:4.0.0-alpine && \
docker push newtmitch/sonar-scanner:4.0-alpine && \
docker push newtmitch/sonar-scanner:4-alpine && \
docker push newtmitch/sonar-scanner:alpine && \

docker push newtmitch/sonar-scanner:3.3.0 && \
docker push newtmitch/sonar-scanner:3.3 && \
docker push newtmitch/sonar-scanner:3 && \

docker push newtmitch/sonar-scanner:3.3.0-alpine && \
docker push newtmitch/sonar-scanner:3.3-alpine && \
docker push newtmitch/sonar-scanner:3-alpine && \

docker push newtmitch/sonar-scanner:3.2.0 && \
docker push newtmitch/sonar-scanner:3.2 && \

docker push newtmitch/sonar-scanner:3.2.0-alpine && \
docker push newtmitch/sonar-scanner:3.2-alpine && \

docker push newtmitch/sonar-scanner:3.0.3 && \
docker push newtmitch/sonar-scanner:3.0 && \

docker push newtmitch/sonar-scanner:3.0.3-alpine
```