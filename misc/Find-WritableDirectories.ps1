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