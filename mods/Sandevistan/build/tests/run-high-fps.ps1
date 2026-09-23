param([string]$GameRoot='D:\Program Files\Steam\steamapps\common\Remains', [string]$Source='', [switch]$ExpectFailure, [switch]$Smoke, [string]$Artifact='', [switch]$WithSettings, [string]$HostSwf="", [string]$Fps="60", [switch]$SwitchModes, [switch]$Combat, [switch]$InstalledManifest)
$ErrorActionPreference='Stop'
if($Artifact -and !$Smoke){throw 'Artifact mode requires -Smoke'}
$modRoot=Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
if(!$Source){$Source=Join-Path $modRoot 'src\SandevistanMod.as'}
$runId=Get-Date -Format 'yyyyMMddHHmmssfff'
$appId="pfe-sandy-fps-$runId"
$appRoot=Join-Path $modRoot "build\out\high-fps\$runId"
$cache=Join-Path $modRoot 'build\out\high-fps\assets'
New-Item -ItemType Directory -Path $appRoot,$cache -Force | Out-Null
# Read-only copies of the installed host/resources; never edit production descriptors or saves.
foreach($f in Get-ChildItem -LiteralPath $GameRoot -File){
 if($f.Name -match '^(pfe|sprite\d*|texture\d*|sound(_unit|_weapon)?)\.swf$|^(text_.*|lang|launcher_text)\.xml$'){
   $dest=Join-Path $cache $f.Name
   if(!(Test-Path -LiteralPath $dest) -or (Get-Item -LiteralPath $dest).LastWriteTimeUtc -lt $f.LastWriteTimeUtc){Copy-Item -LiteralPath $f.FullName -Destination $dest}
   if($f.Name -eq "pfe.swf" -and $HostSwf){Copy-Item -LiteralPath $HostSwf -Destination (Join-Path $appRoot $f.Name); continue}
   New-Item -ItemType HardLink -Path (Join-Path $appRoot $f.Name) -Target $dest | Out-Null
 }
}
"fps=$Fps`nhud=0" | Set-Content -LiteralPath (Join-Path $appRoot 'pfe60.cfg')
Copy-Item -LiteralPath (Join-Path $GameRoot 'Rooms') -Destination (Join-Path $appRoot 'Rooms') -Recurse
$rel=Join-Path $appRoot 'mods\Sandevistan\release'
New-Item -ItemType Directory -Path $rel -Force | Out-Null
'Sandevistan|SandevistanMod|1|1|1' | Set-Content -LiteralPath (Join-Path $appRoot 'mods\loader-manifest.txt')
if($WithSettings){
 $settingsRel=Join-Path $appRoot 'mods\ModSettings\release'
 New-Item -ItemType Directory -Path $settingsRel -Force | Out-Null
 Copy-Item -LiteralPath (Join-Path $GameRoot 'mods\ModSettings\release\ModSettingsMod.swf') -Destination (Join-Path $settingsRel 'ModSettingsMod.swf')
 "ModSettings|ModSettingsMod|1|0|0`nSandevistan|SandevistanMod|1|1|1" | Set-Content -LiteralPath (Join-Path $appRoot 'mods\loader-manifest.txt')
}
if($InstalledManifest){Copy-Item -LiteralPath (Join-Path $GameRoot 'mods\loader-manifest.txt') -Destination (Join-Path $appRoot 'mods\loader-manifest.txt')}
"debugtest=$([int][bool]$Smoke)`ndiaglog=1`nmusicon=$([int][bool]$Smoke)`nesandyenabled=0" | Set-Content -LiteralPath (Join-Path $rel 'config.txt')
if($Smoke){Copy-Item -LiteralPath (Join-Path $modRoot 'release\sandy_theme.mp3') -Destination (Join-Path $rel 'sandy_theme.mp3')}
$srcText=[IO.File]::ReadAllText($Source)
if(!$Smoke){
 $anchor='      private function stepDebugTest():void'
 if(!$srcText.Contains($anchor)){throw 'Probe anchor missing'}
 $srcText=$srcText.Replace($anchor,[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'high-fps-probe.inc'))+$anchor)

 $anchor='            onFrameInner();'
 if(!$srcText.Contains($anchor)){throw 'Frame driver anchor missing'}
 $srcText=$srcText.Replace($anchor, '            fpsBeforeFrame();'+"`n"+$anchor+"`n"+'            fpsAfterFrame();')
}
if($SwitchModes){$srcText=$srcText.Replace("fpsSwitchModes:Boolean = false", "fpsSwitchModes:Boolean = true")}
if($Combat){$srcText=$srcText.Replace("fpsCombat:Boolean = false", "fpsCombat:Boolean = true")}
$generated=Join-Path $appRoot 'SandevistanMod.as'
[IO.File]::WriteAllText($generated,$srcText,[Text.UTF8Encoding]::new($false))
$env:JAVA_HOME='D:\Program Files\Adobe Animate 2024\jre'
$env:PATH=$env:JAVA_HOME+'\bin;'+$env:PATH
if($Artifact){Copy-Item -LiteralPath $Artifact -Destination (Join-Path $rel 'SandevistanMod.swf')}else{
& (Join-Path $modRoot 'build\tools\flexsdk\bin\mxmlc.bat') "-load-config=$(Join-Path $modRoot 'build\sandy-config.xml')" "-source-path=$appRoot" "-source-path+=$modRoot\src" '-debug=false' "-output=$rel\SandevistanMod.swf" $generated
if($LASTEXITCODE -ne 0){throw 'Probe compilation failed'}
}
$desc=Join-Path $appRoot 'app_sandy_test.xml'
$xml=@"
<?xml version="1.0" encoding="utf-8"?>
<application xmlns="http://ns.adobe.com/air/application/30.0"><id>$appId</id><versionNumber>1.0</versionNumber><filename>Sandy death prediction test</filename><initialWindow><content>pfe.swf</content><visible>false</visible><width>1280</width><height>800</height><renderMode>direct</renderMode></initialWindow><supportedProfiles>extendedDesktop</supportedProfiles></application>
"@
[IO.File]::WriteAllText($desc,$xml,[Text.UTF8Encoding]::new($false))
$log=Join-Path $env:APPDATA "$appId\Local Store\sandy_modlog.txt"
Write-Output "RUN=$appRoot APPID=$appId LOG=$log"
$proc=$null
try {
 $args=@('-runtime',('"'+(Join-Path $GameRoot 'runtimes\air\win64')+'"'),('"'+$desc+'"'))
 $proc=Start-Process -FilePath (Join-Path $GameRoot 'adl64.exe') -ArgumentList $args -WorkingDirectory $appRoot -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $appRoot 'adl.stdout.txt') -RedirectStandardError (Join-Path $appRoot 'adl.stderr.txt')
 $deadline=(Get-Date).AddSeconds($(if($Smoke){360}else{90}))
 while(!$proc.HasExited -and (Get-Date) -lt $deadline){
  Start-Sleep -Milliseconds 1000
  $proc.Refresh()
  if(Test-Path -LiteralPath $log){
   $lines=Get-Content -LiteralPath $log -Tail 15
   if(($Smoke -and ($lines -match '\[TEST\].*SUMMARY')) -or (!$Smoke -and ($lines -match '\[FPS-TEST\] SUMMARY|\[FPS-TEST\] ERROR'))){break}
  }
 }
 if(Test-Path -LiteralPath $log){
  Copy-Item -LiteralPath $log -Destination (Join-Path $appRoot 'result.log')
  $results=Get-Content -LiteralPath $log | Where-Object {$_ -match '\[FPS-TEST\]|\[FPS-COST\]|\[TEST-ASSERT\]|SUMMARY|v1\.\d+ loaded|\[ERRDIALOG\]'}
  $results
  if($InstalledManifest){
   $statusPath=Join-Path (Split-Path $log -Parent) '#SharedObjects\ModLoader.sol'
   Copy-Item -LiteralPath $statusPath -Destination (Join-Path $appRoot 'ModLoader.sol')
   $loaderText=[Text.Encoding]::UTF8.GetString([IO.File]::ReadAllBytes($statusPath))
   if($loaderText -match 'err_' -or $loaderText -notmatch 'ok_ModSettingsMod' -or $loaderText -notmatch 'ok_SandevistanMod' -or [regex]::Matches($loaderText,'requested_').Count -ne 2){throw 'High-FPS loader allowlist failed'}
   Write-Output '[LOADER-TEST] installed-seven-entry-manifest loads-only-settings-and-sandy PASS'
  }
  if($Smoke){
   if(!($results -match '\[TEST\] SUMMARY pass=\d+ fail=0 ') -or ($results -match '\[ERRDIALOG\]')){throw 'Smoke assertions did not pass'}
   if($WithSettings -and (!($results -match 'settings-menu-opens=PASS') -or !($results -match 'menu-settings-save-reload=PASS') -or !($results -match 'hub-registered=PASS'))){throw 'Required menu integration checks missing'}
  }
  if(!$Smoke){
   if($results -match '\[FPS-TEST\] ERROR' -or !($results -match '\[FPS-TEST\] SUMMARY')){throw 'Probe did not complete'}
   $failed=[bool]($results -match '\[FPS-TEST\] SUMMARY FAIL')
   if($failed -ne [bool]$ExpectFailure){throw 'Unexpected probe verdict'}
  }
 }else{ Get-Content -LiteralPath (Join-Path $appRoot 'adl.stderr.txt'); throw 'No test log'}
} finally {
 if($proc -and !$proc.HasExited){Stop-Process -Id $proc.Id -ErrorAction SilentlyContinue}
 if(Test-Path -LiteralPath $desc){Remove-Item -LiteralPath $desc}
}