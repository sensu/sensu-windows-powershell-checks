# sensu-windows-powershell-checks
Collection of Windows Powershell checks for Sensu

### check-windows-http.ps1

#### Help
```
> check-windows-http.ps1 -?
check-windows-http.ps1 [-CheckAddress] <string> [[-ContentSubstring] <string>] [<CommonParameters>]
```

#### Param 1: CheckAddress
Required: Use valid http or https URL ex:  `https://sensu.io`

#### Param 2: ContentSubString
Optional: Substring to match inside returned URL content.


