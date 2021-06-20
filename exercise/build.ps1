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
$PROGRAMFILES = "ProgramFiles64Folder", "ProgramFilesFolder"   # Well-known-names
$EXE          = "largest_u64.exe", "largest_u32.exe"
$CONFIG       = "Largest-number.config", "Largest-number.config"
$PRODUCT      = "Largest-number"
$MANUFACTURER = "Largest-numberer"


function CheckExitCode($txt) {   # Exit on failure
    if ($LastExitCode -ne 0) {
        Write-Host -ForegroundColor Red "$txt failed"
        exit(1)
    }
}

# To compile: name all wxs. Define properties for the wxs with -d
# Options see "%wix%bin\candle"
Write-Host -ForegroundColor Yellow "Compiling wxs to $($ARCHITECTURE[$i]) wixobj"
& "$($ENV:WIX)bin\candle.exe" -nologo -sw1150 `
    -arch $ARCHITECTURE[$i] `
    -dWIN64="$($WIN64[$i])" `
    -dEXE="$($EXE[$i])" `
    -dCONFIG="$($CONFIG[$i])" `
    -dPROGRAMFILES="$($PROGRAMFILES[$i])" `
    -ddist=".\" `
    -dPRODUCT="$PRODUCT" `
    -dMANUFACTURER="$MANUFACTURER" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    "$PRODUCT.wxs"
CheckExitCode "candle"

# Options https://wixtoolset.org/documentation/manual/v3/overview/light.html
Write-Host -ForegroundColor Yellow "Linking $($ARCHITECTURE[$i]) wixobj to $PRODUCT-$($ARCH_AKA[$i]).msi"
& "$($ENV:WIX)bin\light"  -nologo `
    -out "$pwd\$PRODUCT-$($ARCH_AKA[$i]).msi" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    -spdb `
    -sice:ICE03 `
    -cultures:en-us `
    "$PRODUCT.wixobj"
CheckExitCode "light"

Write-Host -ForegroundColor Green "Done "
