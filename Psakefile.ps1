<#
.SYNOPSIS
This file defines the tasks that can be used to automate Docker commands.

PSake is a build-automation tool written in Powershell, similar to `make` or `ant`.

.EXAMPLE
Invoke-PSake build

Builds the image.

.EXAMPLE
Invoke-PSake rebuild

Same as build, but will rebuild all the image's layers (--no-cache).

.EXAMPLE
Invoke-PSake terminal

Start a PowerShell session in container.  Useful for diagnostic purposes.

.EXAMPLE
Invoke-PSake params

Runs the container and displays the parameters that are being used by ped-screen.

.EXAMPLE
Invoke-PSake publish

Publishes the image to Github.

.LINK
https://psake.readthedocs.io/en/latest/

.NOTES
To install PSake,

PS> Install-Module psake
#>

Properties {
    $APP_NAME='pedscreen-win'
    $APP_VERSION='1.2'
}

# removing github tag
# --tag "ghcr.io/$($env:GITHUB_ACCOUNT)/$APP_NAME" `

Task Build {
	Write-Host 'Building image...'
    docker build `
        --build-arg "REPO_URI=https://$( $env:GITHUB_ACCOUNT )`:$( $env:GITHUB_TOKEN )@github.com/chop-dbhi/ped-screen" `
        --build-arg "GITHUB_BRANCH=$( $env:GITHUB_BRANCH )" `
        --tag "$APP_NAME`:latest" `
        .
}

Task Rebuild {
    docker build `
        --no-cache `
        --build-arg "REPO_URI=https://$( $env:GITHUB_ACCOUNT )`:$( $env:GITHUB_TOKEN )@github.com/chop-dbhi/ped-screen" `
        --build-arg "GITHUB_BRANCH=$( $env:GITHUB_BRANCH )" `
        --tag "$APP_NAME`:latest" `
        .
}

Task Terminal {
	Write-Host 'Starting terminal...'
    docker run -it --rm --env-file=.pedscreen/.env "$APP_NAME`:latest" powershell
}

Task Params {
	Write-Host 'Starting ped-screen; listing parameters...'
    docker run -it --rm --env-file=.pedscreen/.env "$APP_NAME`:latest"
}

# Task Github {
# 	Write-Host 'Publishing image to Github...'
# 	$env:GITHUB_TOKEN | docker login ghcr.io -u $env:GITHUB_ACCOUNT --password-stdin
#     docker tag $APP_NAME "ghcr.io/$($env:GITHUB_ACCOUNT)/$APP_NAME"
# 	docker push "ghcr.io/$($env:GITHUB_ACCOUNT)/$APP_NAME`:latest"
# }