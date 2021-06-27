function silentdelelete ($path) {
    if (Test-Path $path) {
        Remove-Item -Recurse -Force $path
    }
}

silentdelelete *.msi
silentdelelete *.log
silentdelelete *.wixpdb
silentdelelete *.wixobj
silentdelelete *-discovered-x64-files.wxs
silentdelelete *-discovered-x86-files.wxs
silentdelelete CustomAction01\*.dll
silentdelelete CustomAction01\*.pdb
