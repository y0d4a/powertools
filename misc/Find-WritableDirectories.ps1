<#
.SYNOPSIS
    This function list all writable folders in a given location

    Author: Paul Laîné (@am0nsec)
    License: None 
    Required Dependencies: None
    Optional Dependencies: None

.PARAMETER Location
    The location to probe
    
.EXAMPLE
    Find-WritableDirectories
    This shows the list of all writable folders for a given location

.OUTPUTS
    None
    No return value
#>
function Find-WritableDirectories {
     Param(
        [parameter(Mandatory=$true)]
        [string]$Location
    )
    
    Write-Host "[*] Paul Laîné (@am0nsec)"
    Write-Host "[*] List writable directories`n"

    $directories = Get-ChildItem -Directory -Path $Location

    foreach ($dir in $directories) {
        $random = [System.IO.Path]::GetRandomFileName()
        $tmp = $dir.FullName + "\" + $random + ".txt"
    
        try {
            [System.IO.File]::WriteAllText($tmp, "test") | Out-Null
            Remove-Item -Path $tmp
            Write-Host $dir.FullName
        } catch { }
    }
}
