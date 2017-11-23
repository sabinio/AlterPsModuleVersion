param(    
    $buildNumber,
    $file
)
Function Edit-ModuleVersionNumber {
    [cmdletbinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string]$ModuleVersionNumber,
        [ValidateNotNullOrEmpty()]
        [string]$psd1File
    )
    $psd1File = $psd1File.Trim()
    $ModuleVersionNumber = $ModuleVersionNumber.Trim()
    if ((Test-Path $psd1File) -eq $false){
        Write-Error "$psd1File does not exist!"
        throw "psd1miss"
    }
    $extn = [IO.Path]::GetExtension($psd1File)
    if ($extn -ne ".psd1" ) {
        Write-Error "$psd1File is not a psd1 psd1File!"
        Throw "notapsd1"
    }
    $psd1FileName = Split-Path -Path $psd1File -Leaf
    if ((@( Get-Content $psd1File | Where-Object { $_.Contains("ModuleVersion") } ).Count) -eq 0) {
        Write-Error "ModuleVersionNumber element not found in $psd1FileName!"
        Throw "NoModuleVersionNumber"
    }
    if (($ModuleVersionNumber -match "^(\d+\.)?(\d+\.)?(\*|\d+)$") -eq $false) {
        if (($ModuleVersionNumber -match "^(\d+\.)?(\d+\.)?(\d+\.)?(\*|\d+)$") -eq $false) {
            Write-Error "New ModuleVersion Number not in correct format; Expected ##.##.##(.##) , Actual $ModuleVersionNumber"
            Throw "WrongFormat"
        }
    }
    Write-Host "ModuleVersionNumber in $psd1FileName will be altered to $ModuleVersionNumber."
    try {
        (Get-Content $psd1File) -replace 'ModuleVersion(.*)', "ModuleVersion = '$ModuleVersionNumber'" | Set-Content $psd1File
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
Edit-ModuleVersionNumber -ModuleVersionNumber $buildNumber -psd1File $file