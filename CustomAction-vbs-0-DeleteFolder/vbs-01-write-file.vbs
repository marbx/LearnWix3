Set objFSO=CreateObject("Scripting.FileSystemObject")
outFile="vbs-01-write-file.log"
Set objFile = objFSO.CreateTextFile(outFile,True)
objFile.Write "test string" + " concat1"
objFile.Close
