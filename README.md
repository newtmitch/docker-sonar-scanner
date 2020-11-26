# docker-sonar-scanner

**UPDATE 2020-11-25:** SonarScanner has an official Docker image available, and has for a while. See [here](https://hub.docker.com/r/sonarsource/sonar-scanner-cli) and [here](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/) for details. Although I'm happy to keep my project alive, I'd love to hear from consumers and contributors of this repo about whether the official image is the Better Way™ or if what I've done here has some distinct and specific value that the official image doesn't. I've created an [issue here](https://github.com/newtmitch/docker-sonar-scanner/issues/42) for discussion if you'd like to add your thoughts. 

# Breaking Change starting at tag 4.1.0:

I introduced a terrible change into existing images that caused a issues for a bunch of people (sorry! :disappointed:) - see [issue #29](https://github.com/newtmitch/docker-sonar-scanner/issues/29) and commit [71cce6](https://github.com/newtmitch/docker-sonar-scanner/commit/71cce66ba7b586fef5c6cb51cd25be23cf261b1c) for discussions. Starting with the refactored Dockerfile I've introduced here, and starting with image tag newtmitch/sonar-scanner-alpine:4.1.0 I've moved back to the `CMD`-based Dockerfile run command instead of the combo `ENTRYPOINT`+`CMD`. I think this allows for the easiest override for both CI use-cases as well as normal CLI-based execution. Open an issue if you have other thoughts and we can discuss there.

I'm also going to push a new tag based on Sonar Scanner version 4.0 that uses the new `ENTRYPOINT` + `CMD` approach but leave the existing tags alone. This Docker image will have the tag `newtmitch/sonar-scanner-alpine:4.0.0-ci` and it's corresponding non-alpine counterpart. 

# Moving to alpine-only image

Starting with the 4.1 Sonar Scanner image, I'm only maintaining the alpine-based Docker image. From the best I can tell, the Alpine-based image is the one everyone locks on, so I'm keeping that my primary focus for now. If anyone has any comments about that, please let me know with an issue.

I will continue to maintain alpine and non-alpine image tags in Docker Hub, but they'll all effectively point to the Alpine-based image underneath.

# Overview
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
docker run -ti -v $PWD:/usr/src --link sonarqube newtmitch/sonar-scanner-alpine
```

Run this from the root of your source code directory, it'll scan everything below it.

This uses the latest Qube image - if you want LTS, use image name `sonarqube:lts`.

Run the alpine version:

```
docker run -ti -v $PWD:/usr/src --link sonarqube newtmitch/sonar-scanner-alpine
```

If you want to run without a local SonarQube instance (i.e. using a remote SonarQube), 
just leave off the `--link` parameter:

```
docker run -ti -v $PWD:/usr/src newtmitch/sonar-scanner-alpine
```


# Running - Long Version

To run the scanner you must have a Sonar Qube running. If you don't already have a Qube instance running somewhere, you can start one via Docker using the official Docker image or the variant I have below.


## Run Sonar Qube Server

If you prefer to use an official Sonar Qube image, run the following command. Note that if you need a particular version of Sonar Qube, you need to use something like `sonarqube:5.2` instead of what's shown below.

    docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube

If you prefer a server build that automatically sets the timezone when you start it you can use the custom image variant I have here per the command below. If you omit the TZ parameter, it'll default to CST.

    docker run -d --name sonarqube -e "TZ=America/Chicago" -p 9000:9000 -p 9092:9092 newtmitch/sonar-server


## Run Sonar Scanner

After your server is running, run the following command from the command line to start the scanner. This uses the default settings in the sonar-runner.properties file, which you can overload with -D commands (see below).

    docker run -ti -v $PWD:/usr/src --link sonarqube newtmitch/sonar-scanner-alpine 

Replace "$PWD" with the absolute path of the top-level source directly you're
interested in if you're not running the docker image from the top level project
directory. It will scan everything under that directory when it starts up.

If you need to use a different directory as the project base directory, you can 
pass that in as part of the docker run command to override that default:

    docker run -ti -v $PWD:/usr/src --link sonarqube newtmitch/sonar-scanner-alpine \
        sonar-scanner -Dsonar.projectBaseDir=/my/project/base/dir

The supplied sonar-runner.properties file points to http://192.168.99.100 as the
Qube server. If you need to change that or any other of the variables that Scanner needs to run, you can pass them in with the command itself to override them:

    docker run -ti -v $PWD:/usr/src --link sonarqube newtmitch/sonar-scanner-alpine \
        sonar-scanner -Dsonar.host.url=YOURURL -Dsonar.projectBaseDir=/usr/src

or if you're running the `newtmitch/sonar-scanner:2.5.1` image, because the script name changed between 2.5.1 and 3.0.3 at some point:

    docker run -ti -v $PWD:/usr/src --link sonarqube newtmitch/sonar-scanner-alpine \
        sonar-runner -Dsonar.host.url=YOURURL -Dsonar.projectBaseDir=/usr/src

Here's how I use it occasionally with a single server across multiple projects just to do a semi-regular checkup:

```bash
docker run -ti -v $PWD:/usr/src --link sonarqube newtmitch/sonar-scanner-alpine \
    sonar-scanner -Dsonar.projectKey=myotherproject -Dsonar.projectName="Another Project"
```

Here's a fully-loaded command line (based on latest/3.0.3 version) that basically overrides everything from the sonar-runner.properties file on the command-line itself. The settings shown here match those in the sonar-runner.properties file.

```
docker run -ti -v $PWD:/usr/src --link sonarqube newtmitch/sonar-scanner-alpine \
    sonar-scanner \
    -Dsonar.host.url=http://sonarqube:9000 \
    -Dsonar.jdbc.url=jdbc:h2:tcp://sonarqube/sonar \
    -Dsonar.projectKey=MyProjectKey \
    -Dsonar.projectName="My Project Name" \
    -Dsonar.projectVersion=1 \
    -Dsonar.projectBaseDir=/usr/src \
    -Dsonar.sources=.
```

Or just have your local sonar-runner.properties override the default version built into the
scanner image. Note that you'll likely have to modify your paths to pick up the properties
file, source directories, or copy the sonar-runner.properties file into your actual source
code project in order to have it be called with this command as-written below.

```
docker run -ti \
  --rm \
  -v $PWD:/usr/src \
  -v $PWD/sonar-runner.properties:/usr/lib/sonar-scanner/conf/sonar-scanner.properties \
  --link sonarqube \
  newtmitch/sonar-scanner-alpine sonar-scanner
```

## Javascript / Typescript

As of Aug 3, 2018, I installed Node as part of the scanner image so it can properly scan JS and TS
files as-needed. The SonarQube server excludes `**/node_modules/**` file patterns by default as
part of JS and TS general settings (Adminstration -> Configuration -> General Settings). You can
override those from a local sonar-runner.properties file:

```
sonar.exclusions=**/node_modules/**/*
```

or via the command line:

```
docker run -ti -v $PWD:/usr/src --link sonarqube newtmitch/sonar-scanner-alpine sonar-scanner \         
  -Dsonar.exclusions=**/node_modules/**/*
```

I have this included and commented out in the sonar-runner.properties that ships as part of this
image.

# Build

## Sonar Scanner 

To build this scanner image, just issue a standard Docker build command. The Dockerfile contains a default Scanner version environment variable that is meant to be overridden on subsequent builds as needed and without changing the Dockerfile itself:

```
docker build -t newtmitch/sonar-scanner-alpine:latest -f Dockerfile.alpine --build-arg SCANNER_VERSION=4.5.0.2216 .
docker build -t newtmitch/sonar-scanner:latest -f Dockerfile --build-arg SCANNER_VERSION=4.5.0.2216 .
```

The list of the last few version tags for future reference:

* 4.0: `4.0.0.1744`
* 4.1: `4.1.0.1829`
* 4.2: `4.2.0.1873`
* 4.3: `4.3.0.2102`
* 4.4: `4.4.0.2170`
* 4.5: `4.5.0.2216`

## Sonar Qube Server

To build the customized Sonar Qube server, run the following command. See the [Server image](#server-image) section below for details on this image build.

```
docker build -t my-sonar-server -f Dockerfile.server .
```

## Tagging

I tag the built images to correspond 1-1 with the Sonar Scanner major/minor/patch version itself with the semi-standard Docker-style `^` semver-style approach (i.e. the tag `4` would include the latest minor+patch version of 4.x, while `4.1` would include the latest 4.1.x)

```
docker tag newtmitch/sonar-scanner-alpine:latest newtmitch/sonar-scanner-alpine:4
docker tag newtmitch/sonar-scanner-alpine:latest newtmitch/sonar-scanner-alpine:4.5
```

# Server image

I've also included Dockerfile.server, which uses the sonarqube:latest image as a 
basis and basically puts in the mechanism to update the server time to a user-defined
time zone vs. the default (correct time reporting for analyzer runs).

You can modify the Dockerfile to update the timezone, or just pass in the environment variable on-demand (assumes you build it with tag `mitch/sonarqube`). If you omit the TZ setting it'll default to CST.

```
docker run -d --name sonarqube -e "TZ=America/Chicago" -p 9000:9000 -p 9092:9092 newtmitch/sonar-server
```

# Change Log

### 2020-11-25
* Pulled back into a single Dockerfile command with an ENV-driven Scanner version (why didn't I think of that before?)
* Moved from `ENTRYPOINT` back to `CMD`-based launch (I screwed up when switching over). See issues #29 and #30.
* Added 4.1 - 4.5 Scanner versions
* Updated the base image from openjdk:8 to openjdk:12
* Removed the non-alpine Dockerfile
* Upgraded the installed version of NodeJS to 12.

### 2019-05-16
* Separated Dockerfile command into ENTRYPOINT and CMD operations to better follow Dockerfile best practices (see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#entrypoint). (issue #29)

### 2019-05-13
* Commented out `sonar.exclusions` from the `sonar-runner.properties` file included in the image by default (issue #25)
* Removed the use of the `/root` directory as part of the image build. Using `/usr/lib`, `/usr/bin`, and `/usr/src` now (issue #26)

### 2019-01-31
* Added Scanner v3.3.0 to Dockerfiles (@mpodlodowski)

### 2019-01-04
* Decreased size of images by combining multiple command line operations into a single RUN command
    (@DmitriyStoyanov)

### 2018-10-14
* Changed Sonar Scanner URL from bintray to sonarsource (@parnpresso)

### 2018-10-03
* Added NodeJS to the image to support JS/TS scanning (fixes #9)

### 2018-06-24
* Returned default timezone to original maintainers (@danstreeter)
* Added Scanner v3.2.0 to Dockerfiles (@danstreeter)

### 2018-08-03
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
