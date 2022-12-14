# docker-pedscreen-windows
A Windows-based, Docker container for the [pedscreen](https://github.com/chop-dbhi/ped-screen) application.

## Configuration
One-time configuration tasks to be completed.

> NOTE: unless otherwise indicated, the PowerShell commands should be executed in the project's root folder (`PS>`).

#### Github

These settings are used to clone a branch of the [pedscreen](https://github.com/chop-dbhi/ped-screen) application.

Use Windows' Advanced Setting UI to create these variables: `GITHUB_ACCOUNT`, `GITHUB_TOKEN`, `GITHUB_BRANCH`.

** OR **

Use PowerShell to set the user-specific environment variables:

```powershell
[Environment]::SetEnvironmentVariable("GITHUB_ACCOUNT", "<github account>", "User")
[Environment]::SetEnvironmentVariable("GITHUB_TOKEN", "<github personal-access token (PAT)>", "User")
[Environment]::SetEnvironmentVariable("GITHUB_BRANCH", "<github branch name>", "User")
```

### Pedscreen

#### Create the environment file
This file contains the environment variables that are supplied to docker when the `pedscreen` container is run.

- Copy `.env.sample` to `.env`

```powshell
PS> cd .pedscreen
PS .pedscreen> cp .env.sample .env
```

- Edit the file and supply the missing values

### Postgres

#### Create the environment file
This file contains the environment variables that are supplied to docker when the `postgres` container is run.

- Copy `.env.sample` to `.env`

```powshell
PS> cd .postgres
PS .postgres> cp .env.sample .env
```

- Edit the file and supply the missing values

### Docker Compose

#### Create the docker-compose.yaml

```powershell
PS> cp docker-compose.sample.yaml docker-compose.yaml
```

Modify the contents of the file to meet your needs.

#### Create a symbolic link for postgres' environment file

```powershell
PS> New-Item -ItemType SymbolicLink -Path . -Name '.env' -Target '.postgres/.env'
```

## Build
The image can be built using `docker` or `docker compose`.  The later is preferred.

### docker
Creates the pedscreen image, using the supplied arguments.

```powershell
PS> docker build --build-arg "GITHUB_TOKEN=$env:GITHUB_TOKEN" --build-arg "GITHUB_BRANCH=$env:GITHUB_BRANCH" --tag "pedscreen-win:latest" .
```

### docker compose
It is easier, however, to use docker-compose to build the ped-screen image.  The build settings are contained in the `docker-comfig.yaml` file.

```powershell
PS> docker compose build
```
## Run
Because the `pedscreen` application depends on an instance of `postgres`, it is recommend to use `docker compose` to run the containers.  By using `docker compose`, an application/database container pair will be created for each location (3 pairs in the default configuration).

#### Export the date ranges as environment variables

```powershell
ps> $env:DATE_START='2021/03/01'
ps> $env:DATE_END='2021/03/31'
```

### start all containers

```powershell
ps> docker-compose up -d
```

> NOTE: `docker compose` will automatically use the `.env` file in the project's root.  **Ensure that the `.env` symbolic link references `.postgres/.env`.**

### monitor the logs, optionally supplying the name of the service to filter the logs

```powershell
ps> docker-compose logs -f [database|app]
```

### stop and remove all containers and network

```powershell
ps> docker-compose down
```

## References

- [PostgreSQL as a Windows container](https://github.com/stellirin/docker-postgres-windows)
- [postgres - Official Docker images](https://hub.docker.com/_/postgres/)