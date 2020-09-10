#
#   metric-windows-network.ps1
#
# DESCRIPTION:
#   This plugin collects and outputs all Network Adapater Statistic in a Graphite acceptable format.
#
# OUTPUT:
#   metric data
#
# PLATFORMS:
#   Windows
#
# DEPENDENCIES:
#   Powershell
#
# USAGE:
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\metric-windows-network.ps1
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#

param(
  [string[]]$Interfaces,
  [switch]$ListInterfaces,
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

$perfCategoryID = Get-PerformanceCounterByID -Name 'Network Interface'
if ($perfCategoryID.Length -eq 0) {
  Write-Host "perfCategoryID: is Null"
  exit 2
}
$localizedCategoryName = Get-PerformanceCounterLocalName -ID $perfCategoryID

for ($i = 0; $i -lt $Interfaces.Count; $i += 1) {
  $tmp = $Interfaces[$i]
  $Interfaces[$i] = $tmp.Replace(" ", "_")
}

if ($ListInterfaces -eq $true) {
  Write-Host "List of Available Interface Names"
  Write-Host "Full Name :: Underscore Modified Name"
  Write-Host "-------------------------------------"
}
ForEach ($ObjNet in (Get-Counter -Counter "\$localizedCategoryName(*)\*").CounterSamples) {
  $instanceName = $ObjNet.InstanceName.ToString().Replace(" ", "_")
  if ($ListInterfaces -eq $true) {
    $str = $ObjNet.InstanceName.ToString()
    Write-Host "$str :: $instanceName"
    Break
  }

  $include = $false
  if ($Interfaces.Count -eq 0) {
    $include = $true
  }
  else {
    if ($Interfaces.Contains($instanceName)) {
      $include = $true
    }
  }

  if ($include -eq $true) {
    $Measurement = ($ObjNet.Path).Trim("\\") -replace "\\", "." -replace " ", "_" -replace "[(]", "." -replace "[)]", "" -replace "[\{\}]", "" -replace "[\[\]]", ""

    $Measurement = $Measurement.Remove(0, $Measurement.IndexOf(".") + 1)
    $Measurement = $Measurement.Replace("/sec", "_per_second")
    $Measurement = $Measurement.Replace("/s", "_per_second")
    $Measurement = $Measurement.Replace(":", "")
    $Measurement = $Measurement.Replace(",", "")
    $Measurement = $Measurement.Replace("�", "ae")
    $Measurement = $Measurement.Replace("�", "oe")
    $Measurement = $Measurement.Replace("�", "ue")
    $Measurement = $Measurement.Replace("�", "ss")

    $Value = [System.Math]::Round(($ObjNet.CookedValue), 0)
    $Time = ConvertTo-Unixtime -DateTime (Get-Date)

    Write-Host "$Path.$Measurement $Value $Time"

  }
}
