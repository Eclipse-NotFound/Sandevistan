@echo off
title RemainsMod - sync mirror to game dir
echo ============================================
echo   Sync repo mods/ + shared-knowledge/
echo   into the game directory (mirror copy)
echo ============================================
setlocal
set "REPO=%~dp0"
set "GAME=C:\Program Files (x86)\Steam\steamapps\common\Remains"

if not exist "%GAME%\Remains.exe" (
    echo [ERROR] Game dir not found: %GAME%
    echo         Update GAME= at the top of this script if Steam moved it.
    pause
    exit /b 1
)

echo [1/2] Syncing mods\  (excluding build\ and config.txt) ...
robocopy "%REPO%mods" "%GAME%\mods" /MIR /XD build /XF config.txt /NFL /NDL /NJH /NJS

echo [2/2] Syncing shared-knowledge\ ...
robocopy "%REPO%shared-knowledge" "%GAME%\shared-knowledge" /MIR /NFL /NDL /NJH /NJS

echo.
echo Mirror updated.
echo   - config.txt is NOT overwritten (live user settings in game dir).
echo   - Patched game SWFs (pfe.swf / DLC) are installed by release\安装.bat
echo     (run it after a sync if the patched files changed).
pause
