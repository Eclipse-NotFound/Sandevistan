---
domain: ui-systems
type: experiments
game-version: ["1.02"]
confidence: high
verified: true
discovered-by: Sandevistan
evidence:
  - kind: runtime-experiment
    summary: "正式 v1.143 字节与已安装 ModSettings 副本隔离运行，菜单打开/16项注册/保存重读/F9放行等21项通过。"
date-updated: 2026-09-23
---

# v1.143 仅保留统一菜单设置

用户要求去掉模组独立的设置面板，只保留接入游戏菜单的设置区。询问旧绿色浮层是否也移除后未收到进一步选择，本轮按“只留统一模组设置”处理：删除 F9 独立弹窗及 Options 绿色浮层，保留 ModSettingsCarrier 注册的斯安维斯坦设置页。用户若明确只想去掉 F9，可从 v1.142 源码恢复 Options 浮层；本轮默认没有保留第二套界面。

## 实现

- 删除 standalone panel 和旧选项浮层的状态、渲染、逐帧分支、上下左右/Enter 输入处理及 F9 开启入口。F9 不再占用；玩家自定义时停触发键 hotkey 仍沿用。
- 旧 panelkey 字段停止读取和回写；正式玩家配置文件不主动覆盖，下一次菜单保存自然清理该废弃字段。
- 统一菜单原有16项、即时开关保存和页面关闭时的滑块保存保持原契约。热键重映射沿用配置文件 hotkey；当前中枢仅支持 check/slider，没有新造数字键码控件。
- 删除旧面板检测对应的自动化断言，换为实测“旧浮层未出现”和“F9没有新增显示对象且事件放行”；增加已注册菜单的打开、setter→实际关闭回调→存储文件→loadConfig 重读断言。
- build/tests/run-death-prediction.ps1 增加 -WithSettings，仅将安装中的 ModSettings 发布文件复制到隔离实例；不改其他模组、游戏原始SWF、加载清单或真实pfe存储。

## 验证

命令：run-death-prediction.ps1 -Smoke -WithSettings -Artifact build/out/SandevistanMod.swf。

实际使用正式构建、无注入；结果21 PASS / 0 FAIL / 0 SKIP，含菜单成功注册16项、菜单打开、时长改为9秒并保存读取为270帧、旧panelkey不回写、F9前后主容器孩子数15→15且事件继续传递，另外完整时停/回放、暂停、可见性与音乐流程通过。保存重读在同一进程内调用与启动相同的 loadConfig，并检查真实隔离存储文件；不把它描述为跨进程保留自定义值的单独测试。死亡攻击快照snapSize=0仍不计实质覆盖。完整输出见 menu-settings-20260923/artifact-smoke.txt。

首次验收卡在保存重读后：saveConfigFile 按既有规则写 debugtest=0，loadConfig 使测试驱动停止；菜单打开与保存均已通过，但无SUMMARY。只修正测试分支，重读后继续本次隔离测试，随后全流程通过。正式用户实例依旧不启用自动测试。

本轮没有修改 v1.142 的死亡预判或 v1.141 的精灵图回放方法，未扩展重复专测；1.03/1.04及七模组混战未在本轮验收。

## 发布

v1.143：49,994字节，SHA256 B8805DBACC9A1313FD96BB68889911195AC6EAFCBB526E50C313B86AD1E9C748。
v1.142备份：源仓build/out/SandevistanMod.before-v1.143-20260923.swf；部署时在游戏release另留同名备份。旧版SHA256 28449B2646223A8EEE20EB4BB361DDA2D5DC0572C6AAA9CD5FCB5D072A374C44。
宿主基线B78244657ED407D03808C90E97325509DB35F802122835F58933FFF8003305AC，玩家配置基线D91C4C2889ABA19B1BCFB356885921B0605A50188B270A9E7619D2116E7EBDC3。先提交后定向部署，实际发布字节复验结果收尾追加。

已完成：实现提交c05a2d4后定向同步9个文件。源仓、游戏release和最终隔离启动副本哈希一致；从部署文件启动确认v1.143，21 PASS/0 FAIL/0 SKIP，日志见menu-settings-20260923/deployed-smoke.txt。宿主与玩家配置哈希保持上述基线，v1.142回滚已在两侧保存。正常退出并重启游戏加载更新。
