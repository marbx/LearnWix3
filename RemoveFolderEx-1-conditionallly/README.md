# RemoveFolderEx conditionally: leave or remove lifetime data (on upgrade, on uninstall)


Leave lifetime data on upgrade, remove on uninstall in `C:\Program Files (x86)\Acme\Foobar\var`

Remove lifetime data on both upgrade and uninstall in `C:\Program Files (x86)\Acme\Foobar\bin`

DOES NOT WORK because component is never installed so component will never be removed


### Doc
Is the component...

| Condition                              | version 1 install| version 1 uninstall | version 2 install| version 2 uninstall |
|---|---|---|
| IDEAL                                  | yes              | no                  | no               | yes                         |
| NOT UPGRADINGPRODUCTCODE               | yes H1           | YES H2              | YES H3           | Does not matter
| NOT WIX_UPGRADE_DETECTED               | yes H4           | YES Datei weg
| NOT WIX_UPGRADE_DETECTED AND Installed | yes              | no                  | no?              | NO H5 Datei da

#### H1 from Product1-install.log
MSI (s) (80:F8) [22:05:38:627]: Executing op: ComponentRegister(ComponentId={301EFE0B-A8B3-419D-B787-3478EB56E252},KeyPath=22:\SOFTWARE\ACME\Foobar\RememberForRemoveFolderEx_VARFOLDER,State=3,,Disk=1,SharedDllRefCount=0,BinaryType=1)

#### H2 from Product2-install.log
LINE 229

MSI (s) (80:F4) [22:08:32:502]: Component: RemoveFolderEx_VARFOLDER_Component; Installed: Absent;   Request: Local;   Action: Local

// Thats Wrong because it installs a component that should be present

LINE 296

MSI (s) (80:98) [22:08:32:517]: Command Line: UPGRADINGPRODUCTCODE={3C79D7F1-22F8-4DCA-81AD-7CC542D361E3} CLIENTPROCESSID=9120 CLIENTUILEVEL=2 REMOVE=ALL 

// Thats OK but maybe too lagte

LINE 471

MSI (s) (80:98) [22:08:32:595]: Component: RemoveFolderEx_VARFOLDER_Component; Installed: Local;   Request: Absent;   Action: Absent

// Thats wrong becuase it should not remove the component

LINE 615

MSI (s) (80:98) [22:08:32:673]: Executing op: UnregisterSharedComponentProvider(Component={301EFE0B-A8B3-419D-B787-3478EB56E252},ProductCode={F40631A7-8501-4022-BCD4-250EFDB4D210})
MSI (s) (80:98) [22:08:32:673]: Executing op: ComponentUnregister(ComponentId={301EFE0B-A8B3-419D-B787-3478EB56E252},,BinaryType=1,)

// Thats wrong becuase it should not remove the component


#### H3 from Product2-install.log
MSI (s) (80:F4) [22:08:32:798]: Executing op: ComponentRegister(ComponentId={301EFE0B-A8B3-419D-B787-3478EB56E252},KeyPath=22:\SOFTWARE\ACME\Foobar\RememberForRemoveFolderEx_VARFOLDER,State=3,,Disk=1,SharedDllRefCount=0,BinaryType=1)

#### H4 from Product1-install.log
MSI (s) (70:18) [22:28:14:954]: Executing op: ComponentRegister(ComponentId={301EFE0B-A8B3-419D-B787-3478EB56E252},KeyPath=22:\SOFTWARE\ACME\Foobar\RememberForRemoveFolderEx_VARFOLDER,State=3,,Disk=1,SharedDllRefCount=0,BinaryType=1)

#### H5 from Product2-uninstall.log

MSI (s) (CC:84) [22:40:03:033]: Feature: Complete;                             Installed: Local;   Request: Absent;   Action: Absent
MSI (s) (CC:84) [22:40:03:033]: Component: RemoveFolderEx_VARFOLDER_Component; Installed: Local;   Request: Absent;   Action: Null


MSI (s) (CC:84) [22:40:03:111]: Executing op: UnregisterSharedComponentProvider(Component={301EFE0B-A8B3-419D-B787-3478EB56E252},ProductCode={BC5BFDF9-74A4-4128-9FA2-A1AF668D743E})
MSI (s) (CC:84) [22:40:03:111]: Executing op: ComponentUnregister(ComponentId={301EFE0B-A8B3-419D-B787-3478EB56E252},,BinaryType=1,PreviouslyPinned=1)

//  What does mean Executing op: ComponentUnregister PreviouslyPinned

 ### TODO Error in install log


Action start 14:49:44: WixRemoveFoldersEx.
WixRemoveFoldersEx:  Error 0x80070057: Missing folder property: INSTALLFOLDER for row: *
CustomAction WixRemoveFoldersEx returned actual error code 1603 but will be translated to success due to continue marking
Action ended 14:49:44: WixRemoveFoldersEx. Return value 1.

This is the uninstall log:

Action start 14:50:23: WixRemoveFoldersEx.
MSI (s) (D4!EC) [14:50:23:275]: PROPERTY CHANGE: Adding _INSTALLFOLDER_0 property. Its value is 'C:\Program Files (x86)\Acme\Foobar\'.
WixRemoveFoldersEx:  Recursing path: C:\Program Files (x86)\Acme\Foobar\ for row: wrf9D9CFBC3B0FA4D95F165F0F98EA95554.



### links Conditions

https://wafoster.wordpress.com/2013/07/03/fun-with-wix-conditional-features/

