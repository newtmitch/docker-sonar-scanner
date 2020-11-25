FROM openjdk:8

LABEL maintainer="Ryan Mitchell <mitch@ryansmitchell.com>"

# BEGIN non-alpine-specific
RUN apt-get update
RUN apt-get install -y curl git tmux htop maven sudo
# Install Node - allows for scanning of Typescript
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN sudo apt-get install -y nodejs build-essential
# END non-alpine-specific

# Set timezone to CST
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /usr/src

ARG SCANNER_VERSION=4.5.0.2216
ENV SCANNER_FILE=sonar-scanner-cli-${SCANNER_VERSION}-linux.zip
ENV SCANNER_EXPANDED_DIR=sonar-scanner-${SCANNER_VERSION}-linux
RUN curl --insecure -o ${SCANNER_FILE} \
    -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/${SCANNER_FILE} && \
	unzip -q ${SCANNER_FILE} && \
	rm ${SCANNER_FILE} && \
	mv ${SCANNER_EXPANDED_DIR} /usr/lib/sonar-scanner && \
	ln -s /usr/lib/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner

ENV SONAR_RUNNER_HOME=/usr/lib/sonar-scanner

COPY sonar-runner.properties /usr/lib/sonar-scanner/conf/sonar-scanner.properties

# Separating ENTRYPOINT and CMD operations allows for core execution variables to
# be easily overridden by passing them in as part of the `docker run` command.
# This allows the default /usr/src base dir to be overridden by users as-needed.
CMD ["sonar-scanner", "-Dsonar.projectBaseDir=/usr/src"]
