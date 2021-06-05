# Set-ExecutionPolicy RemoteSigned
Set-PSDebug -Strict
Set-strictmode -version latest

$msbuild = "C:\Program Files (x86)\MSBuild\14.0\"    # Build tools 2015 for compiling C#


function CheckExitCode($txt) {
    if ($LastExitCode -eq 0) {
        Write-Host -ForegroundColor Green "$txt   *DONE*"
    } else {
        Write-Host -ForegroundColor Red "$txt failed"
        exit(1)
    }
}


Write-Host -ForegroundColor Yellow "Compiling C# custom actions into intermediate language (*.dll)"
Push-Location CustomAction01
$releasedir = "obj_il"
if (!(Test-Path -Path $releasedir)){New-Item -ItemType directory -Path $releasedir | Out-Null}
# Compiler options should be those of a wix msbuild project.
# https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options
& "$($msbuild)bin\csc.exe" /nologo `
    /noconfig /nostdlib+ /errorreport:prompt /warn:4 /define:TRACE /highentropyva- `
    /reference:"$($ENV:WIX)SDK\Microsoft.Deployment.WindowsInstaller.dll" `
    /reference:"$($ENV:WIX)bin\wix.dll" `
    /reference:"C:\Windows\Microsoft.NET\Framework\v2.0.50727\mscorlib.dll" `
    /reference:"C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.dll" `
    /reference:"C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.Xml.dll" `
    /debug:pdbonly /filealign:512 /optimize+ `
    /target:library /utf8output `
    /nowarn:"1701,1702" `
    /out:$releasedir\CustomAction01.dll `
    CustomAction01.cs Properties\AssemblyInfo.cs
Pop-Location
CheckExitCode "Compiling C#"


# MakeSfxCA creates a self-extracting managed MSI CA DLL because
# the custom action dll will run in a sandbox and needs all needed dll inside. This adds 700 kB.
# Because MakeSfxCA does not check if Wix references a non existing procedure, you must check.
Write-Host -ForegroundColor Yellow "Packing dlls into CA.dll for sandbox"
Write-Host -ForegroundColor Red "Does this search find all your custom action procedures?"
& "$($ENV:WIX)sdk\MakeSfxCA.exe" `
    "$pwd\CustomAction01\obj_il\CustomAction01.CA.dll" `
    "$($ENV:WIX)sdk\x86\SfxCA.dll" `
    "$pwd\CustomAction01\obj_il\CustomAction01.dll" `
    "$($ENV:WIX)SDK\Microsoft.Deployment.WindowsInstaller.dll" `
    "$($ENV:WIX)bin\wix.dll" `
    "$($ENV:WIX)bin\Microsoft.Deployment.Resources.dll" `
    "$pwd\CustomAction01\CustomAction.config"
CheckExitCode "Packing"


Write-Host -ForegroundColor Yellow "Compiling wxs to wixobj"
& "$($ENV:WIX)bin\candle.exe" -nologo -sw1150 `
    -ddist=".\" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    Product.wxs `
    CustomAction01.wxs
CheckExitCode "Compiling wxs"


Write-Host -ForegroundColor Yellow "Linking wixobj to msi..."
& "$($ENV:WIX)bin\light" -nologo `
    -out "$pwd\Product.msi" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    Product.wixobj `
    CustomAction01.wixobj
CheckExitCode "Linking"
