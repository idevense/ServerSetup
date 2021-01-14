<#
	$chocoAppList defines the apps you want choco to install
	@dismAppList defines the windows features you want to install
    $serverType param defines the input parameter that the script accepts and defines what features will be installed for the given server template. eg: ./install_server.ps1 web
	
	Idar Evensen 2021
#>
Param(
	[string]$serverType
	)

switch ($serverType)
{
    web { 
            Write-Host "Webserver-template valgt..."
            $chocoAppList = "7zip, googlechrome"
            $dismAppList = "File-Services, DFSR-Infrastructure-ServerEdition, IIS-WebServerRole, IIS-CustomLogging, IIS-ODBCLogging, IIS-LoggingLibraries, IIS-RequestMonitor , IIS-HttpTracing, IIS-IPSecurity, IIS-WindowsAuthentication, IIS-NetFxExtensibility45, IIS-ASPNET45, IIS-CGI, IIS-ISAPIExtensions, IIS-ISAPIFilter, IIS-ServerSideIncludes, IIS-ManagementService, WCF-HTTP-Activation45, IIS-HostableWebCore, WAS-WindowsActivationService, WAS-ProcessModel, WAS-ConfigurationAPI"
        }
    app { 
            Write-Host "Appserver-template valgt..."
            $chocoAppList = "7zip, googlechrome"
            $dismAppList = "ERRORAPPTEST"
        }
    biz { 
            Write-Host "Biztalkserver-template valgt..."
            $chocoAppList = "7zip, googlechrome"
            $dismAppList = "ERRORBIZTEST"
        }

    Default { "Invalid server type, exiting"; exit }
 }

$proxyFilePath = $PSScriptRoot + "\proxy.ps1"
$installapps = $PSSCriptRoot + "\InstallApps.ps1"

. $proxyFilePath
Set-Proxy -server "www-proxy.helsenord.no" -port 8080
. $installApps "$chocoAppList" "$dismAppList"
Remove-Proxy