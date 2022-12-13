# docker-pedscreen-windows
A Windows-based, Docker container for the ped-screen application.

## Usage

### Build

#### Export environment variables

Use PowerShell to set your user-specific environment variables:

```powershell
[Environment]::SetEnvironmentVariable("GITHUB_ACCOUNT", "<github account>", "User")
[Environment]::SetEnvironmentVariable("GITHUB_TOKEN", "<github personal-access token (PAT)>", "User")
[Environment]::SetEnvironmentVariable("GITHUB_BRANCH", "<github branch name>", "User")
```

**Or**

Add the values to your `$profile` file.

```powershell
$env:GITHUB_ACCOUNT=<github account>
$env:GITHUB_TOKEN=<github personal-access token (PAT)>
$env:GITHUB_BRANCH=<github branch name>
```

#### Build the image
```powershell
PS> docker build --build-arg "GITHUB_TOKEN=$env:GITHUB_TOKEN" --build-arg "GITHUB_BRANCH=$env:GITHUB_BRANCH" --tag "pedscreen-win:latest" .
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