<#
.SYNOPSIS
    Checks if  directory exist
.DESCRIPTION
    Checks if directory exist
.Notes
    FileName    : check-windows-directory.ps1
    Author      : Patrice White - patrice.white@ge.com
.LINK
    https://github.com/sensu-plugins/sensu-plugins-windows
.PARAMETER LogName
    Required. The name of the directory.
    Example -Dir C:\Users\dir
.EXAMPLE
    powershell.exe -file check-windows-directory.ps1 -Dir C:\Users\dir
#>

[CmdletBinding()]
Param(
  [Parameter(Mandatory = $True)]
  [string]$Dir
)

$ThisDir = Test-Path -Path $Dir

#Shows diretory if it exist
if ($ThisDir) {
  Write-Host "CheckDirectory OK: Directory exist"
  exit 0
}
else {
  Write-Host "CheckDirectory CRITICAL: Directory doesn't exist"
  exit 2
}
