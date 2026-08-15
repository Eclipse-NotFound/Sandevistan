# RemainsMod —— 模组与知识库仓库

本仓库是《Fallout Equestria: REMAINS》（Steam AppID 3908900）的模组开发仓库。

```
mods/               各模组项目（源码/分发/构建/模组自身知识）
└─ Sandevistan/     斯安维斯坦模组 —— 入口：mods/Sandevistan/交接文档.md
shared-knowledge/   跨模组共享的游戏本体知识库 —— 使用规范：shared-knowledge/README.md
```

- 开发/构建模组：先读 `mods/Sandevistan/交接文档.md`。
- 引用游戏机制知识：先读 `shared-knowledge/README.md`，再按领域查 facts/discoveries。
- 大体积工具链（flexsdk/airsdk/ffdec）与编译产物不入库（见 .gitignore），
  重新下载/构建步骤见 `mods/Sandevistan/build/README.md`。
