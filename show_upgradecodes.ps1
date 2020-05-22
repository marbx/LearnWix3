$wmipackages = Get-WmiObject -Class win32_product
$wmiproperties = gwmi -Query "SELECT ProductCode,Value FROM Win32_Property WHERE Property='UpgradeCode'"
$packageinfo = New-Object System.Data.Datatable
[void]$packageinfo.Columns.Add("Name")
[void]$packageinfo.Columns.Add("ProductCode")
[void]$packageinfo.Columns.Add("UpgradeCode")

foreach ($package in $wmipackages)
{
    $foundupgradecode = $false # Assume no upgrade code is found

    foreach ($property in $wmiproperties) {

        if ($package.IdentifyingNumber -eq $property.ProductCode) {
           [void]$packageinfo.Rows.Add($package.Name,$package.IdentifyingNumber, $property.Value)
           $foundupgradecode = $true
           break
        }
    }

    if(-Not ($foundupgradecode)) {
         # No upgrade code found, add product code to list
         [void]$packageinfo.Rows.Add($package.Name,$package.IdentifyingNumber, "")
    }

}

$packageinfo | Format-table ProductCode, UpgradeCode, Name

# Enable the following line to export to CSV (good for annotation). Set full path in quotes
# $packageinfo | Export-Csv "[YourFullWriteablePath]\MsiInfo.csv"

# https://stackoverflow.com/questions/46637094/how-can-i-find-the-upgrade-code-for-an-installed-msi-file