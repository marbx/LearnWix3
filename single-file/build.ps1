# Set-ExecutionPolicy RemoteSigned

"$($ENV:WIX)bin\candle" -nologo Product.wxs
if (-not ($?)) {exit(1)}

"$($ENV:WIX)bin\light" -nologo Product.wixobj

