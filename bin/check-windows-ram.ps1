<#
.SYNOPSIS
   This plugin collects the RAM Usage and compares against the WARNING and CRITICAL thresholds.
.DESCRIPTION
   This plugin collects the RAM Usage and compares against the WARNING and CRITICAL thresholds.
.Notes
    FileName    : check-windows-ram.ps1
.PARAMETER Warning
    Required. Warning ram usage percentage threshold
.PARAMETER Critical
    Required. Critical ram usage percentage threshold
.EXAMPLE
    powershell.exe -file check-windows-ram.ps1 90 95
#>

#
#   check-windows-ram.ps1
#
# DESCRIPTION:
#   This plugin collects the RAM Usage and compares against the WARNING and CRITICAL thresholds.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-ram.ps1 90 95
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
  [int]$CRITICAL = 90
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$Memory = (Get-CimInstance -ClassName Win32_OperatingSystem)

$Value = [System.Math]::Round(((($Memory.TotalVisibleMemorySize - $Memory.FreePhysicalMemory) / $Memory.TotalVisibleMemorySize) * 100), 2)

if ($Value -ge $CRITICAL) {
  Write-Host "CheckWindowsRAMLoad CRITICAL: RAM at $Value%."
  exit 2
}
elseif ($Value -ge $WARNING) {
  Write-Host "CheckWindowsRAMLoad WARNING: RAM at $Value%."
  exit 1
}
else {
  Write-Host "CheckWindowsRAMLoad OK: RAM at $Value%."
  exit 0
}
