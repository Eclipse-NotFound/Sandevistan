@echo off
title Sandevistan Mod - Install
echo ============================================
echo   Sandevistan Mod - Install
echo   Game: Fallout Equestria: REMAINS
echo ============================================
echo.
setlocal
set "MODDIR=%~dp0"
set "GAMEDIR=%MODDIR%..\..\.."

if not exist "%GAMEDIR%\pfe.swf" (
    echo [ERROR] pfe.swf not found!
    echo         This folder must live at mods\Sandevistan\release inside the game root.
    echo         The game root must contain pfe.swf, Remains.exe, etc.
    pause
    exit /b 1
)

echo Game dir: %GAMEDIR%
echo.

rem --- Backup originals (only if backup does not exist) ---
if not exist "%MODDIR%backup\pfe_1.02_original.swf" (
    echo [1/2] Backing up original files...
    mkdir "%MODDIR%backup" 2>nul
    copy /y "%GAMEDIR%\pfe.swf"      "%MODDIR%backup\pfe_1.02_original.swf"  >nul
    copy /y "%GAMEDIR%\DLC\pfe.swf"  "%MODDIR%backup\pfe_1.03_original.swf"  >nul
    copy /y "%GAMEDIR%\DLC\pfeUI.swf" "%MODDIR%backup\pfe_1.04_original.swf" >nul
    echo         Backed up to SandevistanMod\backup\
) else (
    echo [1/2] Backup already exists, skipping
)

rem --- Install patched files ---
echo [2/2] Installing mod patches...
if exist "%MODDIR%patched\pfe_1.02.swf"     copy /y "%MODDIR%patched\pfe_1.02.swf"     "%GAMEDIR%\pfe.swf"       >nul
if exist "%MODDIR%patched\pfe_1.03.swf"     copy /y "%MODDIR%patched\pfe_1.03.swf"     "%GAMEDIR%\DLC\pfe.swf"   >nul
if exist "%MODDIR%patched\pfe_1.04.swf"     copy /y "%MODDIR%patched\pfe_1.04.swf"     "%GAMEDIR%\DLC\pfeUI.swf" >nul

echo.
echo Done! Start the game via Steam as usual.
echo Press "\" (backslash) in game to trigger Sandevistan.
echo Config: mods\Sandevistan\release\config.txt  (F9 opens in-game panel)
echo.
pause
