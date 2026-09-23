param([string]$GameRoot='D:\Program Files\Steam\steamapps\common\Remains')
$ErrorActionPreference='Stop'
$modRoot=Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$out=Join-Path $modRoot 'build\out\high-fps'
$java='D:\Program Files\Adobe Animate 2024\jre\bin\java.exe'
$ffdec=Join-Path $modRoot 'build\tools\ffdec\ffdec-cli.jar'
New-Item -ItemType Directory -Path "$out\loader-patch" -Force | Out-Null
& $java -jar $ffdec -selectclass MainFE,fe.serv.Gov60 -export script "$out\host60" "$GameRoot\pfe60.swf"
if($LASTEXITCODE -ne 0){throw 'High-FPS host export failed'}
& $java -jar $ffdec -selectclass MainFE -export script "$out\host-current" "$GameRoot\pfe.swf"
if($LASTEXITCODE -ne 0){throw 'Installed loader export failed'}
$original=[IO.File]::ReadAllText("$out\host60\scripts\MainFE.as")
if($original.Contains('loadModsFromManifest') -or $original.Contains('loadSandevistanMod')){throw 'High-FPS host already has a loader; review and merge instead of replacing'}
if(!(Test-Path -LiteralPath "$out\host60\scripts\fe\serv\Gov60.as")){throw 'Expected Gov60 scheduler absent'}
$src=[IO.File]::ReadAllText("$out\host-current\scripts\MainFE.as")
$anchor='if(this.modLoaderTrimText(String(parts[colIdx])) == "1")'
if(($src.Split(@($anchor),[StringSplitOptions]::None)).Length -ne 2){throw 'Loader whitelist anchor changed'}
# This candidate enables only the requested mod and its menu provider. Other
# manifest entries remain available to the ordinary host, without auto-enabling
# unadapted gameplay mods in the high-FPS entry.
$src=$src.Replace($anchor, 'if((dir == "Sandevistan" && entry == "SandevistanMod" || dir == "ModSettings" && entry == "ModSettingsMod") && this.modLoaderTrimText(String(parts[colIdx])) == "1")')
[IO.File]::WriteAllText("$out\loader-patch\MainFE.as",$src,[Text.UTF8Encoding]::new($false))
& $java -jar $ffdec -importScript "$GameRoot\pfe60.swf" "$out\pfe60-with-loader.swf" "$out\loader-patch"
if($LASTEXITCODE -ne 0){throw 'Candidate import failed'}
& $java -jar $ffdec -selectclass MainFE,fe.serv.Gov60,fe.MainMenu,fe.inter.Camera -export script "$out\candidate-readback" "$out\pfe60-with-loader.swf"
if($LASTEXITCODE -ne 0){throw 'Candidate readback failed'}
Get-FileHash -LiteralPath "$GameRoot\pfe60.swf","$out\pfe60-with-loader.swf"
Write-Output 'Candidate only; no installed host, descriptor, config or manifest was modified.'