#
# source stage: retrieve source code from github
#

FROM mcr.microsoft.com/powershell:nanoserver-1809 AS source

# to be modified by `docker build`
# docker build --build-arg "GITHUB_TOKEN=$env:GITHUB_TOKEN" --build-arg "BRANCH=$BRANCH" .

ARG REPO_URI="https://github.com/chop-dbhi/ped-screen"
ARG BRANCH=main
ARG GITHUB_TOKEN

# RUN echo "BRANCH: %BRANCH%"
# RUN echo "GITHUB_TOKEN: %GITHUB_TOKEN%"

# configure powershell
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# all artifacts add to /temp
WORKDIR /temp

# copy the files and directories that aren't excluded by .dockerignore to /temp
COPY . .

# run powershell script to get branch's repo as a ZIP archive, expand it, then move it to the /source directory
RUN .\Get-Archive.ps1 -Branch $env:BRANCH -Verbose

#
# build stage: compile app into a single, fat JAR file
#

FROM openjdk:18-jdk-nanoserver-1809 AS build

WORKDIR /app

# copy from /source to /app
COPY --from=source ./source .

# copy local settings files
# COPY *.properties ./conf/local/

# create "fat" .JAR file
# RUN sbt assembly

#
# final stage
#

# FROM openjdk:${OPENJDK_TAG}
FROM openjdk:18-jdk-nanoserver-1809 AS final

WORKDIR /app

# # configuration files
# COPY --from=build ./source/conf/local/*.properties ./conf/local/
# # SQL files
# COPY --from=build ./source/sql ./sql
# # application (rename to remove version)
# COPY --from=build ./source/target/scala*/pedscreen*.jar ./pedscreen.jar

# # default executable and parameters that can't be modified by docker run
# ENTRYPOINT ["java","-jar","pedscreen.jar","pedscreen","--pecarn"]

# # added to ENTRYPOINT command; can be modified by docker run
# CMD ["--list_params"]

# java -jar pedscreen.jar pedscreen --pecarn --list_params

# CMD ["java","--version"]
