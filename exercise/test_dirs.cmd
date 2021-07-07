@echo off
IF exist "c:\aaaProduct" (
dir      "c:\aaaProduct" )

IF exist "C:\Program Files (x86)\aaaManufacturer" (
dir      "C:\Program Files (x86)\aaaManufacturer" )

IF exist "C:\Program Files\aaaManufacturer" (
dir      "C:\Program Files\aaaManufacturer" )

IF exist "C:\ProgramData\aaaManufacturer\aaaProduct" (
dir      "C:\ProgramData\aaaManufacturer\aaaProduct" )


