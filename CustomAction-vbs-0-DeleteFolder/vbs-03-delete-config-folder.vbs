CONFIGFOLDER = "C:\Program Files (x86)\Acme\FoobarConf\"
Set FSO = CreateObject("Scripting.FileSystemObject")
If FSO.FolderExists(CONFIGFOLDER) Then
  FSO.GetFolder(CONFIGFOLDER).Delete(True)
End If