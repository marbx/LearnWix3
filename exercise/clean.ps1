function silentdelelete ($path) {
    if (Test-Path $path) {
        Remove-Item -Recurse -Force $path
    }
}

silentdelelete *.msi
silentdelelete *.log
silentdelelete *.wixpdb
silentdelelete *.wixobj
silentdelelete Product-discovered-files*.wxs
silentdelelete CustomAction01\*.dll
silentdelelete CustomAction01\*.pdb
