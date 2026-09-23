---
domain: rendering
type: experiments
game-version: ["1.02"]
confidence: high
verified: true
discovered-by: Sandevistan
evidence:
  - kind: decompiled-game-code
    symbol: "fe.unit::UnitRaider.animate; fe.unit::UnitZombie.animate; fe.unit::Unit.initBlit/blit"
  - kind: runtime-experiment
    summary: "真实 AIR 类调用生产 recordReplayObjects/replayObjects；旧版稳定红，新版 12 组 574 帧逐像素一致。"
date-updated: 2026-09-23
---

# v1.141 马形敌人回放动画僵死

用户报告掠夺者、尸鬼在回放中动画僵死。位置正常并不等于身体动画正常；旧测试只断言玩家动画帧变化，没有检验这些敌人的实际像素。

## 复现与最小化

`build/tests/run-replay-animation.ps1` 在独立 app id 下启动当前宿主的只读副本，测试清单只加载 Sandevistan。测试代码注入在 build/out 的临时源码，正式 src 和发布产物均不含测试专用驱动。使用真实 UnitRaider/UnitZombie 与生产记录/回放方法；每 5 个录像帧推进一次真实 animate，其他帧保持同一姿势，模拟世界 1/5 速的重复位置帧。冻结单位 AI 的最小夹具排除重新寻路，另有开启正常 AI 步进的用例。

首次命令：`build/tests/run-replay-animation.ps1 -ExpectFailure`（当时源码为 v1.140）。输出见 replay-animation-20260923/baseline.txt：掠夺者 sourceFrames=17、尸鬼=24；回放均 replayFrames=1，moving=29，exact=0/30。不是位置不更新，也不是没有实际敌人的空转测试。

位移间隔单变量实验：只把 idx+1 改成 idx+5，身体变化恢复到 17/18 种，但两类仍 exact=0/30（cadence-only.txt）。相邻的重复录像位置会令推导 dx=0；只修位移仍不能重现真实姿势，因为 AI/动画计数重新运行。

## 修复

SandyBlitReplay 读取公开的 unit.blitData 和显示树内实际身体 BitmapData，把当前画面映射回精灵图的行/列。25 点签名只筛候选，再做完整像素相等校验，不把签名碰撞当成同帧。记录保存共享的小型帧坐标对象，缓存按贴图与尺寸分组，不逐历史帧克隆图像，也不释放游戏持有的贴图。

recordReplayObjects 在已有快照增加 bp；replayObjects 完成原来的 AI/动画/位置处理后，用公开 blit(row, frame) 重绘真实录像帧。这样既有战斗、武器、弹药及玩家 MovieClip 路径继续工作；非 postDie 的真正尸体不覆盖为生前身体。捕获失败保持旧路径，不对未知视觉强行写入。startSandy/endReplay 清理本轮索引。

## 验证

- fixed-matrix.txt：两物种各测 1/3/5/8/20 倍回放及一次 5 倍正常 AI；走动→站立→腾空→反向动作。12 组共 **574/574** 抽样帧与录像逐像素相同，12 项尸体保护通过。
- 尸体断言最初要求画面完全静止，尸鬼失败；源码及实际流程表明死亡动画本来可以推进。因此断言修正为保持 die/death/fall 状态，且不能被生前录像覆盖，不为迎合测试改变死亡机制。
- candidate-smoke.txt：完整开档/进战斗/两次时停回放/暂停/F9/音乐链路，20 PASS、0 FAIL、1 SKIP。跳过项是测试清单未装 ModSettings 的注册，不是本次修复失败。死亡敌人开火子项 snapSize=0，不作为新增死亡攻击覆盖；专用用例验证的是死亡姿态。
- 本机粗测已建索引后的 capture 连续 300 次为 48–64ms。此段不做截图，但只是热缓存微测，不是全部模组战斗 FPS；recordMs 包含测试哈希和图像克隆，不能当正式成本。边界参考已核对 KB-000056 revision 1。
- 真实 pfe 存档、正式配置和宿主 SWF 未写入。隔离实例由脚本 finally 按启动 PID 结束，临时描述符删除；证据日志留源仓。

运行命令：默认脚本运行像素回归；`-Source <旧版源码路径> -ExpectFailure` 可验证旧版；`-Smoke` 运行完整内置回归；`-Smoke -Artifact <SWF路径>` 核验指定发布文件。

## 范围与恢复

实机帧比较覆盖掠夺者/尸鬼的上述姿态，不能据此宣布所有怪物、所有特效及联机组合完全验证。独立 ModSettings 的接口未修改；敌人斯安维斯坦继续默认关。

正式版本 v1.141，50,878 字节，SHA256 F556C0728DA406A4A6A05399DF93E9A0349C4225107547F1E12FE88A2AEE3E48；release-smoke.txt 为此最终产物的独立复验，20 PASS/0 FAIL/1 SKIP。从已部署文件再次启动验证，deployed-smoke.txt 同样 20 PASS/0 FAIL/1 SKIP，新版加载标记和完整两轮技能入口有效。部署结果和回滚文件见 state/MEMORY.md。旧的“Blit 动画只能 animate、无法逐帧录像”资料已经追加当前限定，内部动画计数仍不可访问，但公开的渲染结果可精确匹配原图。