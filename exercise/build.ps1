# Set-ExecutionPolicy RemoteSigned
Set-PSDebug -Strict
Set-strictmode -version latest

# Product related values
$EXE          = "a64.exe", "a32.exe"
$CONFIG       = "a.config"
$MANUFACTURER = "aaaManufacturer"
$PRODUCT      = "aaaProduct"
$VERSION      = "1.2.4"

$msbuild = "C:\Program Files (x86)\MSBuild\14.0\"    # MSBuild only needed to compile C#

# MSI related arrays for 64 and 32 bit values, selected by the first argument of this PowerShell script
if ($Args[0] -eq "32") {$i = 1} else {$i = 0}
$WIN64        = "yes",                  "no"                   # Used in wxs
$ARCHITECTURE = "x64",                  "x86"                  # WiX dictionary values
$ARCH_AKA     = "AMD64",                "x86"                  # For filename
$PLATFORM     = "x64",                  "Win32"
$PROGRAMFILES = "ProgramFiles64Folder", "ProgramFilesFolder"   # msi dictionary values

function CheckExitCode($txt) {   # Exit on failure
    if ($LastExitCode -ne 0) {
        Write-Host -ForegroundColor Red "$txt failed"
        exit(1)
    }
}


Write-Host -ForegroundColor Yellow "Compiling C# custom actions into *.dll"
Push-Location CustomAction01
# Compiler options are exactly those of a wix msbuild project.
# https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options
& "$($msbuild)bin\csc.exe" /nologo `
    /noconfig /nostdlib+ /errorreport:prompt /warn:4 /define:TRACE /highentropyva- `
    /debug:pdbonly /filealign:512 /optimize+ /target:library /utf8output `
    /reference:"$($ENV:WIX)SDK\Microsoft.Deployment.WindowsInstaller.dll" `
    /reference:"$($ENV:WIX)bin\wix.dll" `
    /reference:"C:\Windows\Microsoft.NET\Framework\v2.0.50727\mscorlib.dll" `
    /reference:"C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.dll" `
    /reference:"C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.Xml.dll" `
    /nowarn:"1701,1702" `
    /out:CustomAction01.dll `
    CustomAction01.cs Properties\AssemblyInfo.cs
Pop-Location
CheckExitCode "Compiling C#"


# MakeSfxCA creates a self-extracting managed MSI CA DLL because
# the custom action dll will run in a sandbox and needs all dll inside. This adds 700 kB.
# Because MakeSfxCA does not check if Wix references a non existing procedure, you must check.
Write-Host -ForegroundColor Yellow "Packaging *.dlls into *.CA.dll for running in a sandbox"
Write-Host -ForegroundColor Blue "Does this search find all your custom action procedures?"
& "$($ENV:WIX)sdk\MakeSfxCA.exe" `
    "$pwd\CustomAction01\CustomAction01.CA.dll" `
    "$($ENV:WIX)sdk\x86\SfxCA.dll" `
    "$pwd\CustomAction01\CustomAction01.dll" `
    "$($ENV:WIX)SDK\Microsoft.Deployment.WindowsInstaller.dll" `
    "$($ENV:WIX)bin\wix.dll" `
    "$($ENV:WIX)bin\Microsoft.Deployment.Resources.dll" `
    "$pwd\CustomAction01\CustomAction.config"
CheckExitCode "Packaging"


# To compile: name all wxs. Define properties for the wxs with -d
# Options see "%wix%bin\candle"
Write-Host -ForegroundColor Yellow "Compiling wxs to $($ARCHITECTURE[$i]) wixobj"
& "$($ENV:WIX)bin\candle.exe" -nologo -sw1150 `
    -arch $ARCHITECTURE[$i] `
    -dWIN64="$($WIN64[$i])" `
    -dPROGRAMFILES="$($PROGRAMFILES[$i])" `
    -ddist=".\" `
    -dEXE="$($EXE[$i])" `
    -dCONFIG="$CONFIG" `
    -dMANUFACTURER="$MANUFACTURER" `
    -dPRODUCT="$PRODUCT" `
    -dVERSION="$VERSION" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    "$PRODUCT.wxs"
CheckExitCode "candle"

# Options https://wixtoolset.org/documentation/manual/v3/overview/light.html
Write-Host -ForegroundColor Yellow "Linking $($ARCHITECTURE[$i]) wixobj to $PRODUCT-$VERSION-$($ARCH_AKA[$i]).msi"
& "$($ENV:WIX)bin\light"  -nologo `
    -out "$pwd\$PRODUCT-$VERSION-$($ARCH_AKA[$i]).msi" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    -spdb `
    -sice:ICE03 `
    -cultures:en-us `
    "$PRODUCT.wixobj"
CheckExitCode "light"

Write-Host -ForegroundColor Green "Done "
