@echo off
title Morphscape RSPS Setup
color 0B
echo.
echo ============================================
echo   MORPHSCAPE RSPS - SETUP
echo ============================================
echo.

set MORPHSCAPE_DIR=%USERPROFILE%\morphscape

echo [1/5] Checking Git...
git --version >nul 2>&1
if errorlevel 1 (
    echo   ERROR: Git not installed. Get it from https://git-scm.com
    pause
    exit /b 1
)
echo   OK

echo [2/5] Creating workspace at %MORPHSCAPE_DIR%...
if not exist "%MORPHSCAPE_DIR%" mkdir "%MORPHSCAPE_DIR%"
cd /d "%MORPHSCAPE_DIR%"
echo   OK

echo [3/5] Cloning RSMod v2 engine...
if not exist "%MORPHSCAPE_DIR%\rsmod" (
    git clone https://github.com/rsmod/rsmod.git rsmod
) else (
    echo   Already exists - skipping
)
echo   OK

echo [4/5] Cloning Morphscape repos...
if not exist "%MORPHSCAPE_DIR%\morphscape-server" (
    git clone https://github.com/MisTAiM/morphscape-server.git morphscape-server
)
if not exist "%MORPHSCAPE_DIR%\morphscape-plugins" (
    git clone https://github.com/MisTAiM/morphscape-plugins.git morphscape-plugins
)
echo   OK

echo [5/5] Downloading RSProx client...
if not exist "%MORPHSCAPE_DIR%\RSProxSetup.exe" (
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/blurite/rsprox/releases/download/v1.0/RSProxSetup.exe' -OutFile '%MORPHSCAPE_DIR%\RSProxSetup.exe'"
)
echo   OK

echo.
echo ============================================
echo   DONE! Files are at: %MORPHSCAPE_DIR%
echo ============================================
echo.
echo NEXT STEPS:
echo   1. Open IntelliJ - File - Open - %MORPHSCAPE_DIR%\rsmod
echo   2. Click "Load Gradle Project" and wait for sync
echo   3. Select "GameServer" in top-right dropdown, click Run
echo   4. Install RSProx: %MORPHSCAPE_DIR%\RSProxSetup.exe
echo   5. Tell Claude you are ready
echo.
explorer "%MORPHSCAPE_DIR%"
pause
