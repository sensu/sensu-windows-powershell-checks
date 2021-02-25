<#
.SYNOPSIS
    Returns all occurrences of pattern in log file, using a StreamReader

    This check only loads a single line of text at a time into the memory.
    This makes the script way less memory intense, and faster on large logs.
    It also keeps track of where the log was last read, to not re-read logs.
.DESCRIPTION
    Checks log file for pattern and returns the number of times the pattern was found.
.Notes
    FileName    : check-windows-logstream.ps1
    Author      : Magnus Larsen github.com/magnuslarsen
.LINK
    https://github.com/sensu/sensu-windows-powershell-checks
.PARAMETER LogPath
    Required. The name of the log file.
    Example: `-LogPath example.log`
.PARAMETER Pattern
    Required. The pattern you want to search for.
    Example `-Pattern "Error code 2"`
.PARAMETER MetadataFile
    Optional. The file where to store the amount of read bytes (has to be unique per check)
    Example `-MetadataFile "C:\temp\check-logstream-errorcode2.txt"
.PARAMETER Regex
    Optional. Marks the pattern as a Regurlar Expression
.PARAMETER CaseSensitive
    Optional. Marks the pattern as case sensitive
.EXAMPLE
    powershell.exe -file check-windows-logstream.ps1 -LogPath C:\ProgramData\Logs\example1.log -Pattern "Exception caught"
    powershell.exe -file check-windows-logstream.ps1 -LogPath C:\ProgramData\Logs\example2.log -Pattern "Exception\[\w*\]$" -Regex
#>

[CmdletBinding()]
Param(
  [Parameter(Mandatory = $True)]
  [string]$LogPath,

  [Parameter(Mandatory = $True)]
  [string]$Pattern,

  [string]$MetadataFile = "$($Env:ProgramData)\Sensu\cache\check-logstream.txt",

  [switch]$Regex = $false,
  [switch]$CaseSensitive = $false
)

if (Test-Path $MetadataFile) {
  $PreviousReadBytes = [int]$(Get-Content -Path $MetadataFile)
}
else {
  $PreviousReadBytes = 0
}

# If the file size is less than what was previously read, reset
if ((Get-Item -Path $LogPath).Length -lt $PreviousReadBytes) {
  $PreviousReadBytes = 0
}

$CurrentReadBytes = 0
$NumMatches = 0

try {
  $StreamReader = New-Object System.IO.StreamReader $LogPath
  $StreamReader.BaseStream.Seek($PreviousReadBytes, [System.IO.SeekOrigin]::Begin) | Out-Null
}
catch {
  Write-Host "CheckLog UNKNOWN: $_"
  exit 3
}

while ($null -ne ($Line = $StreamReader.ReadLine())) {
  $CurrentReadBytes += [System.Text.Encoding]::UTF8.GetByteCount($Line)

  if ($Line | Select-String -Quiet -SimpleMatch:$(!$Regex) -CaseSensitive:$CaseSensitive -Pattern $Pattern) {
    $NumMatches++
  }
}

# Close the stream
$StreamReader.Close()

# Write how far has been read
$NewPosistion = $PreviousReadBytes + $CurrentReadBytes
Set-Content -Path $MetadataFile -Value $NewPosistion

if ($NumMatches -gt 0) {
  Write-Host "CheckLog CRITICAL: The pattern was found $($NumMatches) times"
  exit 2
}
else {
  Write-Host "CheckLog OK: The pattern was not found"
  exit 0
}
