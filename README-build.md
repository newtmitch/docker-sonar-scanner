I'm keeping these commands for future reference as I need to build new images. Ignore me.

```bash
# build all 4.x alpine images
docker build -t newtmitch/sonar-scanner-alpine:4.0-ci -f Dockerfile --build-arg SCANNER_VERSION=4.0.0.1744 . && \
docker tag newtmitch/sonar-scanner-alpine:4.0-ci newtmitch/sonar-scanner:4.0-ci && \

docker build -t newtmitch/sonar-scanner-alpine:4.1 -f Dockerfile --build-arg SCANNER_VERSION=4.1.0.1829 . && \
docker tag newtmitch/sonar-scanner-alpine:4.1 newtmitch/sonar-scanner:4.1 && \

docker build -t newtmitch/sonar-scanner-alpine:4.2 -f Dockerfile --build-arg SCANNER_VERSION=4.2.0.1873 . && \
docker tag newtmitch/sonar-scanner-alpine:4.2 newtmitch/sonar-scanner:4.2 && \

docker build -t newtmitch/sonar-scanner-alpine:4.3 -f Dockerfile --build-arg SCANNER_VERSION=4.3.0.2102 . && \
docker tag newtmitch/sonar-scanner-alpine:4.3 newtmitch/sonar-scanner:4.3 && \

docker build -t newtmitch/sonar-scanner-alpine:4.4 -f Dockerfile --build-arg SCANNER_VERSION=4.4.0.2170 . && \
docker tag newtmitch/sonar-scanner-alpine:4.4 newtmitch/sonar-scanner:4.4 && \

docker build -t newtmitch/sonar-scanner-alpine:4.5 -f Dockerfile --build-arg SCANNER_VERSION=4.5.0.2216 . && \
docker tag newtmitch/sonar-scanner-alpine:4.5 newtmitch/sonar-scanner-alpine:latest && \
docker tag newtmitch/sonar-scanner-alpine:4.5 newtmitch/sonar-scanner:latest
docker tag newtmitch/sonar-scanner-alpine:4.5 newtmitch/sonar-scanner:4.5
docker tag newtmitch/sonar-scanner-alpine:4.5 newtmitch/sonar-scanner:4
docker tag newtmitch/sonar-scanner-alpine:4.5 newtmitch/sonar-scanner-alpine:4

# Push images
docker push newtmitch/sonar-scanner-alpine:4.0-ci && \
docker push newtmitch/sonar-scanner:4.0-ci && \

docker push newtmitch/sonar-scanner-alpine:4.1 && \
docker push newtmitch/sonar-scanner:4.1 && \

docker push newtmitch/sonar-scanner-alpine:4.2 && \
docker push newtmitch/sonar-scanner:4.2 && \

docker push newtmitch/sonar-scanner-alpine:4.3 && \
docker push newtmitch/sonar-scanner:4.3 && \

docker push newtmitch/sonar-scanner-alpine:4.4 && \
docker push newtmitch/sonar-scanner:4.4 && \

docker push newtmitch/sonar-scanner-alpine:4.5 && \
docker push newtmitch/sonar-scanner:4.5 && \
docker push newtmitch/sonar-scanner:latest && \
docker push newtmitch/sonar-scanner-alpine:latest && \
docker push newtmitch/sonar-scanner:4 && \
docker push newtmitch/sonar-scanner-alpine:4

# Test run commands
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
docker run -ti -v $PWD:/usr/src --link sonarqube newtmitch/sonar-scanner-alpine:4.5
```
