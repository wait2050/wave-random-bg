# 🌊 Wave Random BG · Wave 终端随机背景

[![中文文档](https://img.shields.io/badge/文档-中文-red)](README_zh.md)
[![English](https://img.shields.io/badge/docs-English-blue)](README.md)

为 [Wave Terminal（波浪终端）](https://www.waveterm.dev/) 提供零延迟随机标签页背景图。

每新建一个标签页，自动从你的图片库中随机挑选一张作为背景，在 Shell 提示符出现前就已渲染完毕——完全零延迟。

## 原理

两套机制并行：

1. **标签页创建时** — Wave 读取 `settings.json` 中的 `tab:background`（由上一个标签页设定），在渲染终端前就应用背景 CSS → **零延迟**
2. **Shell 启动时** — `.zshrc` 最顶部立即执行 `wsh setbg` 随机设当前标签背景，同时更新 `tab:background` 为下一个标签页做准备

```
 标签页1 打开 ──→ 获得预设 bg@custom042（瞬间）
       │
       └── .zshrc: wsh setbg random.jpg + 设置 tab:background = bg@custom123
                                                                           │
 标签页2 打开 ──→ 获得预设 bg@custom123（瞬间） ◄─────────────────────────┘
       │
       └── .zshrc: wsh setbg random.jpg + 设置 tab:background = bg@custom307
                                                                           │
 标签页3 打开 ──→ 获得预设 bg@custom307（瞬间） ◄─────────────────────────┘
```

## 快速开始

```bash
git clone https://github.com/wait2050/wave-random-bg.git
cd wave-random-bg
zsh install.sh ~/Pictures/wallpapers 0.3
```

在 Wave 中打开新标签页，即可看到效果。

## 环境要求

- [Wave Terminal](https://www.waveterm.dev/)（v0.14.4+）
- macOS / Linux
- zsh
- Python 3
- 一个存放图片的目录（支持 jpg、png、webp）

## 手动安装

### 1. 生成预设

```bash
./wave-gen-presets.sh ~/Pictures/wallpapers 0.3
```

会在 `~/.config/waveterm/backgrounds.json` 中为每张图片生成一个预设项。

### 2. 设置种子配置

在 `~/.config/waveterm/settings.json` 中添加：

```json
{
  "tab:background": "bg@custom001"
}
```

### 3. 修改 .zshrc

将 `zshrc-snippet.sh` 的内容插入到 `~/.zshrc` 的**最顶部**。

设置环境变量指向你的图片目录：

```bash
export WAVE_BG_DIR="$HOME/Pictures/wallpapers"
```

## 脚本说明

| 脚本 | 用途 |
|------|------|
| `wave-gen-presets.sh <目录> [透明度]` | 从图片目录生成 backgrounds.json |
| `wave-random-bg.sh <目录> [透明度]` | 手动给当前标签页随机换背景 |
| `wave-cache-warmer.sh <目录> [透明度]` | 预热浏览器图片缓存 |
| `install.sh <目录> [透明度]` | 一键安装 |

## 日常使用

- **无需手动操作**，新建标签页自动随机背景
- 调整透明度：`wsh setbg --opacity 0.5`
- 清除背景：`wsh setbg --clear`
- 手动换背景：`wave-random-bg.sh ~/Pictures/wallpapers`
- 新增/删除图片后：重新运行 `wave-gen-presets.sh`
- 预热缓存（非必须）：`wave-cache-warmer.sh ~/Pictures/wallpapers`

## 常见问题

**Q: 第一个标签页有延迟？**
A: 首次启动 Wave 时，第一个标签页读取的是 settings.json 中的种子预设，也是零延迟。如果没设置种子，首个标签页会稍慢（约 80ms），后续全部零延迟。

**Q: 图片需要什么尺寸？**
A: 建议 1920×1080 或相近比例。文件大小建议控制在 500KB 以内，解码更快。超大图片（4000px+）解码会比较慢。

**Q: 支持其他 Shell 吗？**
A: 目前仅支持 zsh。欢迎提 PR 支持 bash/fish。

**Q: 不想要随机了怎么卸载？**
A: 从 `.zshrc` 中删除 `wave-random-bg.zsh` 相关行，删除 `~/.config/waveterm/backgrounds.json`，清除 settings.json 中的 `tab:background`，然后 `wsh setbg --clear`。

## 致谢

本项目由 [Claude](https://claude.ai) 与 [DeepSeek](https://deepseek.com) 共同协助完成。

## 许可证

MIT
