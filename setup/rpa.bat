@ECHO OFF
:: This batch file open the powershell in administrator mode.
TITLE PowerShell - Administrator
ECHO Please wait... Opening the powershell windows.
PowerShell -Command "& {Set-ExecutionPolicy AllSigned}"
PowerShell -Command "& {Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine}"
PowerShell -Command "& {Get-ExecutionPolicy}"
powershell -Command "& ""C:\setup\install.ps1"""
PAUSE