CONFIGFOLDER = "C:\Program Files (x86)\Acme\FoobarConf\"

Set objFSO	= CreateObject("Scripting.FileSystemObject")
for each File in objFSO.GetFolder(CONFIGFOLDER).Files
    File.Delete
Next
