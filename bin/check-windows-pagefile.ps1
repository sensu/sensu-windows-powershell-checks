<#
.SYNOPSIS
   This plugin collects the Pagefile Usage and compares against the WARNING and CRITICAL thresholds.
.DESCRIPTION
   This plugin collects the Pagefile Usage and compares against the WARNING and CRITICAL thresholds.
.Notes
    FileName    : check-windows-pagefile.ps1
.PARAMETER Warning
    Required. Warning pagefile usage percentage threshold
.PARAMETER Critical
    Required. Critical pagefile user percentage threshold
.EXAMPLE
    powershell.exe -file check-windows-pagefile.ps1 75 85
#>

#
#   check-windows-pagefile.ps1
#
# DESCRIPTION:
#   This plugin collects the Pagefile Usage and compares against the WARNING and CRITICAL thresholds.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\opt\\sensu\\plugins\\check-windows-pagefile.ps1 75 85
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
  [Parameter(Position = 1)]
  [int]$WARNING = 70,

  [Parameter(Position = 2)]
  [int]$CRITICAL = 80
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

[int]$pagefileAllocated = (Get-CimInstance -classname Win32_PageFileUsage).AllocatedBaseSize
[int]$pagefileCurrentUsage = (Get-CimInstance -classname Win32_PageFileUsage).CurrentUsage

[int]$Value = ($pagefileCurrentUsage / $pagefileAllocated) * 100

if ($Value -gt $CRITICAL) {
  Write-Host "CheckWindowsPagefile CRITICAL: Pagefile usage at $Value%."
  exit 2
}

if ($Value -gt $WARNING) {
  Write-Host "CheckWindowsPagefile WARNING: Pagefile usage at $Value%."
  exit 1
}

else {
  Write-Host "CheckWindowsPagefile OK: Pagefile usage at $Value%."
  exit 0
}
