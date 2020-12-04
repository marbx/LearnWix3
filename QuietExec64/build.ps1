# Set-ExecutionPolicy RemoteSigned
Set-PSDebug -Strict
Set-strictmode -version latest

$msbuild = "C:\Program Files (x86)\MSBuild\14.0\"    # Build tools 2015


function CheckExitCode($txt) {
    if ($LastExitCode -ne 0) {
        Write-Host -ForegroundColor Red "$txt failed"
        exit(1)
    }
}


Write-Host -ForegroundColor Yellow "Precompiling wxs to wixobj..."
& "$($ENV:WIX)bin\candle.exe" `
    -nologo `
    -sw1150 `
    -arch x64 `
    -ddist=".\" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    Product.wxs
CheckExitCode "candle"


Write-Host -ForegroundColor Yellow "Linking wixobj to msi..."
& "$($ENV:WIX)bin\light" `
    -out "$pwd\Product.msi" `
    -pdbout "$pwd\Product.wixpdb" `
    -cultures:null `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    -sice:ICE03 `
    Product.wixobj
CheckExitCode "light"

