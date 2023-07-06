@echo off
pushd "%CD%"
CD /D "%~dp0"
	net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Administrative Permissions detected, continuing.
        goto startmse2
    ) else (
        echo Error: No administrative permissions. Please relaunch with Adnimistrative Permissions to remove Microsoft Edge.
        pause
        exit /b
    )
:startmse2
echo Killing Microsoft Edge...
taskkill /F /IM msedge.exe
cd /d "%ProgramFiles(x86)%\Microsoft"
for /f "tokens=1 delims=\" %%i in ('dir /B /A:D "%ProgramFiles(x86)%\Microsoft\Edge\Application" ^| find "."') do (set "edge_chromium_package_version=%%i")
if defined edge_chromium_package_version (
		echo Removing %edge_chromium_package_version%...
		Edge\Application\%edge_chromium_package_version%\Installer\setup.exe --uninstall --force-uninstall --msedge --system-level --verbose-logging
		EdgeCore\%edge_chromium_package_version%\Installer\setup.exe --uninstall --force-uninstall --msedge --system-level --verbose-logging
		powershell.exe -Command "Get-AppxPackage *MicrosoftEdge* | Remove-AppxPackage"
	) else (
		echo Microsoft Edge [Chromium] not found, skipping.
	)
cd /d
for /f "tokens=8 delims=\" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" ^| findstr "Microsoft-Windows-Internet-Browser-Package" ^| findstr "~~"') do (set "edge_legacy_package_version=%%i")
if defined edge_legacy_package_version (
		echo Removing %edge_legacy_package_version%...
		reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%edge_legacy_package_version%" /v Visibility /t REG_DWORD /d 1 /f
		reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%edge_legacy_package_version%\Owners" /va /f
		dism /online /Remove-Package /PackageName:%edge_legacy_package_version%
		powershell.exe -Command "Get-AppxPackage *edge* | Remove-AppxPackage"
	) else (
		echo Microsoft Edge [Legacy/UWP] not found, skipping.
	)

for /f "tokens=8 delims=\" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" ^| findstr "Microsoft-Windows-MicrosoftEdgeDevToolsClient-Package" ^| findstr "~~"') do (set "melody_package_name=%%i")
if defined melody_package_name (
		echo Removing %melody_package_name%...
		reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%melody_package_name%" /v Visibility /t REG_DWORD /d 1 /f
		reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%melody_package_name%\Owners" /va /f
		dism /online /Remove-Package /PackageName:%melody_package_name% /NoRestart
	) else (
		echo Package not found.
	)

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\EdgeUpdate" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d 1
reg delete "HKLM\SOFTWARE\Microsoft\Internet Explorer" /f
reg delete "HKLM\SOFTWARE\RegisteredApplications" /v "Internet Explorer" /f
reg delete "HKLM\SOFTWARE\Clients\StartMenuInternet\IEXPLORE.EXE" /f
exit