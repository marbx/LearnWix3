CONFIGFOLDER = "C:\Program Files (x86)\Acme\FoobarConf\"
Set FSO = CreateObject("Scripting.FileSystemObject")
on error resume next
FSO.GetFolder(CONFIGFOLDER).Delete(True)
