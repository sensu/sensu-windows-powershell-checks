#
#   metric-windows-counter.ps1
#
# DESCRIPTION:
#   This plugin collects and outputs any specified counter in a Graphite acceptable format.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\metric-windows-counter.ps1 `
#   -CounterPath "\Windows Time Service\Computed Time Offset" -Measurement "ntp_offset"
#
#   Above will output `my_hostname.system.ntp_offset $value $timestamp`
#
#   `-Measurement` is required, and can be any string of characters and underscores.
#
# NOTES:
#   You can find counter paths by choosing a single CounterSetName:
#     `Get-Counter -ListSet * | Sort -Property CounterSetName | Select -Property CounterSetName, Paths | Format-Table -AutoSize`
#   and chosing a path from that list:
#     `Get-Counter -ListSet "Windows Time Service" | Select -ExpandProperty Paths`
#
# LICENSE:
#   Copyright 2016 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#

param(
  [string] $Scheme = "$(($env:computername).ToLower()).system",
  [parameter(Mandatory = $True)] [string] $Measurement,
  [parameter(Mandatory = $True)] [string] $CounterPath
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

. (Join-Path $PSScriptRoot perfhelper.ps1)

try {
  $Counter = Get-Counter -SampleInterval 1 -MaxSamples 1 -Counter $CounterPath -ErrorAction 'Stop'
}
catch {
  Write-Host "UNKNOWN: $_"
  exit 2
}

$Timestamp = ConvertTo-UnixTime -DateTime (Get-Date)
$Metric = $Counter.CounterSamples[0].CookedValue

Write-Host "$($Scheme).$($Measurement) $($Metric) $($Timestamp)"

# OK
exit 0
