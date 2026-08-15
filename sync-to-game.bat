@echo off
title RemainsMod - sync Sandevistan to game dir
echo ============================================================
echo   Sync repo -^> game dir (this repo's own scope ONLY)
echo
echo   mods\Sandevistan    full mirror of this mod (never touches
echo                       other agents' mods under game-dir mods\)
echo   shared-knowledge    additive sync (never deletes files
echo                       contributed by other agents)
echo   game-reference      additive sync (never deletes files
echo                       contributed by other agents)
echo ============================================================
setlocal
set "REPO=%~dp0"
set "GAME=C:\Program Files (x86)\Steam\steamapps\common\Remains"

if not exist "%GAME%\Remains.exe" (
    echo [ERROR] Game dir not found: %GAME%
    echo         Update GAME= at the top of this script if Steam moved it.
    pause
    exit /b 1
)

echo [1/3] Mirroring mods\Sandevistan  (excluding build\ and config.txt) ...
robocopy "%REPO%mods\Sandevistan" "%GAME%\mods\Sandevistan" /MIR /XD build /XF config.txt /NFL /NDL /NJH /NJS

echo [2/3] Additive syncing shared-knowledge\  (no deletion) ...
robocopy "%REPO%shared-knowledge" "%GAME%\shared-knowledge" /E /NFL /NDL /NJH /NJS

echo [3/3] Additive syncing game-reference\  (no deletion) ...
robocopy "%REPO%game-reference" "%GAME%\game-reference" /E /NFL /NDL /NJH /NJS

echo.
echo Done.
echo   - Other agents' files in the game dir are NEVER deleted by this script.
echo   - config.txt is NOT overwritten (live user settings).
echo   - Patched game SWFs (pfe.swf / DLC) are installed by
echo     mods\Sandevistan\release\安装.bat
pause
