#
#   metric-windows-ram-usage.ps1
#
# DESCRIPTION:
#   This plugin collects and outputs the Ram Usage in a Graphite acceptable format.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\metric-windows-ram-usage.ps1
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#
param(
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

$Memory = (Get-CimInstance -ClassName Win32_OperatingSystem)
$FreeMemory = $Memory.FreePhysicalMemory
$TotalMemory = $Memory.TotalVisibleMemorySize
$UsedMemory = $TotalMemory - $FreeMemory

$Value = [System.Math]::Round(((($TotalMemory - $FreeMemory) / $TotalMemory) * 100), 2)
$Time = ConvertTo-Unixtime -DateTime (Get-Date)

Write-host "$Path.memory.free $FreeMemory $Time"
Write-host "$Path.memory.total $TotalMemory $Time"
Write-host "$Path.memory.used $UsedMemory $Time"
Write-host "$Path.memory.percent.used $Value $Time"
