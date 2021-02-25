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

$WarningPages = [System.Collections.ArrayList]@()
$CriticalPages = [System.Collections.ArrayList]@()

$PageFiles = Get-CimInstance -classname Win32_PageFileUsage

ForEach ($PageFile in $PageFiles) {
  [int]$pagefileAllocated = $PageFile.AllocatedBaseSize
  [int]$pagefileCurrentUsage = $PageFile.CurrentUsage
  [int]$Value = ($pagefileCurrentUsage / $pagefileAllocated) * 100

  if ($Value -gt $CRITICAL) {
    $CriticalPages.Add("Pagefile '$($PageFile.Name)' is above critical threshold: $($Value)%") | Out-Null
  }
  elseif ($Value -gt $WARNING) {
    $WarningPages.Add("Pagefile '$($PageFile.Name)' is above warning threshold: $($Value)%") | Out-Null
  }
}

if ($WarningPages.Count + $CriticalPages.Count -eq 0) {
  Write-Host "All pagefiles are within thresholds"
  exit 0
}

if ($CriticalPages.Count -gt 0) {
  Write-Host $($CriticalPages -join "`n")
}
if ($WarningPages.Count -gt 0) {
  Write-Host $($WarningPages -join "`n")
}

if ($CriticalVolumes.Count -gt 0) {
  exit 2
}
else {
  exit 1
}
