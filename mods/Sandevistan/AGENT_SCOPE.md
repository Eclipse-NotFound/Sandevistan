# Sandevistan —— Agent 工作范围

> 完整治理规则见工作区根目录 `GOVERNANCE.md`（权限模型、知识库、参考区、游戏文件修改、外置记忆协议、同步与镜像）。
> 本文件只记录本模组的参数与特例。开始开发：读本文件 → 读 `state\MEMORY.md`（记忆入口）。
> 本仓库（D:\RemainsMod）内读不到 GOVERNANCE.md 时，见仓库根的同名副本（权威版在游戏目录侧）。

## 项目参数

| 项 | 值 |
|---|---|
| project | Sandevistan |
| workspace（源） | D:\RemainsMod\mods\Sandevistan\ |
| workspace（镜像） | 游戏目录\mods\Sandevistan\（由 sync-to-game.bat /MIR 同步） |
| repository | D:\RemainsMod（git，master） |
| 运行时入口 | release/SandevistanMod.swf（入口类 `SandevistanMod`，`public static init(main)`） |
| 记忆入口 | state/MEMORY.md |

## 本模组特例（相对 GOVERNANCE 的偏离/补充）

- **镜像模型**：一切修改在本源仓库做并 commit，然后运行 `sync-to-game.bat` 同步到游戏目录。游戏目录侧的 `mods\Sandevistan\` 不是工作副本。
- 唯一例外 `release\config.txt`：游戏内 F9 面板直写，同步脚本明确不覆盖（/XF config.txt）。
- 构建也在本仓库侧进行（build\ 不参与同步）。
- `decisions\changelog.md`（112+ 条版本史）：**新版本行插在旧行之前，不要整行替换**（易覆盖丢行）。
- `design\user-preferences.md` 记录用户偏好，开发时勿违背。
