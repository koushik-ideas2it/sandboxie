@ECHO OFF
@setlocal enableextensions
@cd /d "%~dp0"
echo.|pushd %~dp0 
:: This batch file open the powershell in administrator mode.
TITLE PowerShell - Administrator
ECHO Please wait... Opening the powershell windows.
powershell -command "&{ start-process powershell -ArgumentList '-ExecutionPolicy Bypass -noprofile -file C:\script\psfile.ps1' -verb RunAs}"
PowerShell -Command "& {Set-ExecutionPolicy AllSigned}"
PowerShell -Command "& {Get-ExecutionPolicy}"
PowerShell -Command "& {Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))}"
PowerShell -Command "& {choco install googlechrome -command Y}"

PAUSE
