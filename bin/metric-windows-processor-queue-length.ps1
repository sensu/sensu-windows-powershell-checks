#
#   metric-windows-processor-queue-length.ps1
#
# DESCRIPTION:
#   This plugin collects and outputs the Processor Queue Length in a Graphite acceptable format.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\metric-windows-processor-queue-length.ps1
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

$Value = (Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_System).ProcessorQueueLength
$Time = ConvertTo-Unixtime -DateTime (Get-Date)

Write-Host "$Path.cpu.queue_length $Value $Time"
