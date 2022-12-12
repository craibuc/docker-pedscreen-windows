Properties {
    $APP_NAME='pedscreen-win'
    $APP_VERSION='1.2'    
    $BRANCH='choa'
}

Task Build {
	Write-Host 'Building image...'
    docker build `
        --build-arg "REPO_URI=https://$( $env:GITHUB_ACCOUNT )`:$( $env:GITHUB_TOKEN )@github.com/chop-dbhi/ped-screen" `
        --build-arg "BRANCH=$BRANCH" `
        --tag "ghcr.io/$($env:GITHUB_ACCOUNT)/$APP_NAME" `
        --tag "$APP_NAME`:latest" `
        .
}

Task Rebuild {
    docker build `
        --no-cache `
        --build-arg "REPO_URI=https://$( $env:GITHUB_ACCOUNT )`:$( $env:GITHUB_TOKEN )@github.com/chop-dbhi/ped-screen" `
        --build-arg "BRANCH=$BRANCH" `
        --tag "ghcr.io/$($env:GITHUB_ACCOUNT)/$APP_NAME" `
        --tag "$APP_NAME`:latest" `
        .
}

Task Terminal {
	Write-Host 'Starting terminal...'
    docker run -it --rm "$APP_NAME`:latest" powershell
}

Task Params {
	Write-Host 'Starting ped-screen; listing parameters...'
    docker run -it --rm --env-file=.env "$APP_NAME`:latest"
}

Task Publish {
	Write-Host 'Publishing image to Github...'
	$env:GITHUB_TOKEN | docker login ghcr.io -u $env:GITHUB_ACCOUNT --password-stdin
    docker tag $APP_NAME "ghcr.io/$($env:GITHUB_ACCOUNT)/$APP_NAME"
	docker push "ghcr.io/$($env:GITHUB_ACCOUNT)/$APP_NAME`:latest"
}