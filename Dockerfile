FROM openjdk:8

LABEL maintainer="Anton Kozik <pazitron@gmail.com>"

RUN apt-get update
RUN apt-get install -y curl git tmux htop maven sudo

# Install Node - allows for scanning of Typescript
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN sudo apt-get install -y nodejs build-essential

# Set timezone to CST
ENV TZ=Europe/Warsaw
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /root

RUN curl --insecure -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.3.0.1492-linux.zip && \
	unzip sonarscanner.zip && \
	rm sonarscanner.zip && \
	mv sonar-scanner-3.3.0.1492-linux sonar-scanner

ENV SONAR_RUNNER_HOME=/root/sonar-scanner
ENV PATH $PATH:/root/sonar-scanner/bin

COPY sonar-runner.properties ./sonar-scanner/conf/sonar-scanner.properties

CMD sonar-scanner -Dsonar.projectBaseDir=./src
