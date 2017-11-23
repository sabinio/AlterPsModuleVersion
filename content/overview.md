# Alter the Version Number of Your PowerShell Module
This plugin will alter the ModuleVersion of your PowerShell Module. 

The plugin itself is built and deployed via VSTS. THe following badge shows the current status of that build.

[<img src="https://sabinio.visualstudio.com/_apis/public/build/definitions/573f7b7f-2303-49f0-9b89-6e3117380331/114/badge"/>](https://sabinio.visualstudio.com/Sabin.IO/_apps/hub/ms.vss-ciworkflow.build-ci-hub?_a=edit-build-definition&id=114)

## How To Use
Enter the path to your psd1 file and the number that you wish to set the Module Version to.

The task will fail if the file is not a psd1 file, or if ti does not contain a line in the psd1 file that matches the one below - 
```powershell
    ModuleVersion = '1.5.4567.0'
``` 

The ModuleVersion number must be in the format ##.##.##(.##),otherwise the attempted change will fail.



