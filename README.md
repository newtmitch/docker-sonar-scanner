# docker-sonar-scanner Overview

A quick [Sonar](http://www.sonarqube.org/) scanner (command line) container.

https://hub.docker.com/r/newtmitch/sonar-scanner/

This Dockerfile sets up the command line scanner vs. any other existing analysis
method. For other analysis methods, see the bottom of this page:

http://docs.sonarqube.org/display/SONAR/Analyzing+Source+Code

For details on running the command line scanner:

http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner

and for a list of command-line options: http://docs.sonarqube.org/display/SONAR/Analysis+Parameters

**NOTE:** I usually only test the latest version of the scanner, even though I might update the
older Dockerfiles here and there. So YMMV. Let me know if there are issues, though.

# Quick Reference - tl;dr version

Using the official Sonar Qube Docker image:

```
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
docker run -ti -v $(pwd):/root/src --link sonarqube newtmitch/sonar-scanner
```

Run this from the root of your source code directory, it'll scan everything below it.

This uses the latest Qube image - if you want LTS, use image name `sonarqube:lts`.

Run the alpine version:

```
docker run -ti -v $(pwd):/root/src --link sonarqube newtmitch/sonar-scanner:alpine
```

# Change Notes

## 2018_08_03
* Removed the 2.5.1 sonar scanner images, as the downloads for that version are no longer available.
* Normalized the name of the unzipped sonar scanner directory to `sonar-scanner`
so specific version numbers weren't included in the directory name. This allows for easier config
replacement at runtime and (hopefully) reduces unnecessary complexity / specificity.
* Added a new tag for the latest version of Sonar Scanner with the alpine base image: 
`newtmitch/sonar-scanner:alpine`
* Added some more instructions for running the sonar scanner and replacing the image-internal
sonar-runner.properties with the external version at runtime (via normalizing the sonar scanner
directory name).
* Added instructions for myself later so I can more quickly run the build / update commands

# Running - Long Version

To run the scanner you must have a Sonar Qube running. If you don't already have a Qube instance running somewhere, you can start one via Docker using the official Docker image or the variant I have below.


## Run Sonar Qube Server

If you prefer to use an official Sonar Qube image, run the following command. Note that if you need a particular version of Sonar Qube, you need to use something like `sonarqube:5.2` instead of what's shown below.

    docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube

If you prefer a server build that automatically sets the timezone when you start it you can use the custom image variant I have here per the command below. If you omit the TZ parameter, it'll default to CST.

    docker run -d --name sonarqube -e "TZ=America/Chicago" -p 9000:9000 -p 9092:9092 newtmitch/sonar-server


## Run Sonar Scanner

After your server is running, run the following command from the command line to start the scanner. This uses the default settings in the sonar-runner.properties file, which you can overload with -D commands (see below).

    docker run -ti -v $(pwd):/root/src --link sonarqube newtmitch/sonar-scanner 

Replace "$(pwd)" with the absolute path of the top-level source directly you're
interested in if you're not running the docker image from the top level project
directory. It will scan everything under that directory when it starts up.

The supplied sonar-runner.properties file points to http://192.168.99.100 as the
Qube server. If you need to change that or any other of the variables that Scanner needs to run, you can pass them in with the command itself to override them:

    docker run -ti -v $(pwd):/root/src --link sonarqube newtmitch/sonar-scanner sonar-scanner sonar.host.url=YOURURL -Dsonar.projectBaseDir=./src

or if you're running the `newtmitch/sonar-scanner:2.5.1` image, because the script name changed between 2.5.1 and 3.0.3 at some point:

    docker run -ti -v $(pwd):/root/src --link sonarqube newtmitch/sonar-scanner sonar-runner sonar.host.url=YOURURL -Dsonar.projectBaseDir=./src

Here's a fully-loaded command line (based on latest/3.0.3 version) that basically overrides everything from the sonar-runner.properties file on the command-line itself. The settings shown here match those in the sonar-runner.properties file.

```
docker run -ti -v $(pwd):/root/src --link sonarqube newtmitch/sonar-scanner sonar-scanner \
  -Dsonar.host.url=http://sonarqube:9000 \
  -Dsonar.jdbc.url=jdbc:h2:tcp://sonarqube/sonar \
  -Dsonar.projectKey=MyProjectKey \
  -Dsonar.projectName="My Project Name" \
  -Dsonar.projectVersion=1 \
  -Dsonar.projectBaseDir=/root \
  -Dsonar.sources=./src
```

Or just have your local sonar-runner.properties override the default version built into the
scanner image. Note that you'll likely have to modify your paths to pick up the properties
file, source directories, or copy the sonar-runner.properties file into your actual source
code project in order to have it be called with this command as-written below.

```
docker run -ti \
  -v $(pwd):/root/src \
  -v $(pwd)/sonar-runner.properties:/root/sonar-scanner/conf/sonar-scanner.properties \
  --link sonarqube newtmitch/sonar-scanner sonar-scanner
```

## Typescript

As of Aug 3, 2018, I installed Node as part of the scanner image so it can properly scan JS and TS
files as-needed. I suggest you add an exclusion as part of either sonar-runner.properties:

```
sonar.exclusions=**/node_modules/**/*
```

or via the command line:

```
docker run -ti -v $(pwd):/root/src --link sonarqube newtmitch/sonar-scanner sonar-scanner \         
  -Dsonar.exclusions=**/node_modules/**/*
```

I've added this to the deafult sonar-runner.properties file, so remove that if you don't want it
there for some reason.

# Build

## Sonar Scanner 

To build this scanner image, just issue a standard Docker build command - make sure to specify the Dockerfile that you're building:

    docker build -t newtmitch/sonar-scanner:latest -f Dockerfile.sonarscanner-3.2.0-full .

## Sonar Qube Server

To build the customized Sonar Qube server, run the following command. See the [Server image](#server-image) section below for details on this image build.

    docker build -t my-sonar-server -f Dockerfile.server .

## Publishing Docker Updates

This section is here so Mitch doesn't have to figure this out every time he updates these images
and wants to push them to the repo... :smile:

```
#
# 3.2.0
#
docker build -t newtmitch/sonar-scanner:latest -f Dockerfile.sonarscanner-3.2.0-full .

docker tag newtmitch/sonar-scanner:latest newtmitch/sonar-scanner:3.2.0 && \
    docker tag newtmitch/sonar-scanner:latest newtmitch/sonar-scanner:3.2 && \
    docker tag newtmitch/sonar-scanner:latest newtmitch/sonar-scanner:3

docker push newtmitch/sonar-scanner:latest && \
docker push newtmitch/sonar-scanner:3.2.0 && \
docker push newtmitch/sonar-scanner:3.2 && \
docker push newtmitch/sonar-scanner:3

#
# 3.2.0 Alpine
#
docker build -t newtmitch/sonar-scanner:3.2.0-alpine -f Dockerfile.sonarscanner-3.2.0-alpine .

docker tag newtmitch/sonar-scanner:3.2.0-alpine newtmitch/sonar-scanner:alpine && \
    docker tag newtmitch/sonar-scanner:3.2.0-alpine newtmitch/sonar-scanner:3.2-alpine && \
    docker tag newtmitch/sonar-scanner:3.2.0-alpine newtmitch/sonar-scanner:3-alpine

docker push newtmitch/sonar-scanner:3.2.0-alpine && \
docker push newtmitch/sonar-scanner:3.2-alpine && \
docker push newtmitch/sonar-scanner:3-alpine && \
docker push newtmitch/sonar-scanner:alpine

#
# 3.0.3
#
docker build -t newtmitch/sonar-scanner:3.0.3 -f Dockerfile.sonarscanner-3.0.3-full .

docker tag newtmitch/sonar-scanner:3.0.3 newtmitch/sonar-scanner:3.0

docker push newtmitch/sonar-scanner:3.0.3 && \
docker push newtmitch/sonar-scanner:3.0

#
# 3.0.3 Alpine
#
docker build -t newtmitch/sonar-scanner:3.0.3-alpine -f Dockerfile.sonarscanner-3.0.3-alpine .

docker push newtmitch/sonar-scanner:3.0.3-alpine
```

# Server image

I've also included Dockerfile.server, which uses the sonarqube:latest image as a 
basis and basically puts in the mechanism to update the server time to a user-defined
time zone vs. the default (correct time reporting for analyzer runs).

You can modify the Dockerfile to update the timezone, or just pass in the environment variable on-demand (assumes you build it with tag `mitch/sonarqube`). If you omit the TZ setting it'll default to CST.

    docker run -d --name sonarqube -e "TZ=America/Chicago" -p 9000:9000 -p 9092:9092 newtmitch/sonar-server
