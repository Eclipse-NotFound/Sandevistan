# Sandevistan

[English](README.md) · [简体中文](README.zh-CN.md)

Bullet-time / time-stop combat for **Fallout Equestria: REMAINS**: press one key, the world freezes while you line up the perfect move — then watch it replayed with ghost trails. Enemies can carry their own Sandevistan too.

## Features (v1.144)

- **Time stop** on a configurable hotkey (default `\`, 7 s default duration, separate cooldown), with a fast **replay** of your inputs afterwards (speed, ghost density and trail life all configurable).
- Ghost afterimages with adjustable blend mode, opacity and spawn interval; particle effects can keep animating or freeze during stop.
- **Shootable projectiles**: thrown grenades, missiles and launched shells get HP/armor and can be shot down — with per-weapon overrides (`projhp_<weaponId>` / `projarmor_<weaponId>`) for grenade, the Wildfire nuke, grenade launcher and missile launcher.
- **Enemy Sandevistan** (optional, off by default): equip lists of unit classes (raiders, merc griffons, alicorns, enclave, rangers, zebras) trigger their own time-stop on spotting you, with per-room quota, own duration/cooldown/speed settings and markers.
- **High-FPS hosts** (v1.144): follows the host logic clock at 90/120 fps for smooth stop and interpolation (verified 60/90/120).
- Rainbow or Edgerunner-style speed-mapped gradient colors, startup "mod loaded" marker, top status UI ("charging / active / replaying"), and an in-game **F9 parameter panel** for everything above.
- Optional theme music during stop (a copyrighted track is deliberately **not** redistributed; without the file the game simply stays silent — no features are affected).
- Sprint weapon swap (hold Shift + number keys) and aim-preserving quality-of-life tweaks.

## Requirements

- Fallout Equestria: REMAINS (1.02 recommended; the loader also supports 1.03/1.04).
- The one-time **ModLoader** game patch — see
  [ModLoader Releases](https://github.com/Eclipse-NotFound/ModLoader/releases) → `Remains-GamePatch`.

## Install

1. Download `Sandevistan_v1.144.zip` from [Releases](../../releases).
2. Copy the zip's `mods` folder into your game root (next to `pfe.swf`).
3. Restart the game; press `\` in game to trigger. A full Chinese manual (changelog since early versions) ships in the zip as `SANDY-MANUAL.txt`.

## Configuration

Everything lives in `mods/Sandevistan/release/config.txt` (restart to apply) or the **F9** in-game panel: `hotkey`, `duration` (frames, 30 = 1 s), `cooldown`, `replayspeed`, `ghostevery`, `fxrun`, `ghostblend`, `ghostalpha`, `replayghost`, `replayghostlife`, `projhits`/`projhp`/`projarmor` (+ per-weapon variants), `showmark`, `showhud`, `panelkey`, `diaglog`, `slowfactor`, `colormode` (0 rainbow / 1 Edgerunner gradient), `edgethresh`, `swaprun`, and the `esandy*` family for enemy time-stop.

## Disable / uninstall

Set the mod's switches to `0` in `mods/loader-manifest.txt`, or delete `mods/Sandevistan`.

## Repository

Sources under `mods/Sandevistan/` (this repository is the canonical source; the game-machine copy is a one-way mirror). Build tooling and distribution scripts are intentionally not committed. `dist/` release bundles are local artifacts.

## Related mods

[ModLoader](https://github.com/Eclipse-NotFound/ModLoader) ·
[MoreSkillsAndWeapons](https://github.com/Eclipse-NotFound/MoreSkillsAndWeapons) ·
[TDFC](https://github.com/Eclipse-NotFound/TDFC) ·
[RealisticVision](https://github.com/Eclipse-NotFound/RealisticVision) ·
[RandomRooms](https://github.com/Eclipse-NotFound/RandomRooms) ·
[RConnect](https://github.com/Eclipse-NotFound/RConnect)

> Fan mod project; not affiliated with the game's authors.
