FROM ghcr.io/craibuc/windows-sbt:latest AS build

ARG REPO_URI=https://github.com/chop-dbhi/ped-screen
ARG BRANCH=main

#
# clone specified branch of ped-screen's repository
#

WORKDIR /source

# clone the remote repository's branch to /source
RUN echo Cloning %REPO_URI%/tree/%BRANCH%...
RUN git clone %REPO_URI% -b %BRANCH% .

# copy local settings files
# COPY *.properties ./conf/local/
COPY ./conf/local/*.properties ./conf/local/

# create "fat" .JAR file
RUN sbt assembly

#
# final image
#

# FROM openjdk:${OPENJDK_TAG}
# FROM openjdk:18-jdk-nanoserver-1809

# WORKDIR /app

# # configuration files
COPY --from=build .\\source\\conf\\local\\source.properties .\\conf\\local\\
COPY --from=build .\\source\\conf\\local\\target.properties .\\conf\\local\\
COPY --from=build .\\source\\conf\\local\\pedscreen.properties .\\conf\\local\\

# SQL files
COPY --from=build .\\source\\sql .\\sql

# application (rename to remove version)
COPY --from=build .\\source\\target\\scala-2.12\\pedscreen*.jar .\\pedscreen.jar

# default executable and parameters that can't be modified by docker run
ENTRYPOINT ["java","-jar","pedscreen.jar","pedscreen","--pecarn"]

# added to ENTRYPOINT command; can be modified by docker run
CMD ["--list_params"]