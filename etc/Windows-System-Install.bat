@echo off
rem ##
rem ##  Windows-System-Install.bat (shell wrapper)
rem ##

powershell -command "Set-ExecutionPolicy Unrestricted"
powershell .\Windows-Util.ps1 -forSystem -doInstall

