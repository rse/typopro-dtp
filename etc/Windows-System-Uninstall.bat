@echo off
rem ##
rem ##  Windows-System-Uninstall.bat (shell wrapper)
rem ##

powershell -command "Set-ExecutionPolicy Unrestricted"
powershell .\Windows-Util.ps1 -forSystem -doUninstall

