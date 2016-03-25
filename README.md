# docker-sonar-scanner Overview

A quick (Sonar)[http://www.sonarqube.org/] scanner (command line)

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

Just run the following command from the command line.

    docker run -ti mitch/sonarscanner -v $(pwd):/root/src

Replace "$(pwd)" with the absolute path of the top-level source directly you're
interested in if you're not running the docker image from the top level project
directory.

The supplied sonar-runner.properties file points to http://192.168.99.100 as the
Qube server. If you need to change that, either run the Docker container with
the bash command and run the command yourself, or just modify the command when
you run the container:

    docker run -ti mitch/sonarscanner -v $(pwd):/root/src sonar-runner sonar.host.url=YOURURL -Dsonar.projectBaseDir=./src
