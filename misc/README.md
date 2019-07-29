## Examples ##

### Find-DotNetFrameworkBinaries ###
```
PS C:\Windows\system32> Find-DotNetFrameworkBinaries -Location C:\Windows\System32\WindowsPowerShell\*.exe
[*] Paul Laîné (@am0nsec)
[*] List all binaries that are using .Net Framework

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
PS C:\Windows\system32>
```

### Find-WritableDirectories ###
```
PS C:\Windows\system32> Find-WritableDirectories -Location C:\Windows\System32\
[*] Paul Laîné (@am0nsec)
[*] List writable directories

C:\Windows\System32\FxsTmp
C:\Windows\System32\Tasks
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
PS C:\Windows\system32>
```