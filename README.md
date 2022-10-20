# docker-pedscreen-windows
A Windows-based, Docker container for the ped-screen application.

## Usage

### Build

#### Export environment variables
> NOTE: this could be added to `$profile`.

```powershell
$env:GITHUB_TOKEN=<github personal-access token (PAT)>
$env:BRANCH=<github branch name>
```

#### Build the image
```powershell
PS> docker build --build-arg "GITHUB_TOKEN=$env:GITHUB_TOKEN" --build-arg "BRANCH=$env:BRANCH" --tag "pedscreen-win:latest" .
```

### Run

#### Create the environment file
This file contains the environment variables that are supplied to docker when the container is run.

- Copy `.env.sample` to `.env`
```powshell
PS> cp .env.sample .env
```
- Edit the file and supply the missing values

#### Run container and display ped-screen's parameters
```bash
PS> docker run --rm --env-file=.env pedscreen-win:latest
```