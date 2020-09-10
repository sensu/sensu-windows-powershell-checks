<#
.SYNOPSIS
   This plugin checks whether a User-inputted Windows service is running or not.

.DESCRIPTION
   This plugin checks whether a User-inputted Windows service is running or not.

.Notes
    FileName    : check-windows-service.ps1

.PARAMETER ServiceName
    Required.  Service name to check.

.EXAMPLE
    powershell.exe -file check-windows-service.ps1 sshd
#>

#
#   check-windows-service.ps1
#
# DESCRIPTION:
#   This plugin checks whether a User-inputted Windows service is running or not.
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Windows
#
# DEPENDENCIES:
#   Powershell 3.0 or above
#
# USAGE:
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-service.ps1
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#

#Requires -Version 3.0

[CmdletBinding()]
Param(
  [Parameter(Mandatory = $True, Position = 1)]
  [string]$ServiceName
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$Exists = Get-Service $ServiceName -ErrorAction SilentlyContinue

if ($Exists) {
  if (($Exists).Status -eq "Running") {
    Write-Host "OK: $ServiceName Running."
    exit 0
  }

  if (($Exists).Status -eq "Stopped") {
    Write-Host "CRITICAL: $ServiceName Stopped."
    exit 2
  }
}
else {
  Write-Host "CRITICAL: $ServiceName not found!"
  exit 2
}
