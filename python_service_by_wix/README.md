
## Try 2


https://stackoverflow.com/questions/41200068/python-windows-service-error-starting-service-the-service-did-not-respond-to-t

 ```
Python \Python39\Scripts\pywin32_postinstall.py -install

pip install pyinstaller

pyinstaller --noconfirm  Python_service_by_pywin32.py


dist\Python_service_by_pywin32>Python_service_by_pywin32.exe
Traceback (most recent call last):
  File "C:\git\LearnWix3\python_service_by_wix\Python_service_by_pywin32.py", line 56, in <module>
    servicemanager.StartServiceCtrlDispatcher()
pywintypes.error: (1063, 'StartServiceCtrlDispatcher', 'The service process could not connect to the service controller.')
[8020] Failed to execute script Python_service_by_pywin32


 ```

## Try 1

```
pip install pywin32

python c:\git\LearnWix3\python_service_by_wix\Python_service_by_pywin32.py start
Starting service Python_service_by_pywin32
Error starting service: The service did not respond to the start or control request in a timely fashion.



```