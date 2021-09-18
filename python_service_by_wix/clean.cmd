PowerShell -ExecutionPolicy RemoteSigned -File clean.ps1
rmdir /s /q build dist __pycache__
del Python_service_by_pywin32.spec

