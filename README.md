# KeyBlocker ⌨️🚫

[English](#english) | [中文](#chinese)

---

<a name="english"></a>
## English

### Introduction
**KeyBlocker** is a lightweight macOS menu bar application designed for users who place external keyboards (like HHKB or Keychron) directly on top of their MacBook's built-in keyboard. It allows you to disable the internal keyboard with a single click or a global hotkey, preventing accidental key presses.

### Key Features
- **Precise Blocking**: Only disables the built-in keyboard while keeping external USB/Bluetooth keyboards fully functional.
- **Global Hotkey**: Toggle blocking status instantly using `Cmd + Opt + Ctrl + B`.
- **Lightweight**: A single-file Swift application with minimal resource footprint.
- **No Sandbox**: Built to run with full system access for stable hardware control.

### How to Use
1. **Download**: Go to the [Releases](https://github.com/kindredzhang/KeyBlocker/releases) page and download `KeyBlocker.dmg`.
2. **Install**: Open the `.dmg` and drag `KeyBlocker.app` to the `Applications` folder.
3. **Permissions**: Grant **Accessibility** permission in `System Settings -> Privacy & Security` when prompted.
4. **Security Tip**: Since the app is not signed with an Apple Developer certificate, if you see a "developer cannot be verified" warning:
   - Go to `System Settings -> Privacy & Security`.
   - Scroll down to the "Security" section.
   - Click **"Open Anyway"**.
5. **Hotkey**: Press `⌘ + ⌥ + ⌃ + B` to toggle the blocking state.

---

<a name="chinese"></a>
## 中文介绍

### 简介
**KeyBlocker** 是一款专为 macOS 设计的轻量级菜单栏应用。如果你习惯将外接键盘（如 HHKB 或 Keychron）直接叠放在 MacBook 的自带键盘上使用，这款工具可以帮你一键屏蔽内置键盘，彻底告别误触困扰。

### 核心功能
- **精准屏蔽**：仅屏蔽 MacBook 自带键盘，不影响任何外接 USB 或蓝牙键盘。
- **全局快捷键**：使用 `Cmd + Opt + Ctrl + B` 随时随地快速切换屏蔽状态。
- **极致轻量**：单文件 Swift 开发，占用资源极低，响应速度极快。
- **无沙盒限制**：采用原生底层方案，确保硬件控制的稳定性。

### 使用方法
1. **下载**：前往 [Releases](https://github.com/kindredzhang/KeyBlocker/releases) 页面下载最新的 `KeyBlocker.dmg`。
2. **安装**：打开 `.dmg` 文件，将 `KeyBlocker.app` 拖入 `Applications` 快捷方式。
3. **授权**：首次运行时，请根据提示在 `系统设置 -> 隐私与安全性 -> 辅助功能` 中勾选 **KeyBlockerApp**。
4. **安全提示**：由于应用未通过 Apple 开发者认证，若提示“无法验证开发者”：
   - 请前往 `系统设置 -> 隐私与安全性`。
   - 下滑至“安全性”部分。
   - 点击 **“仍要打开” (Open Anyway)**。
5. **快捷键**：按下 `⌘ + ⌥ + ⌃ + B` 即可快速开启或关闭屏蔽。

---

### Build from Source
If you want to build the app and DMG yourself:
1. Clone the repository.
2. Run the build script:
   ```bash
   chmod +x scripts/build.sh
   ./scripts/build.sh
   ```
3. The `KeyBlocker.dmg` will be generated in the root directory.

---

### Project Structure
- `Sources/`: Swift source code.
- `Resources/`: App icons and logo.
- `scripts/`: Build and icon generation scripts.

### 源码编译
如果你想自行编译：
1. 克隆仓库。
2. 运行构建脚本：
   ```bash
   chmod +x scripts/build.sh
   ./scripts/build.sh
   ```
3. 生成的 `KeyBlocker.dmg` 将位于项目根目录。

---

### 项目结构
- `Sources/`: Swift 源代码。
- `Resources/`: 应用图标和 Logo。
- `scripts/`: 构建和图标生成脚本。

### License
MIT License. Feel free to use and contribute!
