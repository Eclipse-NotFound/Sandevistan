---
domain: rendering
type: discoveries
game-version: ["1.02"]
confidence: high
verified: true
discovered-by: Sandevistan
evidence:
  - kind: decompiled-game-code
    symbol: "fe.serv.Gov60.frame / fe.MainMenu.mainStep / fe.inter.Camera.applyInterp"
  - kind: runtime-experiment
    summary: "30/60/90/120/auto及运行时切换；30Hz逻辑推进与额外显示帧逐帧对照"
date-updated: 2026-09-23
---

# pfe60 的逻辑时钟与模组适配

适用于2026-09-23根目录pfe60.swf（1.02衍生版，SHA256 FC19AF4A43438273A19D7CFBAC7A1CF584647CE94254F8D503A359C43E81091B），不是原始 pfe 或所有高帧补丁的通则。补充2026-09-09 runtime-loop/game-mechanism-atlas中“高帧调度尚未展开”的调查边界。

## 调度契约

MainMenu.mainStep 是先注册的 stage ENTER_FRAME 监听器。它每次调用一次 Gov60.frame()，返回0才运行菜单/World.step；返回1时只按 Gov60.alpha 调用 Camera.applyInterp。World逻辑仍是30Hz，额外显示帧不能再次推进模组计时、实体、冷却、录像。

Gov60.frame通过getTimer、累积余量和节拍锁定调度，每次最多一个逻辑步；不能仅用stage.frameRate或帧号取模推测。N=1或enabled=false时每次返回0。支持配置fps=30/60/90/120/auto；自动刷新率和掉帧不会改变“读本次调度结果”的契约。重新调用frame会推进第二次调度，不能把它当纯查询。

本版本结果k是fe.serv包内internal static字段。模组可将只读桥接类编译在fe.serv，借external SWC声明访问；运行时引用宿主实际类。本轮桥接在AIR成功，普通无Gov60宿主经探测走原路径也通过。直接new QName("fe.serv","k")动态读取则#1069，不能把两种访问方式混用。存根不得静态打包为第二个Gov60。字段/包名属于本版本内部契约，升级必须回读核对。

## 动画与显示

中间显示帧中Gov60.freeze遍历显示树并停止正在播放的MovieClip；逻辑帧resume恢复未手动跳帧、且不属于已知stop帧的片段。模组不应另起同频计时器绕开该顺序。

Camera.calc计算相机并保存玩家、悬浮武器前后位置；applyInterp(alpha)只写显示对象位置/武器旋转，不改逻辑坐标。World被onPause冻结时仍执行cam.calc；如果模组在后续监听器手动推进玩家，必须在本次逻辑帧完成后更新插值端点，否则中间显示帧会重新使用旧位置。不要再次完整调用calc，避免双重相机平滑、震动和UI渐变。

## 验证范围

在隔离宿主副本中，未适配的逐显示帧模组60次录像推进只对应40个宿主逻辑步；适配后60次录像对应60个逻辑步。普通30、高帧60/90/120/auto、30/120/关闭/恢复切换均对齐；真实手枪5次开火和60次移动步中，中间显示帧只插值，弹药结算一致。

这些是正确性证据，不是稳定120FPS或完整战斗性能承诺。未外推到DLC高帧版或全部模组。该pfe60的MainFE原本没有loader，帧率适配代码与游戏入口能否加载模组是两个独立条件。