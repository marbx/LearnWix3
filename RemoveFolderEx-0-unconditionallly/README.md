# RemoveFolderEx, no condition

### TODO Error in install log


Action start 14:49:44: WixRemoveFoldersEx.
WixRemoveFoldersEx:  Error 0x80070057: Missing folder property: INSTALLFOLDER for row: *
CustomAction WixRemoveFoldersEx returned actual error code 1603 but will be translated to success due to continue marking
Action ended 14:49:44: WixRemoveFoldersEx. Return value 1.

This is the uninstall log:

Action start 14:50:23: WixRemoveFoldersEx.
MSI (s) (D4!EC) [14:50:23:275]: PROPERTY CHANGE: Adding _INSTALLFOLDER_0 property. Its value is 'C:\Program Files (x86)\Acme\Foobar\'.
WixRemoveFoldersEx:  Recursing path: C:\Program Files (x86)\Acme\Foobar\ for row: wrf9D9CFBC3B0FA4D95F165F0F98EA95554.


### links regarding RemoveFolderEx

#### FAIL RemoveFolderEx in component in sub-feature in feature, use condition in sub-feature (Author Eli)

https://stackoverflow.com/questions/195919/removing-files-when-uninstalling-wix


#### FAIL RemoveFolderEx in component  in feature, use condition in component (Author Hass)

https://www.hass.de/content/wix-how-use-removefolderex-your-xml-scripts

### ...

https://stackoverflow.com/questions/320921/how-to-add-a-wix-custom-action-that-happens-only-on-uninstall-via-msi

### links Conditions

https://wafoster.wordpress.com/2013/07/03/fun-with-wix-conditional-features/


#### Else
http://www.christiano.ch/wordpress/windows-installer-msi-kb/msi-understanding-the-windows-installer-logs/



### old doc

* * * * * * * * * * 
 * * * * * * * * * * 
  Trying to not NUKE CONF
 * * * * * * * * * * 
 * * * * * * * * * * 
		A component or a feature can only be uninstalled after it has been installed.
		Optionally removing CONF means, if not, the component remains, the uninstall is uncomplete, the ARP entry remains, a second uninstall removes the ARP.
		I looked for 3 days for a WiX way, not CS_CUSTOM_ACTION
		  
		
		
		      <!-- ComponentRef      Id="C.RemoveDataFolder"    / -->
      <!--  http://stackoverflow.com/questions/14645401/msi-uninstall-does-not-remove-product-entry-in-program-features 
      <Feature Id='CleanupConfFolderFeature' Level='0'>
        <Condition Level="1">((NOT Installed) OR (REMOVE ~= "ALL")) AND (KEEP_CONFIG = "0")</Condition>			
        <ComponentRef Id="CleanupConfFolder"  /> 
      </Feature>
      -->
		    <!-- SRP: xxxxxxxxxxxxxxxx
    <DirectoryRef Id="CONFFOLDER">
      <Component Id="CleanupConfFolder" Guid="*">
        <RegistryValue Root="HKLM" Key="SOFTWARE\Saltstack\Salt Minion" Name="ConfPath" Type="string" Value="[CONFFOLDER]" KeyPath="yes" /> <util:RemoveFolderEx On="uninstall" Property="CONFFOLDER" />
      </Component>
    </DirectoryRef>
    <Property Id="CONFFOLDER">
      <RegistrySearch  Root="HKLM" Key="SOFTWARE\Saltstack\Salt Minion" Name="ConfPath" Type="raw"  Id="CONFFOLDER_REGSEARCH" />
    </Property>
    -->
		
		
		    <!--SOLUTION NOT NEIL BEGIN             http://stackoverflow.com/questions/8258009/wix-condition-on-property-not-working 
    http://stackoverflow.com/questions/31306509/wix-set-property-from-registry-during-uninstall -->
    

    <Property Id="CONFFOLDER" Secure="yes">
      <RegistrySearch  Root="HKLM" Key="SOFTWARE\Saltstack\Salt Minion" Name="ConfPath" Type="raw"  Id="CONFFOLDER_REGSEARCH" />
    </Property>

    <CustomAction Id="CA.SetDataFolder" Property="P.REMOVEDATAFOLDER" Value='[CONFFOLDER]'  Execute='immediate' />
    

    <DirectoryRef Id="CONFFOLDER">
      <Component  t Id="C.RemoveDataFolder" Guid="18b9737f-bd95-47f5-9fd2-1946c187c505" KeyPath="yes"> <!-- https://www.guidgen.com/ -->
        <util:RemoveFolderEx On="uninstall" Property="P.REMOVEDATAFOLDER" />
      </Component>
    </DirectoryRef>


    <InstallExecuteSequence>
      <Custom Action="CA.SetDataFolder" After="AppSearch" >CONFFOLDER</Custom>
      <Custom Action="C.RemoveDataFolder" After="InstallInitialize" >KEEP_CONFIG = "0"</Custom>
    </InstallExecuteSequence>
    <!--SOLUTION NEIL END-->
		