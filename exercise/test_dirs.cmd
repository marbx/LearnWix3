@echo off
IF exist "c:\aaaProduct\conf" (
dir      "c:\aaaProduct\conf" )

IF exist "C:\ProgramData\aaaManufacturer\aaaProduct\conf" (
dir      "C:\ProgramData\aaaManufacturer\aaaProduct\conf" )

IF exist "C:\Program Files (x86)\aaaManufacturer\aaaProduct" (
dir      "C:\Program Files (x86)\aaaManufacturer\aaaProduct" )

IF exist "C:\Program Files\aaaManufacturer\aaaProduct" (
dir      "C:\Program Files\aaaManufacturer\aaaProduct" )


Reg Query "HKLM\SOFTWARE\aaaManufacturer\aaaProduct"