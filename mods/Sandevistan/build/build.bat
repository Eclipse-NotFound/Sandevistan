@echo off
rem Sandevistan mod build script (ASCII only - cmd parses by system codepage)
rem Toolchain (probed 2026-08-27, shared with TDFC):
rem   mxmlc 4.16.1 + AIR SDK 51: D:\RemainsMod\mods\Sandevistan\build\tools
rem   Java: Adobe Animate 2024 bundled JRE (system has no standalone JDK)
rem Output: build\out\SandevistanMod.swf (copy to release\ after build)

setlocal
set "JAVA_HOME=D:\Program Files\Adobe Animate 2024\jre"
set "PATH=%JAVA_HOME%\bin;%PATH%"
set "FLEXBIN=D:\RemainsMod\mods\Sandevistan\build\tools\flexsdk\bin"
cd /d "%~dp0.."
if not exist build\out mkdir build\out
call "%FLEXBIN%\compc.bat" -load-config build\sandy-config.xml -external-library-path=build\tools\airsdk\frameworks\libs\air\airglobal.swc -source-path=build\stubs-high-fps -include-classes=fe.serv.Gov60 -output build\out\Gov60Stubs.swc
if errorlevel 1 exit /b 1
"%FLEXBIN%\mxmlc.bat" -load-config build\sandy-config.xml -output build\out\SandevistanMod.swf src\SandevistanMod.as
if errorlevel 1 exit /b 1
echo [OK] SandevistanMod.swf built
