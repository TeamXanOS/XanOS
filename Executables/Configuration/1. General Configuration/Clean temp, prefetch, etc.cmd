@echo off
setlocal EnableDelayedExpansion

whoami /user | find /i "S-1-5-18" > nul 2>&1 || (
	call RunAsTI.cmd "%~f0" "%*"
	exit /b
)

:: Clean up temp folders
rd /s /q !TEMP!
rd /s /q !windir!\temp
md !TEMP!
md !windir!\temp

:: Fix errors 2502 and 2503 by fixing temp folder permissions
for /f "tokens=*" %%a in ('whoami') do (set USER=%%a)
icacls "C:\Windows\Temp" /grant:r !USER!:(OI)(CI)F /grant:r Administrators:(OI)(CI)F /T /Q

:: Clean up the Prefetch folder
rd /s /q !windir!\Prefetch

:: Delete unneeded files
for %%a in (log _mp tmp gid chk old) do (
    del /f /s /q !SystemDrive!\*.%%a
)

:: Clear the icon cache
del /a /q "!LOCALAPPDATA!\IconCache.db"
del /a /f /q "!LOCALAPPDATA!\Microsoft\Windows\Explorer\iconcache*"

:: Clear all Event Viewer logs
for /f "tokens=*" %%a in ('wevtutil el') do (
    wevtutil cl "%%a"
)

exit /b