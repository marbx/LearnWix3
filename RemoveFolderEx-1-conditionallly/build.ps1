# Set-ExecutionPolicy RemoteSigned
Set-PSDebug -Strict
Set-strictmode -version latest

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
    -ddist=".\" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    Product_1.wxs
CheckExitCode "candle"


Write-Host -ForegroundColor Yellow "Linking wixobj to msi..."
& "$($ENV:WIX)bin\light" `
    -out "$pwd\Product1.msi" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    Product_1.wixobj
CheckExitCode "light"


Write-Host -ForegroundColor Yellow "Precompiling wxs to wixobj..."
& "$($ENV:WIX)bin\candle.exe" `
    -nologo `
    -sw1150 `
    -ddist=".\" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    Product_2.wxs
CheckExitCode "candle"

Write-Host -ForegroundColor Yellow "Linking wixobj to msi..."
& "$($ENV:WIX)bin\light" `
    -out "$pwd\Product2.msi" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixUIExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    Product_2.wixobj
CheckExitCode "light"



