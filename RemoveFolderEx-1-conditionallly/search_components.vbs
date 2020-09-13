Option Explicit
Public installer, fullmsg, comp, a, prod, fso, pname, ploc, pid, psorce

Set fso = CreateObject("Scripting.FileSystemObject")
Set a = fso.CreateTextFile("markus.txt", True)

' Connect to Windows Installer object
Set installer = CreateObject("WindowsInstaller.Installer")
a.writeline ("Components")
'on error resume next
For Each comp In installer.components
a.writeline (comp & " is used by:")
for each prod in Installer.ComponentClients (comp)
pid = installer.componentpath (prod, comp)
pname = installer.productinfo (prod, "InstalledProductName")
a.Writeline ("                    " & pname & " at " & pid)
Next
Next
