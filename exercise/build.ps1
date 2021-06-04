# Set-ExecutionPolicy RemoteSigned
Set-PSDebug -Strict
Set-strictmode -version latest

$msbuild = "C:\Program Files (x86)\MSBuild\14.0\"    # MSBuild only needed to compile C#
# Arrays for 64 and 32 bit values, select by argument
if ($Args[0] -eq "32") {$i = 1} else {$i = 0}
$WIN64        = "yes",   "no"
$ARCHITECTURE = "x64",   "x86"
$ARCH_AKA     = "AMD64", "x86"
$PLATFORM     = "x64",   "Win32"
$PROGRAMFILES = "ProgramFiles64Folder", "ProgramFilesFolder"
$EXE          = "Foo64.exe", "Foo32.exe"
$CONFIG       = "Foo.config", "Foo.config"

function CheckExitCode($txt) {   # Exit on failure
    if ($LastExitCode -ne 0) {
        Write-Host -ForegroundColor Red "$txt failed"
        exit(1)
    }
}

# To compile, name all wxs, define properties for the wxs with -d
Write-Host -ForegroundColor Yellow "Compiling wxs to $($ARCHITECTURE[$i]) wixobj"
& "$($ENV:WIX)bin\candle.exe" -nologo -sw1150 `
    -dWIN64="$($WIN64[$i])" `
    -dEXE="$($EXE[$i])" `
    -dCONFIG="$($CONFIG[$i])" `
    -dPROGRAMFILES="$($PROGRAMFILES[$i])" `
    -ddist=".\" `
    -arch $ARCHITECTURE[$i] `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    Product.wxs ProductUI.wxs
CheckExitCode "candle"

Write-Host -ForegroundColor Yellow "Linking wixobj to Product-$($ARCH_AKA[$i]).msi"
& "$($ENV:WIX)bin\light"  -nologo `
    -out "$pwd\Product-$($ARCH_AKA[$i]).msi" `
    -pdbout "$pwd\Product.wixpdb" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    -sice:ICE03 `
    -cultures:en-us `
    Product.wixobj ProductUI.wixobj
CheckExitCode "light"

Write-Host -ForegroundColor Green "Build ended"
