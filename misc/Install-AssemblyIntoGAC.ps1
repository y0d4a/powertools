#Requires -RunAsAdministrator

function Install-AssemblyIntoGAC {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [string]$Location
    )

    Write-Host "[*] Install strong-name assembly into GAC"
    Write-Host ""

    # Load the assembly
    $assembly = [System.Reflection.Assembly]::LoadFrom($Location)
    $information = ($assembly.FullName) -split ", "
    $runtimeVersion = $assembly.ImageRuntimeVersion
    $exportedType = $assembly.ExportedTypes

    # Get the basic inforamtion used to install the assembly into the GAC
    $assembyName = $information[0]
    $version = ($information[1] -split "=")[1]
    $culture = ($information[2] -split "=")[1]
    $publickey = ($information[3] -split "=")[1]

    if ($publickey -eq $null) {
        Write-Host "[-] The assembly is not strong-name"
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
    Write-Host "[*] .Net Framework < 4.0 path: $firstPath"
    Write-Host "[*] .Net Framework >= 4.0 path: $secondPath"
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
    Write-Host "[*] .Net Framework < 4.0 folder: $firstPath"
    Write-Host "[*] .Net Framework >= 4.0 folder: $secondPath"
    Write-Host ""

    # Move the DLL into the created folder
    Copy-Item -Path $Location -Destination $firstPath
    Copy-Item -Path $Location -Destination $secondPath
    
    $asm = "$assembyName, Version=$version, Culture=$culture, PublicKeyToken=$publickey" 
    Write-Host "[*] COMPLUS_Version="$runtimeVersion
    Write-Host "[*] APPDOMAIN_MANAGER_ASM="$asm
    Write-Host "[*] APPDOMAIN_MANAGER_TYPE="$exportedType

}
