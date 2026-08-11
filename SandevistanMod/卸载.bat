@echo off
title Sandevistan Mod - Uninstall
echo ============================================
echo   Sandevistan Mod - Uninstall (restore originals)
echo ============================================
echo.
setlocal
set "MODDIR=%~dp0"
set "GAMEDIR=%MODDIR%.."

if not exist "%MODDIR%backup\pfe_1.02_original.swf" (
    echo [NOTE] No backup found in SandevistanMod\backup\.
    echo        If the game was modified by other mods, restore manually.
    pause
    exit /b 0
)

echo [RESTORE] Restoring original files...
copy /y "%MODDIR%backup\pfe_1.02_original.swf" "%GAMEDIR%\pfe.swf"       >nul
copy /y "%MODDIR%backup\pfe_1.03_original.swf" "%GAMEDIR%\DLC\pfe.swf"   >nul
copy /y "%MODDIR%backup\pfe_1.04_original.swf" "%GAMEDIR%\DLC\pfeUI.swf" >nul

echo.
echo Original files restored. Backups kept in SandevistanMod\backup\.
echo To reinstall, run Install.bat again.
echo.
pause
