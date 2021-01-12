<#
	Script that accepts 2 parameters like this: 
	$chocoAppList = "7zip, googlechrome, .."
	$dismAppList = "File-Services, FS-FileServer, .."
	
	you invoke the script like this:
	Invoke-Expression "InstallApps.ps1 ""$chocoAppList"" ""$dismAppList"""
	
	Idar Evensen 2021
#>
Param(
	[string]$chocoAppList,
	[string]$dismAppList
	)

if ([string]::IsNullOrWhiteSpace($chocoAppList) -eq $false -or [string]::IsNullOrWhiteSpace($dismAppList) -eq $false)
	{
	try{
		choco config get cacheLocation
	}catch{
			Write-Output "Chocolatey not detected, trying to install it now."
			$env:chocolateyProxyLocation = '172.29.3.232:8080'
			Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	
			choco source add -n=Artifactory -s="http://release.helsenord.no:8081/artifactory/api/nuget/Chocolatey-ServerSetups"
			choco source remove -n=chocolatey
		}
		else
		{ Write-Error -Message "Could not reach proxy, is the server in the correct zone?" }
	}
<# if $chocoApplist contains data, we try to choco install #>
if ([string]::IsNullOrWhiteSpace($chocoAppList) -eq $false){
Write-Host "Choco Apps will be installed"

$appsToInstall = $chocoAppList -split "," | foreach { "$($_.Trim())" }

foreach ($app in $appsToInstall)
	{
		Write-Host "Installing $app"
		& choco install $app /y | Write-Output
	}
}
<# if $dismAppList contains data, we try to install windows features #>
if ([string]::IsNullOrWhiteSpace($dismAppList) -eq $false){
Write-Host "DISM features will be installed"

$appsToInstall = $dismAppList -split "," | foreach { "$($_.Trim())" }

foreach ($app in $appsToInstall)
	{
		Write-Host "Installing $app"
		& choco install $app /y /source windowsfeatures | Write-Output
	}
}