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
  [string[]]
  $ServiceName,

  # Whether to keep disabled services or not
  [Parameter()]
  [switch]
  $KeepDisabledServices
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$Services = Get-Service $ServiceName -ErrorAction SilentlyContinue

if (!$KeepDisabledServices) {
  $Services = $Services | Where-Object { $_.StartType -ne 'Disabled' }
}

if ($Services.Count -eq 0) {
  Write-Host "UNKNOWN: Found 0 matching services"
  exit 3
}
elseif ($Services.Count -eq ($Services.Status -eq 'Running').Count) {
  Write-Host "OK: All $($Services.Count) matching service(s) are running"
  exit 0
}
else {
  $StoppedServices = $Services | Where-Object { $_.Status -ne 'Running' }

  Write-Host "CRITICAL: Found $($StoppedServices.Count) matching non-running service(s): $($StoppedServices.Name -join ', ')"
  exit 2
}
