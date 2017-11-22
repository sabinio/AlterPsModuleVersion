param(
    $buildNumber,
    $file
)
$FileExists = Test-Path $file
If ($FileExists -eq $false) {
    Write-Error "$File does not exist!"
    Throw
}
$extn = [IO.Path]::GetExtension($file)
if ($extn -ne ".psd1" )
{
    Write-Error "$file is not a psd1 file!"
    Throw
}
Write-Host "psd1 location is $file"
Write-Host "ModuleVersionNumber will be altered to $buildNumber"
$regex = 'ModuleVersion(.*)'
try {
    (Get-Content $file) -replace $regex, "ModuleVersion = '$buildNumber'" | Set-Content $file
    Write-Host "Updated."
}
catch {
    Write-Error "Something went wrong in trying to update ModuleNumber."
    Throw
}
