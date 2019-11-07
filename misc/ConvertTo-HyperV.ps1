#Requires -RunAsAdministrator
<#
.synopsis
    Help converting a VMWare virtual disk (VMDK) into a Hyper-V virtual disk (VHDX)

    Author: Paul Laîné (@am0nsec)
    License: None 
    Required Dependencies: Microsoft Virtual Machine Converter
    Optional Dependencies: None

.parameter FileName
    The VMDK file to modify

.example 
    ConvertTo-HyperV -FileName C:\MyVMs\LinuxVM\LinuxVirtualDisk.vmdk
    Will convert LinuxVirtualDisk.vmdk into LinuxVirtualDisk.vhdx

.outputs
    None
    No return value
#>
function ConvertTo-HyperV {
    param (
        [Parameter(Mandatory=$true)]
        [string] $FileName
    )

    # Check if the file exist
    $FileName = (Resolve-Path $FileName).Path
    if (!([System.IO.File]::Exists($FileName))) {
        Write-Host "[-] File does not exist"
        return
    }

    # Check if MVMC is installed
    [string] $path = "$env:HOMEDRIVE\\Program Files\\Microsoft Virtual Machine Converter\\MvmcCmdlet.psd1"
    if ([System.IO.File]::Exists($path)) {
        Write-Host "[*] Microsoft Virtual Machine Converter installed!"
        Import-Module -Force $path
    } else {
        Write-Host "[-] Download Microsoft Virtual Machine Converter 3.0 here:"
        Write-Host "`thttps://www.microsoft.com/en-us/download/details.aspx?id=42497"
        return
    }

    # Check if there is multiple disk that need to be merged
    [string] $directory = Split-Path -Path $FileName
    [int] $nbFiles = (Get-ChildItem -Path $directory -Filter "*.vmdk" | Measure-Object).Count
    if ($nbFiles -gt 1) {
        Write-Host "[*] Multiple VMDK files needs to be merged"

        [string] $vmWareToolPath = "C:\\Program Files (x86)\\VMware\\VMware Workstation\\vmware-vdiskmanager.exe"
        if (!([System.IO.File]::Exists($vmWareToolPath))) {
            Write-Host "[-] You need VMWare Virtual Disk Manager"
            return
        }

        try {
            $FileName = "Merged$FileName"
            & "vmWareToolPath" -r $resolvedFilePath -t 0 $FileName
        } catch [System.Exception] {

        }
        Write-Host "[*] VMDK files merged"
    } else {
        Write-Host "[*] Only one VMDK file found"
    }

    Write-Host "[*] Start converting the VMDK file"
    [string] $destinationLiteralPath = Split-Path -Path $FileName
    ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath $FileName -VhdType DynamicHardDisk -VhdFormat Vhdx -DestinationLiteralPath $destinationLiteralPath
    Write-Host "[+] File successfully converted to VHDX"
}
# SIG # Begin signature block
# MIIFggYJKoZIhvcNAQcCoIIFczCCBW8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUTDVu0wdLSAya2WLgJABxS4iC
# DTqgggMWMIIDEjCCAfqgAwIBAgIQFhTimbpgBo1GZXK9Omd7WzANBgkqhkiG9w0B
# AQsFADAhMR8wHQYDVQQDDBZGcm9tIGFtMG5zZWMgV2l0aCBMb3ZlMB4XDTE5MTEw
# NjIwNTYzM1oXDTIwMTEwNjIxMTYzM1owITEfMB0GA1UEAwwWRnJvbSBhbTBuc2Vj
# IFdpdGggTG92ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAO+BAk1c
# px/QcSY7pyOp4QvNROSb2iJeR8Le3L2vN6hwL0/vqYeQ/jcvYFBSdrFwgsJo+tXU
# ZHVRI/DF6kLoUj0VxrvZ27xNbOD2p4yOR2SHbXmnFiyw/2qhhgSFn5UeXe8ZqnhC
# Z7C3bRkRBM4Yh2gDOW4HknbppiJ4s6lu56vz1aHS4BTE19YkyLtjjx1/UI9UDMFc
# X7tiWf6pqIxvw1qgujDa6J2pUsUmhJzqVjdaD/PjZg5FF83HamhgcGEHStFCJrrm
# g0KXuSRH7NpmQh/AdpCa6+4REhpbi11S/4NNiDE+GG0M3byJnBRiDeOfrgviAQE8
# Xvs8ZXyAdH6kHNECAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoG
# CCsGAQUFBwMDMB0GA1UdDgQWBBRQOHYzNUD+oKsJAY26wKpd9Y5AZzANBgkqhkiG
# 9w0BAQsFAAOCAQEAGM/veKW+ty59WX35Lp2FC7+jeXfFxwGun/sD147/CyLclOLE
# 8VA5esMHMW41F7+6baxB4tAiqJ798c07B/20pK0jBGgHA3BAZ+3LgLIl16w83JX1
# bK+J/R4NBKh9Bx2ggiCtkO8skKmCGG6Bi+ZceRfqGh00mU8m6ThpkCxU4cCrpFyl
# hzfBavYZ+HU2YkidE1Xw9aUFcXebJkZQjM5z1J31ZULnyarcux5Oi1A/FnDHd6o5
# 9atQRPSMV/Feb8RC/8D/6UcHl+KpiR8DTv4d4niQO9fkFlzujjOanP/eHJoRPP9T
# sfy0+xECbuT7Y+BoaalUJbo/9H+vUBeVlWGrPzGCAdYwggHSAgEBMDUwITEfMB0G
# A1UEAwwWRnJvbSBhbTBuc2VjIFdpdGggTG92ZQIQFhTimbpgBo1GZXK9Omd7WzAJ
# BgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0B
# CQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAj
# BgkqhkiG9w0BCQQxFgQUCsEywwprTvZkJesEy0MkjnxLsgowDQYJKoZIhvcNAQEB
# BQAEggEAfJZChUuvkzT4PqZC2XGxcpCOO8T97rAqMriQP/fAMUWMt3rKf9eNnyFF
# vHD876IqKmMNAdKnsoxtGxp7joxSNPSuj81CL96Uo9+fJuT0gtGDkeae8ASgKzIi
# RrdxhxNNNIBaFpXxIlPcxT1lhugK3EoKiwgrSqZ1SRL21+XY9hhoAUh3KHmNRWQj
# tjw0iIgjkegY0hn+i0ZLg/dUyMh8CrpgcLZ7cGYvpauXZcgbP7iSVvz9mVoxzA60
# blkfgByy/tLvz/qtaRku7ApMeTkYLAC/5YYVANhd2SAj+YiaQoB5ppVw1F6h+9dB
# vXO0E6NCFu71x/MEwJE7FU6Yt7pJ2Q==
# SIG # End signature block
