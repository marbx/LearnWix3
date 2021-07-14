@echo off
IF exist "c:\aaaProduct" (
dir      "c:\aaaProduct" )

IF exist "C:\ProgramData\aaaManufacturer\aaaProduct" (
dir      "C:\ProgramData\aaaManufacturer\aaaProduct" )

IF exist "C:\Program Files (x86)\aaaManufacturer\aaaProduct" (
dir      "C:\Program Files (x86)\aaaManufacturer\aaaProduct" )

IF exist "C:\Program Files\aaaManufacturer\aaaProduct" (
dir      "C:\Program Files\aaaManufacturer\aaaProduct" )


