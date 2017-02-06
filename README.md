# docker-sonar-scanner Overview

A quick [Sonar](http://www.sonarqube.org/) scanner (command line) container.

https://hub.docker.com/r/newtmitch/sonar-scanner/

This Dockerfile sets up the command line scanner vs. any other existing analysis
method. For other analysis methods, see the bottom of this page:

http://docs.sonarqube.org/display/SONAR/Analyzing+Source+Code

For details on running the command line scanner:

http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner

and for a list of command-line options: http://docs.sonarqube.org/display/SONAR/Analysis+Parameters

# Prerequisites

You must have a Sonar Qube server running. I used the Docker image available here:

https://hub.docker.com/_/sonarqube/

# Usage

Make sure you have a Sonar Qube server running. You can use the official build here:

    docker run -d --name sonarqube -e "TZ=America/Chicago" -p 9000:9000 -p 9092:9092 sonarqube

or use my slightly modified version with a command to update the server time to a specified
time zone (set to CST by default - if that's yours just omit the -e parameter):

    docker run -d --name sonarqube -e "TZ=America/Chicago" -p 9000:9000 -p 9092:9092 sonarqube

Just run the following command from the command line.

    docker run -ti -v $(pwd):/root/src newtmitch/sonar-scanner

Replace "$(pwd)" with the absolute path of the top-level source directly you're
interested in if you're not running the docker image from the top level project
directory.

The supplied sonar-runner.properties file points to http://192.168.99.100 as the
Qube server. If you need to change that, either run the Docker container with
the bash command and run the command yourself, or just modify the command when
you run the container:

    docker run -ti -v $(pwd):/root/src newtmitch/sonar-scanner sonar-runner sonar.host.url=YOURURL -Dsonar.projectBaseDir=./src

# Server image

I've also included Dockerfile.server, which uses the sonarqube:latest image as a basis
basis and basically puts in the mechanism to update the server time to a user-defined
time zone vs. the default (correct time reporting for analyzer runs).

Docker Hub of this build available here:

You can modify the Dockerfile to update the timezone, or just pass in the environment variable on-demand:

    docker run -d --name sonarqube -e "TZ=America/Chicago" -p 9000:9000 -p 9092:9092 sonarqube
