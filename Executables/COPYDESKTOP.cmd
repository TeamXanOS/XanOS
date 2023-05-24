@echo off
setlocal EnableDelayedExpansion

for /f "usebackq delims=" %%a in (`dir /b /a:d "!SystemDrive!\Users" ^| findstr /v /i /x /c:"Public" /c:"Default User" /c:"All Users"`) do (
	robocopy "Configuration" "!SystemDrive!\Users\%%a\Desktop\Configuration" /e /purge /im /it /np
)
