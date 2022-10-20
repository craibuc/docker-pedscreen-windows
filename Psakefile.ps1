Properties {
    $OPENJDK_TAG='11.0.13'
    $SBT_VERSION='1.6.2'
    $APP_NAME='pedscreen-win'
    $APP_VERSION='1.2'
    $BRANCH='choa'
}

Task Build {
	Write-Host 'Building image...'
	docker build --build-arg "GITHUB_TOKEN=$env:GITHUB_TOKEN" --build-arg "BRANCH=$BRANCH" --tag "$APP_NAME`:$APP_VERSION" --tag "$APP_NAME`:latest" .
}

Task Terminal {
	Write-Host 'Starting terminal...'
    docker run -it --rm --entrypoint pwsh "$APP_NAME`:latest"
}