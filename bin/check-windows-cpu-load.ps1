<#
.SYNOPSIS
   This plugin collects the CPU Usage and compares against the WARNING and CRITICAL thresholds.
.DESCRIPTION
   This plugin collects the CPU Usage and compares against the WARNING and CRITICAL thresholds.
.Notes
    FileName    : check-windows-cpu-load.ps1
.PARAMETER Warning
    Required. Warning cpu load percentage threshold
.PARAMETER Critical
    Required. Critical cpu load percentage threshold
.EXAMPLE
    powershell.exe -file check-windows-directory.ps1 90 95
#>

#
#   check-windows-cpu-load.ps1
#
# DESCRIPTION:
#   This plugin collects the CPU Usage and compares against the WARNING and CRITICAL thresholds.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-cpu-load.ps1 90 95
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
  [int]$WARNING = 80,

  [Parameter(Mandatory = $True, Position = 2)]
  [int]$CRITICAL = 100
)

. (Join-Path $PSScriptRoot perfhelper.ps1)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$perfCategoryID = Get-PerformanceCounterByID -Name 'Processor Information'
$perfCounterID = Get-PerformanceCounterByID -Name '% Processor Time'

$localizedCategoryName = Get-PerformanceCounterLocalName -ID $perfCategoryID
$localizedCounterName = Get-PerformanceCounterLocalName -ID $perfCounterID

$Value = [System.Math]::Round((Get-Counter "\$localizedCategoryName(_total)\$localizedCounterName" -SampleInterval 1 -MaxSamples 1).CounterSamples.CookedValue)

if ($Value -ge $CRITICAL) {
  Write-Host "CheckWindowsCpuLoad CRITICAL: CPU at $Value%."
  exit 2
}

if ($Value -ge $WARNING) {
  Write-Host "CheckWindowsCpuLoad WARNING: CPU at $Value%."
  exit 1
}

else {
  Write-Host "CheckWindowsCpuLoad OK: CPU at $Value%."
  exit 0
}
