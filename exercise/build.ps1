# Set-ExecutionPolicy RemoteSigned
Set-PSDebug -Strict
Set-strictmode -version latest

# Product related values
$MANUFACTURER   = "aaaManufacturer"
$PRODUCT        = "aaaProduct"
$VERSION        = "1.2.4"
$DISCOVER_INSTALLDIR = ".\aaaProduct64bit", ".\aaaProduct32bit"
$DISCOVER_CONFIGDIR  = ".\aaaCONFIGDIR\conf"

$msbuild = "C:\Program Files (x86)\MSBuild\14.0\"    # MSBuild only needed to compile C#

# MSI related arrays for 64 and 32 bit values, selected by the first argument of this PowerShell script
if ($Args[0] -eq "32") {$i = 1} else {$i = 0}
$WIN64        = "yes",                  "no"                   # Used in wxs
$ARCHITECTURE = "x64",                  "x86"                  # WiX dictionary values
$ARCH_AKA     = "AMD64",                "x86"                  # For filename
$PLATFORM     = "x64",                  "Win32"
$PROGRAMFILES = "ProgramFiles64Folder", "ProgramFilesFolder"   # msi dictionary values

function CheckExitCode() {   # Exit on failure
    if ($LastExitCode -ne 0) {
        if (Test-Path build.tmp -PathType Leaf) {
            Get-Content build.tmp
            Remove-Item build.tmp
        }
        Write-Host -ForegroundColor Red "Failed"
        exit(1)
    }
    if (Test-Path build.tmp -PathType Leaf) {
        Remove-Item build.tmp
    }
}


Write-Host -ForegroundColor Yellow "Compiling    *.cs to *.dll"
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
CheckExitCode


Write-Host -ForegroundColor Yellow "Packaging    *.dll's to *.CA.dll"
# MakeSfxCA creates a self-extracting managed MSI CA DLL because
# the custom action dll will run in a sandbox and needs all dll inside. This adds 700 kB.
# Because MakeSfxCA cannot check if Wix will reference a non existing procedure, you must double check yourself.
# Usage: MakeSfxCA <outputca.dll> SfxCA.dll <inputca.dll> [support files ...]
& "$($ENV:WIX)sdk\MakeSfxCA.exe" `
    "$pwd\CustomAction01\CustomAction01.CA.dll" `
    "$($ENV:WIX)sdk\x86\SfxCA.dll" `
    "$pwd\CustomAction01\CustomAction01.dll" `
    "$($ENV:WIX)SDK\Microsoft.Deployment.WindowsInstaller.dll" `
    "$($ENV:WIX)bin\wix.dll" `
    "$($ENV:WIX)bin\Microsoft.Deployment.Resources.dll" `
    "$pwd\CustomAction01\CustomAction.config" > build.tmp
CheckExitCode


Write-Host -ForegroundColor Yellow "Discovering  $($DISCOVER_INSTALLDIR[$i]) to $($ARCHITECTURE[$i]) components *.wxs"
# https://wixtoolset.org/documentation/manual/v3/overview/heat.html
# -cg <ComponentGroupName> Component group name (cannot contain spaces e.g -cg MyComponentGroup).
# -sfrag   Suppress generation of fragments for directories and components.
# -var     WiX variable for SourceDir
# -gg      Generate guids now. All components are given a guid when heat is run.
# -sfrag   Suppress generation of fragments for directories and components.
# -sreg    Suppress registry harvesting.
# -suid    Suppress SILLY unique identifiers for files, components, & directories.
# -srd     Suppress harvesting the root directory as an element.
# -ke      Keep empty directories.
# -dr <DirectoryName>   Directory reference to root directories (cannot contains spaces e.g. -dr MyAppDirRef).
# -t <xsl> Transform harvested output with XSL file.
& "$($ENV:WIX)bin\heat" dir "$($DISCOVER_INSTALLDIR[$i])" -out "Product-$($ARCHITECTURE[$i])-discovered-files.wxs" `
   -cg DiscoveredBinaryFiles -var var.DISCOVER_INSTALLDIR `
   -dr INSTALLDIR -t Product-discover-files.xsl `
   -nologo -indent 1 -gg -sfrag -sreg -suid -srd -ke -template fragment
CheckExitCode

Write-Host -ForegroundColor Yellow "Discovering  $DISCOVER_CONFIGDIR to components *.wxs"
& "$($ENV:WIX)bin\heat" dir "$DISCOVER_CONFIGDIR" -out "Product-config-discovered-files.wxs" `
   -cg DiscoveredConfigFiles -var var.DISCOVER_CONFIGDIR `
   -dr CONFDIR -t Product-discover-files.xsl `
   -nologo -indent 1 -gg -sfrag -sreg -suid -srd -ke -template fragment
CheckExitCode


Write-Host -ForegroundColor Yellow "Compiling    *.wxs to $($ARCHITECTURE[$i]) *.wixobj"
# Options see "%wix%bin\candle"
& "$($ENV:WIX)bin\candle.exe" -nologo -sw1150 `
    -arch $ARCHITECTURE[$i] `
    -dWIN64="$($WIN64[$i])" `
    -dPROGRAMFILES="$($PROGRAMFILES[$i])" `
    -ddist=".\" `
    -dMANUFACTURER="$MANUFACTURER" `
    -dPRODUCT="$PRODUCT" `
    -dVERSION="$VERSION" `
    -dDISCOVER_INSTALLDIR="$($DISCOVER_INSTALLDIR[$i])" `
    -dDISCOVER_CONFIGDIR="$DISCOVER_CONFIGDIR" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    "Product.wxs" "Product-$($ARCHITECTURE[$i])-discovered-files.wxs" "Product-config-discovered-files.wxs" > build.tmp
CheckExitCode

Write-Host -ForegroundColor Yellow "Linking      *.wixobj and *.CA.dll to $PRODUCT-$VERSION-$($ARCH_AKA[$i]).msi"
# Options https://wixtoolset.org/documentation/manual/v3/overview/light.html
& "$($ENV:WIX)bin\light"  -nologo `
    -out "$pwd\$PRODUCT-$VERSION-$($ARCH_AKA[$i]).msi" `
    -dDISCOVER_INSTALLDIR="$($DISCOVER_INSTALLDIR[$i])" `
    -dDISCOVER_CONFIGDIR="$DISCOVER_CONFIGDIR" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    -spdb `
    -sice:ICE03 `
    -cultures:en-us `
    "Product.wixobj" "Product-$($ARCHITECTURE[$i])-discovered-files.wixobj" "Product-config-discovered-files.wixobj"
CheckExitCode

Remove-Item *.wixobj

Write-Host -ForegroundColor Green "Done "
