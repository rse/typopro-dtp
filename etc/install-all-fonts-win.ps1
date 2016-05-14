##
##  install-all-fonts-win.ps1 (PowerShell script)
##

#   determine the system's font folder
$Shell = New-Object -ComObject Shell.Application
$ssfFonts = 0x14
$SystemFontsFolder = $Shell.Namespace($ssfFonts)
$SystemFontsPath = $SystemFontsFolder.Self.Path

#   remember if a reboot may be necessary afterwards
$rebootFlag = $false

#   iterate over all TypoPRO files
$FontFiles = Get-ChildItem "..\dtp" -Include "*.ttf" -Recurse
foreach ($FontFile in $FontFiles) {
    if (Test-Path $FontFile.FullName -pathType leaf) {
        $targetPath = Join-Path $SystemFontsPath $FontFile.Name
        if (Test-Path $targetPath) {
            Write-Host "++ installing $($FontFile.Name) [REPLACE]"
		    Remove-Item $targetPath -Force
		    Copy-Item $FontFile.FullName $targetPath -Force
            $rebootFlag = $true
        }
        else {
            Write-Host "++ installing $($FontFile.Name)"
            $SystemFontsFolder.CopyHere($FontFile.fullname)
        }
    }
}

#   follow-up message
if ($rebootFlag) {
    Write-Host "NOTICE: At least one existing font was overwritten."
    Write-Host "NOTICE: A reboot may be necessary!"
}

