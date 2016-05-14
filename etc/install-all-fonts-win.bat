@echo off
rem ##
rem ##  install-all-fonts-win.bat (shell wrapper)
rem ##

powershell -command "Set-ExecutionPolicy Unrestricted"
powershell .\install-all-fonts-win.ps1

