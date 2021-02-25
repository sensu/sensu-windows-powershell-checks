#
#   metric-windows-pagefile.ps1
#
# DESCRIPTION:
#   This plugin collects the Pagefile Usage and outputs in a Graphite acceptable format.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\opt\\sensu\\plugins\\metric-windows-pagefile.ps1
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#

#Requires -Version 3.0

param(
  [switch]$UseFullyQualifiedHostname,
  [string]$Scheme = ($env:computername).ToLower()
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

. (Join-Path $PSScriptRoot perfhelper.ps1)

if ($UseFullyQualifiedHostname) {
  $Path = [System.Net.Dns]::GetHostEntry([string]"localhost").HostName.toLower()
}
else {
  $Path = $Scheme
}

$PageFiles = Get-CimInstance -classname Win32_PageFileUsage

ForEach ($PageFile in $PageFiles) {
  $Name = $PageFile.Name -replace '\\', '' -replace ':', '_' -replace '\.', '_'
  [int]$pagefileAllocated = $PageFile.AllocatedBaseSize
  [int]$pagefileCurrentUsage = $PageFile.CurrentUsage

  [int]$Value = ($pagefileCurrentUsage / $pagefileAllocated) * 100
  $Time = ConvertTo-Unixtime -DateTime (Get-Date)

  Write-Host "$Path.system.pagefile.$($Name).used_percent $Value $Time"
}
