@echo off
title Morphscape Setup
echo.
echo === MORPHSCAPE RSPS SETUP ===
echo.

set ROOT=%USERPROFILE%\morphscape
if not exist "%ROOT%" mkdir "%ROOT%"
cd /d "%ROOT%"

echo [1/4] Cloning RSMod v2 engine...
if not exist "%ROOT%\rsmod" (
    git clone https://github.com/rsmod/rsmod.git rsmod
) else (
    echo Already exists, skipping.
)

echo [2/4] Cloning morphscape-plugins...
if not exist "%ROOT%\morphscape-plugins" (
    git clone https://github.com/MisTAiM/morphscape-plugins.git morphscape-plugins
) else (
    echo Already exists, skipping.
)

echo [3/4] Copying morphscape-server data into rsmod...
if exist "%USERPROFILE%\morphscape-server\data" (
    xcopy /E /I /Y "%USERPROFILE%\morphscape-server\data" "%ROOT%\rsmod\data"
)

echo [4/4] Downloading RSProx client...
if not exist "%ROOT%\RSProxSetup.exe" (
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/blurite/rsprox/releases/download/v1.0/RSProxSetup.exe' -OutFile '%ROOT%\RSProxSetup.exe'"
    echo RSProx downloaded.
) else (
    echo RSProx already downloaded.
)

echo.
echo === DONE ===
echo Files are at: %ROOT%
echo.
echo NOW:
echo   1. Open IntelliJ
echo   2. File - Open - %ROOT%\rsmod
echo   3. Click Load Gradle Project
echo   4. Run GameServer config
echo   5. Install %ROOT%\RSProxSetup.exe
echo.
explorer "%ROOT%"
pause
