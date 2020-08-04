# sensu-windows-powershell-checks
Collection of Windows Powershell checks for Sensu

### check-windows-http.ps1

#### Help
```
> check-windows-http.ps1 -?
NAME
    check-windows-http.ps1
    
SYNOPSIS
    This plugin checks availability of url provided as param. Optionally checks if substring exists in url content
    
SYNTAX
    check-windows-http.ps1 [-CheckAddress] <String> [[-ContentSubstring] <String>] [<CommonParameters>]
```

#### Param 1: CheckAddress
Required. Use valid http or https URL ex:  `https://sensu.io`

#### Param 2: ContentSubString
Optional. Substring to match inside returned URL content.

#### Asset command example
```
Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -Command check-windows-http.ps1  https://sensu.io monitoring
```

### check-windows-disk.ps1

#### Help
```
> check-windows-event-disk.ps1 -?
NAME
    check-windows-disk.ps1
    
SYNOPSIS
    This plugin collects the Disk Usage and and compares against the WARNING and CRITICAL thresholds.
    
    
SYNTAX
    check-windows-disk.ps1 [-WARNING] <Int32> [-CRITICAL] <Int32> [[-IGNORE] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    This plugin collects the Disk Usage and and compares against the WARNING and CRITICAL thresholds.

```

#### Param 1: Warning
    Required. Warning disk usage percentage threshold.
    Example -Warning 90

#### Param 2: Critical
    Required. Critical disk usage percentage threshold.
    Example -Critical 95

#### Param 3: Ignore
    Optional. DeviceID regular expression to ignore.

#### Asset command usage
Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -Command check-windows-disk.ps1 90 95


### check-windows-event-log.ps1

#### Help
```
> check-windows-event-log.ps1 -?

NAME
    check-windows-event-log.ps1
    
SYNOPSIS
    Returns all occurances of pattern in log file
    
    
SYNTAX
    check-windows-event-log.ps1 [-LogName] <String> [-Pattern] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Checks Event log for pattern and returns the number criticals and warnings that match that pattern.
```

#### Param 1: LogName
    Required. The name of the log file.
    Example -LogName Application

#### Param 2: Pattern
    Required. The pattern you want to search for.
    Example -LogName Application -Pattern error

#### Asset command usage
Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -Command check-windows-event-log.ps1 -LogName Application -Pattern error


### check-windows-disk-writeable.ps1

#### Help
```
> check-windows-event-disk-writeable.ps1 -?
NAME
    check-windows-disk-writeable.ps1
    
SYNOPSIS
    This plugin collects the mounted logical disks and tests they are writeable.
    
    
SYNTAX
    check-windows-disk-writeable.ps1 [[-DriveType] <String>] [[-Ignore] <String>] 
      [[-TestFile] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    This plugin collects the mounted logical disks and tests they are writeable.

```

#### Param 1: DriveType
    Optional. DriveType,
    see available options at https://msdn.microsoft.com/en-us/library/windows/desktop/aa364939(v=vs.85).aspx
    Specify multiple values as a comma separated string, e.g. "3,5"
#### Param 2: Ignore
    Optional. Disk letters to ignore
    Specify multiple values as a comma separated string, e.g. "C,D"
#### Param 3: TestFile
    Optional. Test file to create on each disk to test it is writeable

#### Asset command usage
Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -Command check-windows-disk-writeable.ps1 -DriveType "3,5" -Ignore "A,B" -TestFile '\test.txt'


### check-windows-directory.ps1

#### Help
```
> check-windows-event-disk-directory.ps1 -?
NAME
    check-windows-directory.ps1
    
SYNOPSIS
    Checks if  directory exist
    
    
SYNTAX
    check-windows-directory.ps1 [-Dir] 
    <String> [<CommonParameters>]
    
    
DESCRIPTION
    Checks if directory exist

```

#### Param 1: Dir
    Required. The name of the directory.
    Example -Dir C:\Users\dir


#### Asset command usage
Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -Command check-windows-directory.ps1 -Dir C:\Users\dir


### check-windows-cpu-load.ps1

#### Help
```
> check-windows-event-disk-cpu-load.ps1 -?
NAME
    check-windows-cpu-load.ps1
    
SYNOPSIS
    This plugin collects the CPU Usage and compares against the WARNING and CRITICAL thresholds.
    
    
SYNTAX
    check-windows-cpu-load.ps1 [-WARNING] 
    <Int32> [-CRITICAL] <Int32> [<CommonParameters>]

```

#### Param 1: Warning
    Required. Warning cpu load percentage threshold

#### Param 1: Critical
    Required. Critical cpu load percentage threshold


#### Asset command usage
Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -Command check-windows-cpu-load.ps1 90 95




