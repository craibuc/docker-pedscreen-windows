BeforeAll {
    
    $Path = Split-Path -Parent $PSCommandPath
    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    . (Join-Path $Path $SUT)

}

Describe 'Get-GitHubRepoArchive' {

    Context 'Parameter validation' {

        BeforeAll {
            $Command = Get-Command 'Get-GitHubRepoArchive'
        } 

        @{Name='Organization';Type=[string];Mandatory=$true;Position=0},
        @{Name='Repository';Type=[string];Mandatory=$true;Position=1},
        @{Name='Branch';Type=[string];Position=2},
        @{Name='ArchiveType';Type=[string];Position=3},
        @{Name='Credential';Type=[pscredential];Position=4} | ForEach-Object {

            $Parameter=$_

            Context "$($Parameter.Name)" {
                
                It "is a <Type>" -TestCases $Parameter {
                    param ($Name, $Type)

                    $Command | Should -HaveParameter $Name -Type $Type

                }

                It "is mandatory <Mandatory>" -TestCases $Parameter {
                    param ($Name, $Mandatory)
                    if ( $Mandatory ) { $Command | Should -HaveParameter $Name -Mandatory $Mandatory }
                    else { $true }
                }

                It "has position <Position>" -TestCases $Parameter {
                    param ($Name, $Position)
                    # $Command | Should -HaveParameter $ParameterName
                }

            } # /Context

        } # /ForEach-Object

    } # /Context 'Parameter validation'

    Context 'Request' {

        BeforeEach {

            Mock Invoke-WebRequest

            $Expected = @{
                Organization = 'chop-dbhi'
                Repository = 'ped-screen'
                Branch = 'main'
                ArchiveType = 'zipball'
            }

        }
    
        It 'uses the correct Method' {
            # act
            Get-GitHubRepoArchive @Expected
            
            # assert
            Assert-MockCalled 'Invoke-WebRequest' -ParameterFilter {
                $Method -eq 'Get'
            }
        }

        It 'uses the correct Uri' {
            # act
            Get-GitHubRepoArchive @Expected
            
            # assert
            Assert-MockCalled 'Invoke-WebRequest' -ParameterFilter {
                $ExpectedUri = "https://api.github.com/repos/{0}/{1}/{2}/{3}" -f $Expected.Organization, $Expected.Repository, $Expected.ArchiveType, $Expected.Branch
                $URI -eq $ExpectedUri
            }
        }
    
        It 'uses the correct Headers' {
            # act
            Get-GitHubRepoArchive @Expected
            
            # assert
            Assert-MockCalled 'Invoke-WebRequest' -ParameterFilter {
                $Headers['Accept'] -eq 'application/vnd.github.v3+json'
            }
        }

        Context 'when the Branch parameter is supplied' {

            It 'uses the correct Uri' {
                # arrange
                $Expected['Branch'] = 'master'

                # act
                Get-GitHubRepoArchive @Expected
                
                # assert
                Assert-MockCalled 'Invoke-WebRequest' -ParameterFilter {
                    $ExpectedUri = "https://api.github.com/repos/{0}/{1}/{2}/{3}" -f $Expected.Organization, $Expected.Repository, $Expected.ArchiveType, $Expected.Branch
                    $URI -eq $ExpectedUri
                }
            }
    
        }
    
        Context 'when the ArchiveType parameter is supplied' {

            It 'uses the correct Uri' {   
                # arrange
                $Expected['ArchiveType'] = 'tarball'

                # act
                Get-GitHubRepoArchive @Expected
                
                # assert
                Assert-MockCalled 'Invoke-WebRequest' -ParameterFilter {
                    $ExpectedUri = "https://api.github.com/repos/{0}/{1}/{2}/{3}" -f $Expected.Organization, $Expected.Repository, $Expected.ArchiveType, $Expected.Branch
                    $URI -eq $ExpectedUri
                }
            }
    
        }
    
        Context 'when the Token parameter is supplied' {

            It 'uses the correct Headers' {
                # arrange
                $Token = 'ABCDEFGHIJKLMNOPQURSTUVWXYZ'
    
                # act
                Get-GitHubRepoArchive @Expected -Token $Token
                
                # assert
                Assert-MockCalled 'Invoke-WebRequest' -ParameterFilter {
                    $Headers['Authorization'] -eq "Bearer $Token"
                }
            }
    
        }

        Context 'when the Credential parameter is supplied' {

            It 'uses the correct Headers' {
                # arrange
                $Credential = [pscredential]::new('user', ('password' | ConvertTo-SecureString -AsPlainText -Force))
    
                # act
                Get-GitHubRepoArchive @Expected -Credential $Credential
                
                # assert
                Assert-MockCalled 'Invoke-WebRequest' -ParameterFilter {
                    $Headers['Authorization'] -like 'Basic*'
                }
            }
    
        }

    } # /Context 'Request'

}