Properties {
    $APP_NAME='pedscreen-win'
    $APP_VERSION='1.2'

    $SBT_VERSION='1.6.2'
    $GIT_VERSION='2.38.1'
    $JDK_VERSION='11.0.16.1'
    
    $BRANCH='choa'
}

Task Build {
	Write-Host 'Building image...'
    docker build --build-arg "REPO_URI=https://$( $env:GITHUB_ACCOUNT )`:$( $env:GITHUB_TOKEN )@github.com/chop-dbhi/ped-screen" --build-arg "BRANCH=$BRANCH" --tag "$APP_NAME`:latest" .
}

Task Terminal {
	Write-Host 'Starting terminal...'
    docker run -it --rm "$APP_NAME`:latest" powershell
}

Task Params {
	Write-Host 'Starting ped-screen; listing parameters...'
    docker run -it --rm "$APP_NAME`:latest"
}