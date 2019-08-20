<#
.SYNOPSIS
    This function list all .Net object that are installed on the system

    Author: Paul Laîné (@am0nsec)
    License: None 
    Required Dependencies: None
    Optional Dependencies: None

.EXAMPLE
    Find-DotNetObjects
    This shows the list of installed .Net objects

.OUTPUTS
    None
    No return value
#>
function Find-DotNetObjects() {
    Write-Host "[*] Paul Laîné (@am0nsec)"
    Write-Host "[*] List all .Net object that are installed on the system`n"
    
    $items = Get-ChildItem HKLM:\SOFTWARE\Classes -ErrorAction SilentlyContinue
    $items = $items | Where-Object { $_.PSChildName -match "^\w+\.\w+$" -and (Test-Path -Path "$($_.PSPath)\CLSID") }

    foreach ($item in $items) {
        $item | Select-Object -ExpandProperty PSChildName
    }
}
