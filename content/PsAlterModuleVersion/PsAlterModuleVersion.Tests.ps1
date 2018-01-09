# test one - as expected 
$OldErrorActionPref = $ErrorActionPreference
$qwerty = (Join-Path $PSScriptRoot ".\PsAlterModuleVersion.ps1")
$testBuildNumber = "1.5.4567"
$file = Get-ChildItem (Join-Path $PSScriptRoot ".\TestPsd1file.psd1")
$fileFullName = $file.Fullname
$e = . $qwerty -buildNumber $testbuildNumber -File $fileFullName
if ($e -ne "ModuleVersion = '1.5.4567'") {
    Throw "Test One failed"
}
else {
    Write-Host "Asserted result correctly - $e matches ModuleVersion = `'$testbuildNumber`'" -ForegroundColor Green
}

# test two - as expected, different version number format 
$OldErrorActionPref = $ErrorActionPreference
$qwerty = (Join-Path $PSScriptRoot ".\PsAlterModuleVersion.ps1")
$validBuildNumbers = @()
$validBuildNumbers = "1.5.4567.0", "1.0.0.5", "1.0.0.4567"
foreach ($testBuildNumber in $validBuildNumbers) {
    $file = Get-ChildItem (Join-Path $PSScriptRoot ".\TestPsd1file.psd1")
    $fileFullName = $file.Fullname
    $e = . $qwerty -buildNumber $testbuildNumber -File $fileFullName
    if ($e -ne "ModuleVersion = `'$testbuildNumber`'") {
        Throw "Test Two failed on $testbuildNumber !"
    }
    else {
        Write-Host "Asserted result correctly - $e matches ModuleVersion = `'$testbuildNumber`'" -ForegroundColor Green
    }
}
# test three - not a psd1 file
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
        Write-Host "Asserted Exception Correctly - $($_.Exception.Message)" -ForegroundColor Green
    }
    else {
        Throw "Test three failed!"
    }
}
# test four - psd1 file does not exist
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
        Write-Host "Asserted Exception Correctly - $($_.Exception.Message)" -ForegroundColor Green
    }
    else {
        Throw "Test four failed!"
    }
}
# test five - psd1 file does not contain ModuleVersionNumber
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
        Write-Host "Asserted Exception Correctly - $($_.Exception.Message)" -ForegroundColor Green
    }
    else {
        Throw "Test five failed!"
    }
}
# test six - wrong format for version number 
$qwerty = (Join-Path $PSScriptRoot ".\PsAlterModuleVersion.ps1")
$VersionNumbers = @()
$VersionNumbers = "1.0.t", "1.0.0.t", "1.0.0.0.t" , "t.0.0.345", "1.rt.0.345", "&()*"
foreach ($testBuildNumber in $VersionNumbers) {
    $ErrorActionPreference = 'SilentlyContinue'
    $file = Get-ChildItem (Join-Path $PSScriptRoot ".\TestPsd1file.psd1")
    $fileFullName = $file.Fullname
    try {
        . $qwerty -buildNumber $testbuildNumber -File $fileFullName
    }
    catch {
        $ErrorActionPreference = $OldErrorActionPref
        if ($_.Exception.Message -eq "WrongFormat") {
            Write-Host "Asserted Exception Correctly - $testbuildNumber produces $($_.Exception.Message)" -ForegroundColor Green
        }
        else {
            Throw "Test six failed on $testBuildNumber ! $($_.Exception.Message)"
        }
    }
}


Write-Host "Tests passed!" -ForegroundColor Green