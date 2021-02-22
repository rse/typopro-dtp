##
##  Windows-util.ps1 (PowerShell script)
##

#   determine command-line options
param (
    [switch]$forUser     = $false,
    [switch]$forSystem   = $false,
    [switch]$doInstall   = $false,
    [switch]$doUninstall = $false
)

#   determine administrator privileges
$theuser = [Security.Principal.WindowsIdentity]::GetCurrent()
$isAdmin = (New-Object Security.Principal.WindowsPrincipal $theuser).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

#   sanity check execution scenarios
if ($forSystem -and (-not ($isAdmin))) {
    Write-Host "** ERROR: installing for system requested as non-administrator"
    sleep 2
    exit 1
}
if ($forUser -and $isAdmin) {
    Write-Host "** ERROR: installing for user requested as administrator"
    sleep 2
    exit 1
}

#   determine the system's font folder and corresponding registry tree
if ($isAdmin) {
    $fontFilePath     = "$env:SYSTEMROOT\Fonts"
    $fontRegistryPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
}
else {
    $fontFilePath     = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
    $fontRegistryPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
}

#   display hint about installation
if ($doInstall) {
    Write-Host "## Installing msg Fonts"
}
else {
    Write-Host "## Uninstalling msg Fonts"
}
Write-Host "++ Font file tree:     $($fontFilePath)"
Write-Host "++ Font registry tree: $($fontRegistryPath)"

#   remember if a reboot may be necessary afterwards
#   (which is the case if a font is re-installed in-place)
$rebootFlag = $false

#   iterate over all font files
$FontFiles = Get-ChildItem "..\dtp" -Include "*.ttf" -Recurse
foreach ($FontFile in $FontFiles) {
    if (Test-Path $FontFile.FullName -pathType leaf) {
        #   determine font name
        $shell = New-Object -COMObject Shell.Application
        $folder = Split-Path $FontFile
        $file = Split-Path $FontFile -Leaf
        $shellfolder = $shell.Namespace($folder)
        $shellfile = $shellfolder.ParseName($file)
        $FontName = $shellfolder.getDetailsOf($shellfile, 21)

        #   determine target
        $FontFullName = "$($FontName) (TrueType)"
        $targetPath = Join-Path $fontFilePath $FontFile.Name

        #   dispatch according to action
        if ($doInstall) {
            Write-Host "-- Installing font ""$($FontName)"""

            #   install font file
            Write-Host "   File-Source:  $($FontFile.FullName)"
            if (Test-Path $targetPath) {
                Write-Host "   File-Target:  $($targetPath) [REPLACE]"
                Remove-Item $targetPath -Force
                Copy-Item $FontFile.FullName $targetPath -Force
                $rebootFlag = $true
            }
            else {
                Write-Host "   File-Target:  $($targetPath) [NEW]"
                Copy-Item $FontFile.FullName $targetPath
            }

            #   register font file
            $regTest = Get-ItemProperty -Path $fontRegistryPath -Name "$FontFullName" -ErrorAction SilentlyContinue
            if ($regTest) {
                Write-Host "   Registry-Key: ""$($FontFullName)"" [REPLACE]"
                Set-ItemProperty -Name $FontFullName -Path $fontRegistryPath -Value $targetPath | out-null
                $rebootFlag = $true
            }
            else {
                Write-Host "   Registry-Key: ""$($FontFullName)"" [NEW]"
                New-ItemProperty -Name $FontFullName -Path $fontRegistryPath -PropertyType string -Value $targetPath | out-null
            }
        }
        else {
            Write-Host "-- Uninstalling font ""$($FontName)"""

            #   unregister font file
            $regTest = Get-ItemProperty -Path $fontRegistryPath -Name "$FontFullName" -ErrorAction SilentlyContinue
            if ($regTest) {
                Write-Host "   Registry-Key: ""$($FontFullName)"" [DELETE]"
                Remove-ItemProperty -Name $FontFullName -Path $fontRegistryPath -Force | out-null
                sleep 1
                $rebootFlag = $true
            }

            #   uninstall font file
            if (Test-Path $targetPath) {
                Write-Host "   File-Target:  $($targetPath) [DELETE]"
                Remove-Item $targetPath -Force
                $rebootFlag = $true
            }
        }
    }
}

#   follow-up message
if ($rebootFlag) {
    Write-Host "** NOTICE: At least one existing font file was overwritten or the registry changed."
    Write-Host "** NOTICE: As a result, a system reboot is now strongly advised!"
    sleep 1
}

