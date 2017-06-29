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


# Build

## Sonar Scanner 

To build this scanner image, just issue a standard Docker build command:

    docker build -t mitch/sonarscanner .

## Sonar Qube Server

To build the customized Sonar Qube server, run the following command. See the [Server image](#server-image) section below for details on this image build.

    docker build -t mitch/sonarqube -f Dockerfile.server .


# Usage

## Run Sonar Qube Server

Make sure you have a Sonar Qube server running.

If you used the timezone-setting-away server build per the instructions above, run the following command. If you omit the TZ parameter, it'll default to CST.

    docker run -d --name sonarqube -e "TZ=America/Chicago" -p 9000:9000 -p 9092:9092 mitch/sonarqube

If you prefer to use an official Sonar Qube image, run the following command instead. Note that if you need a particular version of Sonar Qube, you need to use something like `sonarqube:5.2` instead of what's shown below.

    docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
    

## Run Sonar Scanner

After your server is running, run the following command from the command line to start the scanner.

    docker run -ti -v $(pwd):/root/src --link sonarqube mitch/sonarscanner 

Replace "$(pwd)" with the absolute path of the top-level source directly you're
interested in if you're not running the docker image from the top level project
directory.

The supplied sonar-runner.properties file points to http://192.168.99.100 as the
Qube server. If you need to change that, either run the Docker container with
the bash command and run the command yourself, or just modify the command when
you run the container:

    docker run -ti -v $(pwd):/root/src --link sonarqube mitch/sonarscanner sonar-runner sonar.host.url=YOURURL -Dsonar.projectBaseDir=./src


# Server image

I've also included Dockerfile.server, which uses the sonarqube:latest image as a 
basis and basically puts in the mechanism to update the server time to a user-defined
time zone vs. the default (correct time reporting for analyzer runs).

You can modify the Dockerfile to update the timezone, or just pass in the environment variable on-demand (assumes you build it with tag `mitch/sonarqube`). If you omit the TZ setting it'll default to CST.

    docker run -d --name sonarqube -e "TZ=America/Chicago" -p 9000:9000 -p 9092:9092 mitch/sonarqube
