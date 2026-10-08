# Sandevistan — bullet-time combat

**English** · [简体中文](README.zh-CN.md)

Slow the world while you move and attack at normal speed, then watch your actions replay quickly with colorful afterimages. For players who enjoy planning a sequence of attacks and seeing it unfold.

**[Download v1.145 — Sandevistan_v1.145.zip](https://github.com/Eclipse-NotFound/Sandevistan/releases/download/v1.145/Sandevistan_v1.145.zip)** · [Release notes / other versions](https://github.com/Eclipse-NotFound/Sandevistan/releases)

Use the download link above, or open the release page, expand **Assets**, and select that filename. **Source code** and the green **Code → Download ZIP** button are development files, not the installable package.

## What changes?

- The default key is **backslash `\`**, with about 7 seconds of bullet time. The world runs at 1/5 speed by default, followed by a fast replay.
- Adjust duration, cooldown, replay speed, and afterimage color and density.
- Optional enemy time-stop abilities are off by default.
- Add your own music if desired. No music is bundled, and the mod works without it.

## Install

For **Windows / Remains 1.02**.

1. Save and close the game. In your Steam Library, right-click Remains → **Manage → Browse local files**. The game folder contains `pfe.swf` and `application.xml`.
2. If this is your first mod from this collection, complete the [ModLoader first-time setup](https://github.com/Eclipse-NotFound/ModLoader/blob/master/docs/INSTALL.md#first-install), including the game patch and scanner. Skip this if already installed.
3. Extract the ZIP and **merge its `mods` folder into the game folder**. Avoid a nested `mods/mods` folder. On a first installation, copy `default-config/Sandevistan/config.txt` into `mods/Sandevistan/release/config.txt`. Keep your existing configuration when upgrading.
4. Double-click **`mods/ModLoader/RemainsModScanner.exe`** inside the game folder. Wait for it to finish, close its message, then launch the game normally.

Check that this file exists: `mods/Sandevistan/release/SandevistanMod.swf`. Press `\` during play to try bullet time; the old permanent “loaded” marker was removed.

[Folder diagram, updating and recovery](https://github.com/Eclipse-NotFound/ModLoader/blob/master/docs/INSTALL.md)

## Your first session

1. Load a character and press **`\`** during normal play.
2. Open **PipBuck → Settings → Mods (`模组`) → Sandevistan** to adjust the effect. The old standalone **F9** panel has been removed.
3. For music, name your own MP3 `sandy_theme.mp3`, place it in `mods/Sandevistan/release/`, restart, and enable music in the mod settings.

Saved in-game settings override the configuration template. Template comments about F9, the loaded marker, and moved features are historical. Sprint weapon swapping and projectile shoot-down now belong to [MoreSkillsAndWeapons](https://github.com/Eclipse-NotFound/MoreSkillsAndWeapons).

## Updates, removal and compatibility

Before updating, save and close the game, back up `mods/Sandevistan`, merge the new files, run the scanner and restart. Preserve your configuration. To disable the mod temporarily, move its folder outside `mods` as a backup, scan again and restart.

This guide covers the public v1.145 package. The mod supports tested high-FPS hosts but does not install a high-FPS game launcher. Other game versions, co-op, and every mod combination have not been fully verified.

## Need help?

Check the folder location, run the scanner, and fully restart the game. See the [installation troubleshooting guide](https://github.com/Eclipse-NotFound/ModLoader/blob/master/docs/INSTALL.md#troubleshooting) for common problems.

If it still fails, [report an issue](https://github.com/Eclipse-NotFound/Sandevistan/issues) with your game version, mod version, other installed mods, steps to reproduce, and what you expected versus what happened. Include a screenshot or exact error if available; a personal save is not needed for an initial report.

<details>
<summary>Development resources (not needed to install)</summary>

This page describes the downloadable release; repository source may be ahead. See [mods/Sandevistan](mods/Sandevistan/) for implementation, with design, validation and version records in the project tree.

</details>

[Browse the mod collection](https://github.com/Eclipse-NotFound/ModLoader#choose-mods) · [First-time installation guide](https://github.com/Eclipse-NotFound/ModLoader/blob/master/docs/INSTALL.md)

An unofficial fan project. You need your own copy of the game.
