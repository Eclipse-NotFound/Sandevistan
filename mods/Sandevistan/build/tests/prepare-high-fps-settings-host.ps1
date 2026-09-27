param([string]$GameRoot='D:\Program Files\Steam\steamapps\common\Remains')
$ErrorActionPreference='Stop'
$modRoot=Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$out=Join-Path $modRoot 'build\out\music-guide-20260927'
$java='D:\Program Files\Adobe Animate 2024\jre\bin\java.exe'
$ffdec=Join-Path $modRoot 'build\tools\ffdec\ffdec-cli.jar'
New-Item -ItemType Directory -Path "$out\patch" -Force | Out-Null
& $java -jar $ffdec -selectclass MainFE,fe.serv.Gov60,fe.MainMenu,fe.inter.Camera -export script "$out\before" "$GameRoot\pfe60.swf"
if($LASTEXITCODE -ne 0){throw 'Export failed'}
$src=[IO.File]::ReadAllText("$out\before\scripts\MainFE.as")
$anchor='dir == "ModSettings" && entry == "ModSettingsMod"'
if(!$src.Contains($anchor) -or $src.Contains('dir == "ModLoader"')){throw 'Unexpected high-FPS allowlist; review before patching'}
$src=$src.Replace($anchor,$anchor+' || dir == "ModLoader" && entry == "ModLoaderMod"')
[IO.File]::WriteAllText("$out\patch\MainFE.as",$src,[Text.UTF8Encoding]::new($false))
& $java -jar $ffdec -importScript "$GameRoot\pfe60.swf" "$out\pfe60-with-current-settings.swf" "$out\patch"
if($LASTEXITCODE -ne 0){throw 'Import failed'}
& $java -jar $ffdec -selectclass MainFE,fe.serv.Gov60,fe.MainMenu,fe.inter.Camera -export script "$out\after" "$out\pfe60-with-current-settings.swf"
if($LASTEXITCODE -ne 0){throw 'Readback failed'}
foreach($r in @('fe\serv\Gov60.as','fe\MainMenu.as','fe\inter\Camera.as')){if((Get-FileHash -LiteralPath "$out\before\scripts\$r").Hash -ne (Get-FileHash -LiteralPath "$out\after\scripts\$r").Hash){throw "Host mechanism changed: $r"}}
if(![IO.File]::ReadAllText("$out\after\scripts\MainFE.as").Contains('dir == "ModLoader" && entry == "ModLoaderMod"')){throw 'New settings provider absent'}
Get-FileHash -LiteralPath "$GameRoot\pfe60.swf","$out\pfe60-with-current-settings.swf"