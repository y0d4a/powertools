Write-Host "[*] Paul Laîné (@am0nsec)"
Write-Host "[*] List all binaries that are using .Net Framework`n"

Try {
    Import-Module PowerShellArsenal
} catch {
    Write-Host "[-] PowerShellArsenal module not found!"
    exit
}


$pes = Get-ChildItem C:\*.exe -Recurse -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Get-PE
Foreach ($pe in $pes) {
    $imports = ($pe.Imports | select ModuleName | Get-Unique -AsString).ModuleName
    Foreach ($module in $imports) {
        if ($module -match "^mscor(.)+\.dll" -or $module -match "^clr\.dll$") {
            $pe.ModuleName
            break
        }
    }
}