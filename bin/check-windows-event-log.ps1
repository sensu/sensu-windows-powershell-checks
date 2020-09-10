<#
.SYNOPSIS
    Returns all occurances of pattern in log file
.DESCRIPTION
    Checks Event log for pattern and returns the number criticals and warnings that match that pattern.
.Notes
    FileName    : check-windows-event-log.ps1
    Author      : Patrice White - patrice.white@ge.com
.LINK
    https://github.com/sensu-plugins/sensu-plugins-windows
.PARAMETER LogName
    Required. The name of the log file.
    Example -LogName Application
.PARAMETER Pattern
    Required. The pattern you want to search for.
    Example -LogName Application -Pattern error
.PARAMETER CriticalLevel
    Optional. Integer Event Log Level to trigger Critical return status. Defaults to 2 = Error.
    Example -LogName Application -Pattern error -CriticalLevel 2
.PARAMETER WarningLevel
    Optional. Integer Event Log Level to trigger Warning return status.  Defaults to 3 = Warning.
    Example -LogName Application -Pattern error -WarningLevel 3
.EXAMPLE
    powershell.exe -file check-windows-log.ps1 -LogName Application -Pattern error
#>

[CmdletBinding()]
Param(
  [Parameter(Mandatory = $True)]
  [string]$LogName,
  [Parameter(Mandatory = $True)]
  [string]$Pattern,
  [Parameter(Mandatory = $False)]
  [int]$CriticalLevel = 2,
  [Parameter(Mandatory = $False)]
  [int]$WarningLevel = 3
)

#Search for pattern inside of File
$ThisEvent = Get-WinEvent $LogName -ErrorAction SilentlyContinue | Where-Object { $_.Message -like "*$($Pattern)*" }

if ($null -ne $ThisEvent) {
  $ThisEvent
}

#Counts the number of criticals and warnings
$CountCrits = ($ThisEvent | Where-Object { $_.Level -le $CriticalLevel }).count
$CountWarns = ($ThisEvent | Where-Object { $_.Level -le $WarningLevel }).count

#Prints count of how many ciritials and warnings
if ($CountCrits -eq 0 -And $CountWarns -eq 0) {
  Write-Host "CheckLog OK: pattern was not found"
  exit 0
}
elseif ($CountCrits -gt 0) {
  Write-Host "CheckLog CRITICAL: $CountCrits criticals"
  exit 2
}
else {
  Write-Host "CheckLog WARNING: $CountWarns warnings"
  exit 1
}
