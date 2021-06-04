# Uninstall by upgradecode
# Uninstall requires productcode
# This script finds the productcode by upgradecode

$upgradecode = $Args[0]

# Check argument as productkey
$scrambledUpgradeCode = ""
if ($upgradecode.SubString(8,1) -ne '-' -or `
    $upgradecode.SubString(13,1) -ne '-' -or `
    $upgradecode.SubString(18,1) -ne '-' -or `
    $upgradecode.SubString(23,1) -ne '-') {
        Write-Host -ForegroundColor Red No dashes in UpgradeCode as input
        exit(1)
}
$upgradecode=$upgradecode.Replace("-","")

if ($upgradecode -match '^[0-9A-Z]{32}$') {
    # The upgradecode  in registry is scrambled
    $scrambledUpgradeCode = ""
    $lastIndex = 0
    foreach ($index in @(8, 4, 4, 2, 2, 2, 2, 2, 2, 2, 2)) {
        $chunk = $upgradecode.Substring($lastIndex, $index) -split ''
        [array]::Reverse($chunk)
        $scrambledUpgradeCode += $chunk -join ''
        $lastIndex += $index
    }
    #Write-Host -ForegroundColor Yellow     $scrambledUpgradeCode
} else {
    Write-Host -ForegroundColor Red Not an upgradecode
    exit(1)
}

if ($scrambledUpgradeCode -notmatch '^[0-9A-Z]{32}$') {
    Write-Host -ForegroundColor Red Not an upgradecode
    exit(1)
}

# Use scrambled upgradecode to look up scrambled productcode
$upgradecodeRegKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UpgradeCodes\$scrambledUpgradeCode"

if (Test-Path $upgradecodeRegKey) {           # The scrambled productcode is the only entry
    $scrambledProductcode = $((Get-ItemProperty $upgradecodeRegKey).PSObject.Properties)[0].Name.ToString()
    if ($scrambledProductcode -match '^[0-9A-Z]{32}$') {            # Reverse chunks
        #Write-Host -ForegroundColor Yellow $scrambledProductcode.Insert(20,'-').Insert(16,'-').Insert(12,'-').Insert(8,'-')
        $productcode = ""
        $lastIndex = 0
        # Unscramble the productcode
        foreach ($index in @(8, 4, 4, 2, 2, 2, 2, 2, 2, 2, 2)) {
            $chunk = $scrambledProductcode.Substring($lastIndex, $index) -split ''
            [array]::Reverse($chunk)
            $productcode += $chunk -join ''
            $lastIndex += $index
        }
        # Format productcode with dashes and curly braces
        $productcode = $productcode.Insert(20,'-').Insert(16,'-').Insert(12,'-').Insert(8,'-')
        $productcode = "{$productcode}"
        # Uninstall
        Write-Host -ForegroundColor Yellow msiexec /X $productcode
        $msiexitcode = (Start-Process -FilePath "msiexec.exe" -ArgumentList "/x $productcode /l*v log-uninstall.log /qb" -Wait -Passthru).ExitCode
        if ($msiexitcode -eq 0) {
            Write-Host -ForegroundColor Green "Done"
        } else {
            Write-Host -ForegroundColor Red "Exited with $msiexitcode"
        }
    } else {
        Write-Host -ForegroundColor Red Cannot uninstall
        exit(1)
    }
} else {
    Write-Host -ForegroundColor Yellow Not installed
}
