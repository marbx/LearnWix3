@echo off

"%wix%"bin\candle Product.wxs
IF %ERRORLEVEL% NEQ 0 EXIT /B 1
"%wix%"bin\light Product.wixobj

