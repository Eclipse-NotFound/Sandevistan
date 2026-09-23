# Sandevistan —— 开发记忆入口

> 2026-09-23 接手核验。权限见 AGENT_SCOPE.md 与游戏工作区 GOVERNANCE.md；历史过程见 journal.md。

## 1. 这个模组是什么

为《FOE: REMAINS》加入斯安维斯坦：玩家全速、世界默认 1/5 速，记录动作与场景状态，结束后默认 5 倍速重演，配合彩色残影和断点续播主题曲。入口为 SandevistanMod.init(main)。v1.127 起疾跑切枪、投射物击落迁出到 MoreSkills&Weapons，本侧停用；备份在 state/migration-backup-v1.126/。

## 2. 用户偏好与协作约定

- 先读 design/user-preferences.md。时停中正常攻速、冻结玩家子弹；回放加速攻击、不被换弹打断；保留时停真实弹药消耗，回放不应二次扣库存。
- 唯一源码仓 D:\RemainsMod，分支 master；本项目在 mods\Sandevistan。游戏目录同名项目是镜像，源码与记忆先改源仓、提交后定向同步。
- 2026-09-23 接手只获授权接手开发，没有新功能、故障单或部署要求。既有体验待验项不是用户新增承诺。
- 不改其他模组或游戏 SWF；后续明确涉及部署时走构建、发布门禁、补丁技能。当前全量 sync-to-game.bat 会同步公共资料，不为少量修改直接运行。
- 游戏侧 release/config.txt 是运行时配置，不随源模板覆盖。发布代码时更新 MEMORY、changelog、说明；本次只有记忆更新，不升版本。

## 3. 当前状态

- 当前发布 **v1.140**（2026-09-20）。接手前源仓 HEAD 5838e10；源码迁移提交 3727c65。
- 2026-09-23 实查：源仓与游戏镜像的源码、发布 SWF、主题曲及接手前两份状态文件逐一 SHA256 相同。
- release/SandevistanMod.swf：49,928 字节；SHA256 `0506615963176D937C596F43B8FF6D865B3BAC5D2DECE8490A47629D65A9A0BA`。
- src/SandevistanMod.as：374,743 字节；SHA256 `CD0BE363002DDB616FAAE43B9A11BC4497E7EF082411FC4E1914DF69D99DAD5A`。
- v1.140 通过独立 ModSettingsCarrier 注册 16 项；不再依赖旧 MSW 类名备用通道。独立设置面板打开时旧选项浮层让位，F9 仍可用。v1.138 的 MSW 宿主描述只属历史。
- v1.136 敌人斯安维斯坦默认关；v1.137 配置增加 applicationStorageDirectory 覆盖/保存兜底；v1.139 主题曲默认音量 70、淡出 90 游戏帧，记录实际停止播放位置，会话内续播。
- 主题曲 release/sandy_theme.mp3 两侧均存在（10,212,353 字节），受 gitignore 排除，打包需显式包含。
- 9 月 20 日记录根 pfe 已有独立设置的第七个 loader；本次未解析或改动宿主 SWF，不能从旧六模组矩阵推断现状。

## 4. 已核对的机制与验证证据

- 当前源码入口：init → onFrameInner → startSandy / stepSandy → endSandy → stepReplay → endReplay；设置注册 stepHubRegister，音乐状态沿在 onFrameInner。
- startSandy 保存暂停/无敌状态、暂停世界正常步进，由模组驱动玩家与节流世界；时停不额外开启无敌，回放才开启，结束恢复原值。
- endSandy 清理本次冻结子弹以免双重火力，保存时停结束时弹药/耐久/魔法等快照，再从起点重演。endReplay 恢复快照、武器攻速与控制，并在后续 120 帧钳制异常弹药返还。
- 回放包含场景对象快照与攻击重演，不等于撤销整张地图；门/地形破坏过程仍不完整。
- 历史实机证据（本次没有重跑）：9 月 20 日完整组合 27 项+重启 4 项、无 MSW 组合 20 项+重启 4 项通过；正式七模组同字节隔离副本启动至 900 帧、入口响应通过。未写真实 pfe 存档。
- 9 月 7 日音乐 round 12：22 通过/0 失败/0 跳过，start@0 → stop@26493 → resume@26493；此前玩家动画、敌人可见性基线、暂停输入门控、迁移停用断言已有覆盖，详见 journal。
- 本次验证边界：静态阅读、文件哈希、工具存在性；未启动游戏、未重新编译，未验证玩家当前运行实例是否已重启加载 v1.140。

## 5. 已知问题与风险

- 待体验确认：音乐音量/淡出、回放动画与残影、TAB 暂停、当前设置入口与重启保持。敌人斯安维斯坦开启后的行为仍需专测；不自行改变默认关闭决定。
- 历史低优先：有攻击动画无伤害的残余报告（需复现后用 rFire 诊断）；预判死亡偏松（历史余量 0.9）；场景破坏只能保留结果。
- RealisticVision 满装甲条是旧跨模组调查记录，本次未复核，不应当成现存已确认故障，更不越权修改。
- Shift/中文输入法吞键是已知环境问题，Ctrl+Space 切回英文；提示 UI 已移除，诊断保留。
- 源码注释、architecture/lessons/build 文档含旧机器路径和过时机制解释。尤其 Part.setNull→Location.remObj 的视觉清理、setLight 与 drawAllObjs 的关系、isExpl 对后续 explRun 的边界，以游戏工作区 2026-09-09 源码审计为准，勿仅靠旧注释修改行为。
- 旧 dist 安装器未随独立 ModSettings 迁移更新，不直接运行。旧回退目录清理/重打包只是历史候选，未在本次执行。
- 接手前源仓只有未跟踪 AGENTS.md；这是既有文件，本次不暂存、不删除。

## 6. 下一步与恢复

- 接手完成后等待用户指定功能或可复现问题，再选择相应代码分支调查；不把历史待验项自动扩成新需求。
- 修改时优先保持弹药只扣一次、玩家与世界步进次数、回放后状态恢复三个约束；密封类动态访问可能抛 #1069，内部成员不可直接访问。
- 自动测试使用独立 app id（非 pfe）和 debugtest=1；真实 pfe 有门控。测试前读 remains-auto-testing，其他模组驱动可能干扰暂停/设置页，不能以启动无异常替代行为断言。
- v1.140 发布前回滚文件：build/out/SandevistanMod.before-v1.140-20260920.swf（继承记录，本次未验此备份）。整套设置迁移回滚须配套宿主与客户端；详细记录在游戏 mods/ModSettings/knowledge/experiments/2026-09-20-migration.md，按必要范围访问。

## 7. 深入了解与工具入口

- 偏好 design/user-preferences.md；架构 design/architecture.md；教训 decisions/lessons.md；逐版历史 decisions/changelog.md；会话历史 state/journal.md。
- 构建入口 build/build.bat 与 build/sandy-config.xml。2026-09-23 确认 Animate 2024 的 Java、源仓 build/tools/flexsdk/bin/mxmlc.bat、AIR SDK 的 playerglobal.swc 和 airglobal.swc 均存在；未声称本次编译通过。
- 用户日志：%APPDATA%\pfe\Local Store\sandy_modlog.txt；测试日志随独立 app id 分离。按关键词抽取，避免整读大日志。
- 游戏工作区机制总图：shared-knowledge/knowledge-validation/discoveries/game-mechanism-atlas-2026-09-09.md；旧结论限定：shared-knowledge/knowledge-validation/conflicts/source-audit-qualifications-2026-09-09.md。这些为静态证据，不能代替运行验证。
- 技能：remains-mod-memory；按实际任务再加载 remains-mod-build / remains-runtime-debug / remains-auto-testing / remains-release-gate / remains-swf-patching。
