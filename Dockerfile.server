
FROM sonarqube:lts

LABEL maintainer="Ryan Mitchell <mitch@ryansmitchell.com>"

# Set timezone to CST
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
