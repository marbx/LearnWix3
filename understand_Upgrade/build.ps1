# Set-ExecutionPolicy RemoteSigned
Set-PSDebug -Strict
Set-strictmode -version latest

function CheckExitCode($txt) {
    if ($LastExitCode -ne 0) {
        Write-Host -ForegroundColor Red "$txt failed"
        exit(1)
    }
}


Write-Host -ForegroundColor Yellow "Precompiling 1 wxs to wixobj..."
& "$($ENV:WIX)bin\candle.exe" `
    "-dInternalVersion=1.0.0" `
    "-dFoobarexefile=FoobarAppl10.exe" `
    -nologo `
    -sw1150 `
    -ddist=".\" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    -out "$pwd\Product1.wixobj" `
    Product.wxs
CheckExitCode "candle"


Write-Host -ForegroundColor Yellow "Linking wixobj to msi..."
& "$($ENV:WIX)bin\light" `
    -out "$pwd\Product1.msi" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    Product1.wixobj
CheckExitCode "light"


Write-Host -ForegroundColor Yellow "Precompiling 2 wxs to wixobj..."
& "$($ENV:WIX)bin\candle.exe" `
    "-dInternalVersion=2.0.0" `
    "-dFoobarexefile=FoobarAppl20.exe" `
    -nologo `
    -sw1150 `
    -ddist=".\" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    -out "$pwd\Product2.wixobj" `
    Product.wxs
CheckExitCode "candle"

Write-Host -ForegroundColor Yellow "Linking wixobj to msi..."
& "$($ENV:WIX)bin\light" `
    -out "$pwd\Product2.msi" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    Product2.wixobj
CheckExitCode "light"



