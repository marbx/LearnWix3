# Set-ExecutionPolicy RemoteSigned
Set-PSDebug -Strict
Set-strictmode -version latest

$msbuild = "C:\Program Files (x86)\MSBuild\14.0\"    # Build tools 2015
$WIN64        = "yes",   "no"
$ARCHITECTURE = "x64",   "x86"
$ARCH_AKA     = "AMD64", "x86"
$PLATFORM     = "x64",   "Win32"
$PROGRAMFILES = "ProgramFiles64Folder", "ProgramFilesFolder"
$EXE          = "Foo64.exe", "Foo32.exe"
$CONFIG       = "Foo.config", "Foo.config"

if ($Args[0] -eq "32") {
    $i = 1
} else {
    $i = 0
}


function CheckExitCode($txt) {
    if ($LastExitCode -ne 0) {
        Write-Host -ForegroundColor Red "$txt failed"
        exit(1)
    }
}



Write-Host -ForegroundColor Yellow "Compiling wxs to $($PLATFORM[$i]) wixobj"
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
    Product.wxs
CheckExitCode "candle"

# https://wixtoolset.org/documentation/manual/v3/votive/votive_project_references.html

Write-Host -ForegroundColor Yellow "Linking wixobj to Product-$($ARCH_AKA[$i]).msi"
& "$($ENV:WIX)bin\light"  -nologo `
    -out "$pwd\Product-$($ARCH_AKA[$i]).msi" `
    -pdbout "$pwd\Product.wixpdb" `
    -cultures:null `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    -sice:ICE03 `
    Product.wixobj
CheckExitCode "light"

