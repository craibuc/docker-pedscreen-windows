FROM ghcr.io/craibuc/windows-sbt:latest AS build

#
# supply desired values as build arguments
#
ARG REPO_URI=https://github.com/chop-dbhi/ped-screen
ARG APP_VERSION=1.2
ARG GITHUB_BRANCH=main

#
# clone specified branch of ped-screen's repository
#

WORKDIR /source

# clone the remote repository's branch to /source
RUN echo Cloning %REPO_URI%/tree/%GITHUB_BRANCH%...
RUN git clone %REPO_URI% -b %GITHUB_BRANCH% .

# copy local settings files
COPY ./conf/local/*.properties ./conf/local/

# create "fat" .JAR file
RUN sbt assembly

#
# final image
#

FROM openjdk:18-jdk-nanoserver-1809

WORKDIR /app

# # configuration files
COPY --from=build c:\\source\\conf\\local\\source.properties .\\conf\\local\\source.properties
COPY --from=build c:\\source\\conf\\local\\target.properties .\\conf\\local\\target.properties
COPY --from=build c:\\source\\conf\\local\\pedscreen.properties .\\conf\\local\\pedscreen.properties

# SQL files
COPY --from=build c:\\source\\sql .\\sql

# application (rename to remove version)
COPY --from=build c:\\source\\target\\scala-2.12\\pedscreen-1.2.jar .\\pedscreen.jar

# default executable and parameters that can't be modified by docker run
ENTRYPOINT ["java","-jar","pedscreen.jar","pedscreen","--pecarn"]

# added to ENTRYPOINT command; can be modified by docker run
CMD ["--list_params"]