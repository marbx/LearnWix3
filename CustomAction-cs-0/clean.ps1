function silentdelelete ($path) {
    if (Test-Path $path) {
        Remove-Item -Recurse -Force $path 
    }
}

silentdelelete *.msi
silentdelelete *.log
silentdelelete *.wixpdb
silentdelelete *.wixobj
silentdelelete CustomAction01\obj
