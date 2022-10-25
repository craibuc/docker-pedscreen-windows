[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$Branch
)

$Uri = "https://api.github.com/repos/chop-dbhi/ped-screen/zipball/$Branch"
Write-Verbose "Uri: $Uri"

$Headers = @{ Authorization="Bearer $env:GITHUB_TOKEN" } 
$BaseName = "ped-screen.$Branch"

Write-Verbose "Retrieving archive..."
Invoke-WebRequest -Uri $Uri -Headers $Headers -OutFile "$BaseName.zip" -SkipCertificateCheck

Write-Verbose "Expanding archive..."
Expand-Archive "$BaseName.zip" -DestinationPath $BaseName

Write-Verbose "Moving..."
Get-ChildItem -Path ".\$BaseName" -Directory | Move-Item -Destination /source
