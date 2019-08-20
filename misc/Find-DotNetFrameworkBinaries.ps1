<#
.SYNOPSIS
    This function list all binaries that are using .Net Framework

    Author: Paul Laîné (@am0nsec)
    License: None 
    Required Dependencies: PowerShellArsenal
    Optional Dependencies: None

.PARAMETER Location
    The location to probe

.EXAMPLE
    Find-DotNetFrameworkBinaries -Location $env:windir\System32\*.exe
    This shows the list all EXE that are using .Net Framework under %windir%\System32\

.OUTPUTS
    None
    No return value
#>
function Find-DotNetFrameworkBinaries {
        Param(
        [parameter(Mandatory=$true)]
        [string]$Location
    )

    Write-Host "[*] Paul Laîné (@am0nsec)"
    Write-Host "[*] List all binaries that are using .Net Framework`n"

    If ($null -eq (Get-Module PowerShellArsenal)) {
        Try {
            Import-Module PowerShellArsenal -ErrorAction Stop
        } Catch {
            Write-Host "[-] PowerShellArsenal module not found!"
            exit 1
        }
    }

    $pes = Get-ChildItem $Location -Recurse -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Get-PE -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    Foreach ($pe in $pes) {
        $imports = ($pe.Imports | Select-Object ModuleName | Get-Unique -AsString).ModuleName
        Foreach ($module in $imports) {
            if ($module -match "^mscor(.)+\.dll" -or $module -match "^clr\.dll$") {
                $pe.ModuleName
                break
            }
        }
    }
}
