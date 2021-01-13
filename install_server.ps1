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
            $dismAppList = "File-Services"
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

#"File-Services, FS-FileServer, FS-DFS-Replication, Storage-Services, Web-Server, Web-Common-Http, Web-Default-Doc, Web-Dir-Browsing, Web-Http-Errors, Web-Static-Content, Web-Health, Web-Http-Logging, Web-Custom-Logging, Web-Log-Libraries, Web-ODBC-Logging, Web-Request-Monitor, Web-Http-Tracing, Web-Performance, Web-Stat-Compression, Web-Security, Web-Filtering, Web-Basic-Auth, Web-Digest-Auth, Web-IP-Security, Web-Windows-Auth, Web-App-Dev, Web-Net-Ext45, Web-ASP, Web-Asp-Net45, Web-CGI, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Includes, Web-Mgmt-Tools, Web-Mgmt-Console, Web-Mgmt-Service, NET-Framework-45-Features, NET-Framework-45-Core, NET-Framework-45-ASPNET, NET-WCF-Services45, NET-WCF-HTTP-Activation45, NET-WCF-TCP-PortSharing45, Web-WHC, Telnet-Client, WAS, WAS-Process-Model, WAS-Config-APIs"
$proxyFilePath = $PSScriptRoot + "\proxy.ps1"
$installapps = $PSSCriptRoot + "\InstallApps.ps1"

. $proxyFilePath
Set-Proxy -server "www-proxy.helsenord.no" -port 8080
. $installApps "$chocoAppList" "$dismAppList"
Remove-Proxy