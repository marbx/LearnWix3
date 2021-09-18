import win32serviceutil
import win32service
import win32event
import servicemanager
import socket
import sys

class AppServerSvc (win32serviceutil.ServiceFramework):
    _svc_name_ = "TestService"
    _svc_display_name_ = "Test Service"

    def __init__(self,args):
        win32serviceutil.ServiceFramework.__init__(self,args)
        self.hWaitStop = win32event.CreateEvent(None,0,0,None)
        socket.setdefaulttimeout(60)


    def SvcStop(self):
        self.ReportServiceStatus(win32service.SERVICE_STOP_PENDING)
        win32event.SetEvent(self.hWaitStop)


    def SvcDoRun(self):
        servicemanager.LogMsg(servicemanager.EVENTLOG_INFORMATION_TYPE,
                              servicemanager.PYS_SERVICE_STARTED,
                              (self._svc_name_,''))
        self.main()


    def main(self):
        import time
        import datetime
        STRFTIME = '%Y-%m-%dT%H:%M:%S'
        run = 0

        while self.run < 900:
            self.run += 1
            now = datetime.datetime.now().strftime(self.STRFTIME)
            print(now)
            with open('/temp/Python_service_by_pywin32', 'a') as f:
                f.write(f"{now}\n")
            time.sleep(5)


if __name__ == '__main__':
   if len(sys.argv) > 1:
       # Called by Windows shell. Handling arguments such as: Install, Remove, etc.
       win32serviceutil.HandleCommandLine(AppServerSvc)
   else:
       # Called by Windows Service. Initialize the service to communicate with the system operator
       servicemanager.Initialize()
       servicemanager.PrepareToHostSingle(AppServerSvc)
       servicemanager.StartServiceCtrlDispatcher()



