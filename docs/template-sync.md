# 上游模板同步维护指南

## 权威来源

共享算法模板以 GitHub 仓库
[`JimmyWang0417/Algorithm-Competitive-Codes`](https://github.com/JimmyWang0417/Algorithm-Competitive-Codes)
的 `master` 分支为准。每次同步都会解析并记录具体提交 SHA，避免“同步了最新内容”却无法复现。

隔壁 `../Algorithm-Competitive-Codes` 目录可以提供代码风格、维护约定和即将上游的改动线索，但自动任务不会从中取内容。用户明确指定以该目录为标准的一次性手动迁移可以先于上游完成；这类迁移必须逐文件比较，并保留原 GitHub 基线指纹，直到相同内容进入上游。

2026-09-12 的设计与实施文档记录了当时从本地工作区完成的一次历史迁移；从本指南生效起，自动同步均采用 GitHub 来源。

## 受管范围

脚本只管理上游 `Templates/` 中的所有 `.hpp` 文件，以及 `Templates/initialization_misc/makefile`。大多数文件保持相同相对路径，只有两个显式映射：

| 上游路径 | 本仓库路径 |
| --- | --- |
| `geometry/2d.hpp` | `geometry/2D/2d.hpp` |
| `geometry/3d.hpp` | `geometry/3D/3d.hpp` |

受管文件列表、上游提交和每个源文件的 SHA-256 基线记录在 `scripts/upstream-template-manifest.json`。本仓库独有的 Typst、Markdown、图片、拆分几何头文件和图论补充模板不在删除范围内。

## 本地命令

只检查差异，不写文件：

```bash
python3 scripts/sync_upstream_templates.py --check
```

应用上游变更并更新受管清单：

```bash
python3 scripts/sync_upstream_templates.py --apply
```

检查所有上游头文件是否存在于从 `Templates/main.typ` 可达的 `#raw(read(...))` 入口中：

```bash
python3 scripts/sync_upstream_templates.py --check-entries
```

三个命令默认从 GitHub 克隆 `master`。维护者也可以用 `--repository` 和 `--ref` 检查其他明确来源；测试或断网排查时可用 `--source-dir` 指向已经准备好的 Git checkout。

## 安全规则

应用模式只检查受管目标和清单自身的 Git 状态，不会因为无关文档正在编辑而拒绝运行。如果任一受管文件存在本地修改，脚本会列出路径并退出，不覆盖工作。

脚本会把当前上游、目标文件和清单基线做三方比较：

- 只有上游改变时，安全更新目标。
- 目标相对基线领先而上游未变时，报告冲突，不反向覆盖。
- 上游与目标都改变且内容不同时，报告冲突，由维护者判断。
- 新上游文件与未受管目标内容完全相同时，安全接管；内容不同时拒绝覆盖。
- 上游删除只作用于旧清单已证明属于同步范围、且目标内容未偏离基线的文件。

## 新模板的文本入口

同步源码并不等于代码册内容已经完整。新头文件需要维护者完成以下检查：

1. 在合适的 `Templates/**/main.typ` 中添加标题和 `#raw(read(...))`。
2. 根据模板用途补充必要的适用条件、复杂度、参数约定或易错点。
3. 运行 `--check-entries`，确认没有 `MISSING_ENTRY`。
4. 在正式合并前运行 C++ 校验与宽版、紧凑版 Typst 构建。

脚本不会根据文件名自动编造中文标题或算法说明，因为章节位置和文字需要语义判断。

## 自动 PR

`.github/workflows/sync-upstream-templates.yml` 每周运行一次，也支持在 Actions 页面手动触发。工作流从干净的 `master` 开始，运行应用模式，把结果推送到固定分支 `automation/sync-algorithm-templates`，并创建或刷新一个 PR。

PR 正文记录上游提交，并列出缺少 Typst 入口的头文件。没有上游变化时不会创建空提交或新 PR。同步工作流不创建标签、不发布 Release，也不替代现有 PR 中的代码册构建检查。

若检测到本地领先或双方同时修改，应用步骤会失败并在 Actions 日志列出冲突路径，不会推送回滚分支。将对应改动推送到上游后，下一次运行会在内容一致时更新清单并恢复正常同步。
