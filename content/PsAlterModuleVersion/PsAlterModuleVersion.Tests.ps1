# test one - as expected 
$OldErrorActionPref = $ErrorActionPreference
$qwerty = (Join-Path $PSScriptRoot ".\PsAlterModuleVersion.ps1")
$testBuildNumber = "1.5.4567"
$file = Get-ChildItem (Join-Path $PSScriptRoot ".\TestPsd1file.psd1")
$fileFullName = $file.Fullname
$e = . $qwerty -buildNumber $testbuildNumber -File $fileFullName
Write-Host $e
if ($e -ne "ModuleVersion = '1.5.4567'") {
    Throw "Test One failed"
}

# test one a - as expected, different version number format 
$OldErrorActionPref = $ErrorActionPreference
$qwerty = (Join-Path $PSScriptRoot ".\PsAlterModuleVersion.ps1")
$testBuildNumber = "1.5.4567.0"
$file = Get-ChildItem (Join-Path $PSScriptRoot ".\TestPsd1file.psd1")
$fileFullName = $file.Fullname
$e = . $qwerty -buildNumber $testbuildNumber -File $fileFullName
Write-Host $e
if ($e -ne "ModuleVersion = '1.5.4567.0'") {
    Throw "Test One A failed!"
}
# test two - not a psd1 file
$ErrorActionPreference = 'SilentlyContinue'
$testBuildNumber = "1.5.4567"
$file = Get-ChildItem (Join-Path $PSScriptRoot ".\icon.png")
$fileFullName = $file.Fullname
try {
    . $qwerty -buildNumber $testbuildNumber -File $fileFullName
}
catch {
    $ErrorActionPreference = $OldErrorActionPref
    if ($_.Exception.Message -eq "notapsd1") {
        Write-Host "Asserted Exception Correctly - $($_.Exception.Message)"
    }
    else{
        Throw "Test two failed!"
    }
}
# test 3 - psd1 file does not exist
$ErrorActionPreference = 'SilentlyContinue'
$testBuildNumber = "1.5.4567"
$file = ".\noFile.psd1"
try {
    . $qwerty -buildNumber $testbuildNumber -File $file
}
catch {
    $ErrorActionPreference = $OldErrorActionPref
    $_.Exception.Message
    if ($_.Exception.Message -eq "psd1miss") {
        Write-Host "Asserted Exception Correctly - $($_.Exception.Message)"
    }
    else{
        Throw "Test three failed!"
    }
}
# test four - psd1 file does not contain ModuleVersionNumber
$ErrorActionPreference = 'SilentlyContinue'
$testBuildNumber = "1.5.4567"
$file = Get-ChildItem (Join-Path $PSScriptRoot ".\MissingModuleVersionNumber.psd1")
$fileFullName = $file.Fullname
try {
    . $qwerty -buildNumber $testbuildNumber -File $fileFullName
}
catch {
    $ErrorActionPreference = $OldErrorActionPref
    if ($_.Exception.Message -eq "NoModuleVersionNumber") {
        Write-Host "Asserted Exception Correctly - $($_.Exception.Message)"
    }
    else{
        Throw "Test four failed!"
    }
}
# test five - wrong format for version number 
$ErrorActionPreference = 'SilentlyContinue'
$qwerty = (Join-Path $PSScriptRoot ".\PsAlterModuleVersion.ps1")
$testBuildNumber = "1.5.asdf"
$file = Get-ChildItem (Join-Path $PSScriptRoot ".\TestPsd1file.psd1")
$fileFullName = $file.Fullname
try {
    . $qwerty -buildNumber $testbuildNumber -File $fileFullName
}
catch {
    $ErrorActionPreference = $OldErrorActionPref
    if ($_.Exception.Message -eq "WrongFormat") {
        Write-Host "Asserted Exception Correctly - $($_.Exception.Message)"
    }
    else{
        Throw "Test five failed!"
    }
}