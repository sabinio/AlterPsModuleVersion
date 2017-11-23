
param(    
    $buildNumber,
    $file
)

Function Edit-ModuleVersionNumber {
    [cmdletbinding()]
    param(
        [ValidateNotNullOrEmpty()]
        $ModuleVersionNumber,
        [ValidateNotNullOrEmpty()]
        $psd1File
    )
    if ( $(Try { Test-Path $psd1File.trim() } Catch { $false }) ) {
        write-host "Path $psd1File OK"
    }
    Else {
        Write-Error "$psd1File does not exist!"
        Throw "psd1miss"
    }
    $extn = [IO.Path]::GetExtension($psd1File)
    if ($extn -ne ".psd1" ) {
        Write-Error "$psd1File is not a psd1 psd1File!"
        Throw "notapsd1"
    }
    $psd1FileName = Split-Path -Path $psd1File -Leaf
    Write-Host "$psd1FileName location is $psd1File"
    $regex = 'ModuleVersion(.*)'
    $ReturnValue = (@( Get-Content $psd1File | Where-Object { $_.Contains("ModuleVersion") } ).Count)
    if ($ReturnValue -eq 0) {
        Write-Error "ModuleVersionNumber element not found in $psd1FileName!"
        Throw "NoModuleVersionNumber"
    }
    $alphaRegex = "^(\d+\.)?(\d+\.)?(\*|\d+)$"
    $betaRegex = "^(\d+\.)?(\d+\.)?(\d+\.)?(\*|\d+)$" 
    if (($ModuleVersionNumber -match $alphaRegex) -eq $false) {
        if (($ModuleVersionNumber -match $betaRegex) -eq $false) {
            Write-Error "New ModuleVersion Number not in correct format; Expected ##.##.##(.##) , actual $semver"
            Throw "WrongFormat"
        }
    }
    Write-Host "ModuleVersionNumber in $psd1FileName will be altered to $ModuleVersionNumber."
    try {

        (Get-Content $psd1File) -replace $regex, "ModuleVersion = '$ModuleVersionNumber'" | Set-Content $psd1File
        [string]$updatedModuleVersion = Get-Content $psd1File | Where-Object { $_ -match "ModuleVersion" }
        $updatedModuleVersion = $updatedModuleVersion.Trim()
        Write-Host "Updated to $updatedModuleVersion"
        Return $updatedModuleVersion
    }
    catch {
        Write-Error "Something went wrong in trying to update ModuleNumber."
        Throw 0
    }
}
Write-Host "here "$file
Edit-ModuleVersionNumber -ModuleVersionNumber $buildNumber -psd1File $file
