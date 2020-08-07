# RemoveFolderEx conditionally: leave or remove lifetime data (on upgrade, on uninstall)


Leave lifetime data on upgrade, remove on uninstall in `C:\Program Files (x86)\Acme\Foobar\var`

Remove lifetime data on both upgrade and uninstall in `C:\Program Files (x86)\Acme\Foobar\bin`


### TODO var 1 2 for Product.wxs

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

