<#

.EXAMPLE
Get-GitHubArchive -Organization 'chop-dbhi' -Repository 'ped-screen' -Branch 'choa'

Zip archive

.EXAMPLE
Get-GitHubArchive -Organization 'chop-dbhi' -Repository 'ped-screen' -Branch 'choa' -ArchiveType tarball

Tarball archive
#>
function Get-GitHubRepoArchive 
{

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Organization,

        [Parameter(Mandatory)]
        [string]$Repository,

        [Parameter()]
        [string]$Branch = 'main',

        [Parameter()]
        [ValidateSet('tarball','zipball')]
        [string]$ArchiveType = 'zipball',

        [Parameter()]
        [string]$Token,

        [Parameter()]
        [pscredential]$Credential
    )
    
    $Uri = "https://api.github.com/repos/{0}/{1}/{2}/{3}" -f $Organization, $Repository, $ArchiveType, $Branch
    Write-Debug "Uri: $Uri"

    $Headers = @{
        Accept = "application/vnd.github.v3+json"
    }

    if ($Token) {
        $Headers['Authorization'] = "Bearer $Token"
    }

    if ($Credential) {
        $UserNamePassword = "{0}:{1}" -f $Credential.UserName, ($Credential.Password | ConvertFrom-SecureString -AsPlainText)
        $Authorization = "Basic {0}" -f [Convert]::ToBase64String( [System.Text.Encoding]::Ascii.GetBytes($UserNamePassword) )
        $Headers['Authorization'] = $Authorization
    }

    $Outfile = "{0}.{1}.{2}.{3}" -f $Organization, $Repository, $Branch, ( $ArchiveType -eq 'zipball' ? 'zip' : 'tar.gz')
    Invoke-WebRequest -Method Get -Uri $Uri -Headers $Headers -OutFile $Outfile

}
