PowerShell Set-MpPreference -DisableRealtimeMonitoring $true
timeout 2

pushd CustomAction-cs-0               &  call build.cmd & popd
pushd CustomAction-vbs-0-DeleteFolder &  call build.cmd & popd
pushd firegiant                       &  call build.cmd & popd
pushd RemoveFile-0-unconditionally    &  call build.cmd & popd
pushd RemoveFile-1-conditionally      &  call build.cmd & popd
pushd RemoveFolderEx                  &  call build.cmd& popd
pushd single_file                     &  call build.cmd& popd
pushd WixUI_InstallDir-0              &  call build.cmd & popd
pushd WixUI_Minimal                   &  call build.cmd& popd
pushd WixUI_Mondo-ExitDialog-on-install-notepad  &  call build.cmd & popd
pushd WixUI_Mondo-HelloWorldDialog               &  call build.cmd & popd


PowerShell Set-MpPreference -DisableRealtimeMonitoring $false

