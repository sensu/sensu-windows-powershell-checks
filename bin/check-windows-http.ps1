<#
.SYNOPSIS 
    This plugin checks availability of url provided as param. Optionally checks if substring exists in url content 
.DESCRIPTION
    This plugin checks availability of link provided as param. Optionally checks if substring exists in url content 
.Notes
    FileName    : check-windows-http.ps1
    Author      : Patrice White - patrice.white@ge.com
.PARAMETER CheckAddress 
    Required. Url string to check.
    Example -CheckAddress https://sensu.io
.PARAMETER ContentSubstring
    Optional. Substring to match inside returned URL content.
    Example -CheckAddress https://sensu.io -ContentSubstring monitoring
.EXAMPLE
    powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -Command check-windows-http.ps1 https://sensu.io monitoring
#>

#   check-windows-http.ps1
#
# DESCRIPTION:
#   This plugin checks availability of link provided as param
#   Optionally checks if substring exists in url content 
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-http.ps1 https://google.com  "optional substring to match"
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
  [Parameter(Mandatory=$True,Position=1)]
   [string]$CheckAddress,
  [Parameter(Mandatory=$False,Position=2)]
   [string]$ContentSubstring
)

$global:ProgressPreference = "SilentlyContinue"
$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

try {
  $Available = Invoke-WebRequest -UseBasicParsing $CheckAddress -ErrorAction SilentlyContinue
}

catch {
  $errorhandler = $_.Exception.request
}

if (!$Available) {
  Write-Host CRITICAL: Could not connect  $CheckAddress!
  Exit 2 
}

if ($Available) {
   if ($Available.statuscode -eq 200) {
      if ($ContentSubstring) {
        $output=$Available.ToString()
        $result = $output -match $ContentSubstring
        if ($result) {
          Write-Host OK: $CheckAddress is available and Content contains $ContentSubstring
          Exit 0
        } else {
          Write-Host CRITICAL: $CheckAddress is available but Content does not contain $ContentSubstring
          Exit 2
        }
      } else {
        Write-Host OK: $CheckAddress is available!
        Exit 0
      }
   } else {
      Write-Host CRITICAL: URL $CheckAddress is not accessible!
      Exit 2
   }
}
