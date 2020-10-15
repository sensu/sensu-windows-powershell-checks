<#
.SYNOPSIS
   This plugin checks whether a User-inputted process is running with too many or too few instances.

.DESCRIPTION
   This plugin checks whether a User-inputted process is running with too many or too few instances.
   Per-default this checks whether or not the process is running (Crit if running processes is 0)

   Inspired by: https://github.com/sensu-plugins/sensu-plugins-process-checks/blob/master/bin/check-process.rb

.Notes
    FileName    : check-windows-process.ps1

.PARAMETER ProcessName
    Required.  User process name to check.

.PARAMETER WarnOver
    Optional.  Warn if matching process count is over specified amount. Set to 0 to disable

.PARAMETER CritOver
    Optional.  Crit if matching process count is over specified amount. Set to 0 to disable

.PARAMETER WarnUnder
    Optional.  Warn if matching process count is under specified amount. Set to 0 to disable

.PARAMETER CritUnder
    Optional.  Crit if matching process count is under specified amount. Set to 0 to disable

.EXAMPLE
    powershell.exe -file check-windows-process.ps1 powershell
#>

#
#   check-windows-process.ps1
#
# DESCRIPTION:
#   This plugin checks whether a User-inputted process is running or not.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-process.ps1
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
  [string]
  $ProcessName,

  # Trigger a warning of over a number
  [Parameter()]
  [int]
  $WarnOver = 0,

  # Trigger a critical of over a number
  [Parameter()]
  [int]
  $CritOver = 0,

  # Trigger a warning of under a number
  [Parameter()]
  [int]
  $WarnUnder = 1,

  # Trigger a critical of under a number
  [Parameter()]
  [int]
  $CritUnder = 1
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$Processes = Get-Process $ProcessName -ErrorAction SilentlyContinue

if ($CritUnder -ne 0 -And $Processes.Count -lt $CritUnder) {
  Write-Host "CRITICAL: Found $($Processes.Count) matching processes"
  exit 2
}
elseif ($WarnUnder -ne 0 -And $Processes.Count -lt $WarnUnder) {
  Write-Host "WARNING: Found $($Processes.Count) matching processes"
  exit 1
}
elseif ($CritOver -ne 0 -And $Processes.Count -gt $CritOver) {
  Write-Host "CRITICAL: Found $($Processes.Count) matching processes"
  exit 2
}
elseif ($WarnOver -ne 0 -And $Processes.Count -gt $WarnOver) {
  Write-Host "WARNING: Found $($Processes.Count) matching processes"
  exit 1
}
else {
  Write-Host "OK: Found $($Processes.Count) matching processes"
  exit 0
}
