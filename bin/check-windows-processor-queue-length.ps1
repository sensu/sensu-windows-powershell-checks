<#
.SYNOPSIS
   This plugin collects the Processor Queue Length and compares against the WARNING and CRITICAL thresholds.
.DESCRIPTION
   This plugin collects the Processor Queue Length and compares against the WARNING and CRITICAL thresholds.
.Notes
    FileName    : check-windows-processor-queue-length.ps1
.PARAMETER Warning
    Required. Warning processor queue length threshold
.PARAMETER Critical
    Required. Critical processor queue length threshold
.EXAMPLE
    powershell.exe -file check-windows-processor-queue-length.ps1 5 10
#>

#
#   check-windows-processor-queue-length.ps1
#
# DESCRIPTION:
#   This plugin collects the Processor Queue Length and compares against the WARNING and CRITICAL thresholds.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-processor-queue-length.ps1 5 10
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
  [int]$WARNING = 5,

  [Parameter(Mandatory = $True, Position = 2)]
  [int]$CRITICAL = 10
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$Value = (Get-CimInstance -className Win32_PerfFormattedData_PerfOS_System).ProcessorQueueLength

if ($Value -gt $CRITICAL) {
  Write-Host "CheckWindowsProcessorQueueLength CRITICAL: Processor Queue at $Value."
  exit 2
}

if ($Value -gt $WARNING) {
  Write-Host "CheckWindowsProcessorQueueLength WARNING: Processor Queue at $Value."
  exit 1
}

else {
  Write-Host "CheckWindowsProcessorQueueLength OK: Processor Queue at $Value."
  exit 0
}
