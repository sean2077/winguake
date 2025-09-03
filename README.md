# winguake

[中文](README-zh.md) | English

<p align="center">
    <a href="https://www.autohotkey.com/"><img
            src="https://img.shields.io/badge/AutoHotkey-v2-334455?logo=autohotkey&logoColor=white"
            alt="AutoHotkey v2" /></a>
    <a href="https://github.com/sean2077/winguake/releases/latest"><img
            src="https://img.shields.io/github/v/release/sean2077/winguake"
            alt="Latest Release" /></a>
    <a href="https://github.com/sean2077/winguake/releases"><img
            src="https://img.shields.io/github/downloads/sean2077/winguake/total?logo=github"
            alt="GitHub Downloads" /></a>
    <a href="https://github.com/sean2077/winguake/stargazers"><img
            src="https://img.shields.io/github/stars/sean2077/winguake"
            alt="GitHub Stars" /></a>
    <a href="https://github.com/sean2077/winguake/actions"><img
            src="https://img.shields.io/github/actions/workflow/status/sean2077/winguake/release.yml?branch=main"
            alt="Build Status" /></a>
    <a href="https://github.com/sean2077/winguake/blob/main/LICENSE"><img
            src="https://img.shields.io/github/license/sean2077/winguake" alt="License" /></a>
</p>

---

winguake is a lightweight tool for Windows that allows you to show, hide, or launch (almost) any application window using hotkeys, as well as switch between multiple windows of different applications or multiple windows of the same application. It is essentially an [AutoHotkey](https://github.com/AutoHotkey/AutoHotkey) v2 script.

* Use hotkeys to **show, hide, or launch (almost) any application window**
* Use hotkeys to **switch between multiple applications or multiple windows of the same application**
* **Automatically maximize windows when launching applications** for optimal screen utilization

## 1. Motivation

During development, we often need to use a terminal and switch between different applications and the terminal using `Ctrl+Tab` or `Ctrl+Shift+Tab`. However, as more applications are opened, this can become cumbersome. If you've used [guake](https://github.com/Guake/guake) on GNOME, you will be impressed by its drop-down terminal experience, though it is limited to the GNOME desktop environment. While developing on Windows, I attempted to replicate this experience and found:

* The [**Windows Terminal**](https://github.com/microsoft/terminal) has a built-in **show/hide Quake window** feature. You can find it under Settings - Actions, but as of today (📅 July 9, 2025), it's somewhat basic, e.g., lacking tabs and titles, making it hard to distinguish multiple quake windows, no resize options for the drop-down window, etc. It's usable but far from ideal.

* [**windows-terminal-quake**](https://github.com/flyingpie/windows-terminal-quake) is a tool that not only manages terminal windows in a drop-down manner but can also manage other application windows. Initially, WTQ v1 was released as a companion program for Windows Terminal (the Quake window in Windows Terminal may have used WTQ code), and it was later updated to v2 to support other applications. However, as of today (📅 July 9, 2025), the project is still under development, and bugs like poor drop-down support for other applications and frequent interface freezes impact the user experience.

Neither of these fully satisfied my needs, so I implemented this solution based on [AutoHotkey](https://github.com/AutoHotkey/AutoHotkey).

## 2. Installation

There are two options for installation:

### 2.1. Install AutoHotkey and use AutoHotkey to run winguake.ahk (Recommended)

Download and install [AutoHotkey v2](https://autohotkey.com/download/ahk-v2.exe), then download the `winguake.ahk` script from this project. You can run it with AutoHotkey just like running Python scripts with `python`, or simply double-click the `winguake.ahk` script if your system is set to open `.ahk` files with AutoHotkey.

### 2.2. Download the portable EXE version

AHK scripts can also be [compiled](https://wyagd001.github.io/v2/docs/Scripts.htm#ahk2exe) into a standalone executable (.exe) file by combining the AHK script with the AutoHotkey binary. The EXE version provided in this project is based on this method, for users who do not want to install AutoHotkey separately.

## 3. Usage

winguake has hotkey configurations for the following applications by default. You can modify these in the `winguake.ahk` script or the external `winguake.ini` configuration file (see [Configuration](#configuration)). By default, some applications (like VSCode, Chrome) have automatic window maximization enabled on launch.

* F3 - Windows Terminal (with auto-maximize)
* F4 - VSCode (with auto-maximize)
* F5 - Chrome (with auto-maximize)  

You can modify or override these hotkey configurations in the `winguake.ini` file.

For more help, you can access it from the tray menu under Help.

### 3.1. Configuration

winguake will automatically read the `winguake.ini` configuration file located in the same directory as `winguake.ahk` or `winguake.exe`. If the file does not exist, it will be skipped.

> 🗒️ 1. If you're launching winguake from a shortcut, it will also navigate to the folder where the actual `winguake` file is stored.
> 🗒️ 2. Right-click on the winguake tray icon and select `Open Configuration file` to navigate to the configuration file.

The configuration file uses the INI format, with each section representing an application. The format is as follows:

Required Keywords:

* `hotkey`: The hotkey to bind
* `exe`: The process name (can be found through Task Manager after running the application)
* `launchCmd`: The command to run the application, with optional arguments
* `name`: The application name
* `launchPaths`: The application path(s), separated by `|`, with the leftmost path having the highest priority

Optional Keywords:

* `disable`: Whether to disable the application. This can be used to override the default configuration.
* `maximize`: Whether to maximize the window when launching the application (default: false)
* `cycleContinuous`: Multi-window cycling behavior (default: true)
  - `true`: Continuously cycle through windows without minimizing (A→B→C→A→B→C...)
  - `false`: Minimize all windows when reaching the last window

> ⚠️ Note: Do not add comments at the end of a line. If you want to add a comment, do so on the previous line.

Example:

```
[Notepad]
hotkey=F7
exe=notepad.exe
launchCmd=notepad
name=Notepad
launchPaths=notepad.exe|C:\Windows\System32\notepad.exe
maximize=true
cycleContinuous=false
; set disable=false if you want to register this app
disable=true
```

### 3.3. Multi-Window Cycling Feature

winguake supports two different cycling behaviors when managing multiple windows of the same application:

**Continuous Cycling Mode (`cycleContinuous=true`, default):**
- Windows cycle continuously: A → B → C → A → B → C...
- No interruption by minimizing all windows
- Ideal for applications where you frequently switch between multiple windows

**Traditional Mode (`cycleContinuous=false`):**
- Windows cycle with reset: A → B → C → (minimize all) → A → B → C...
- After reaching the last window, all windows are minimized
- Similar to traditional window management behavior

**Configuration:**
Add `cycleContinuous=true/false` to any application section in your `winguake.ini`:

```ini
[VSCode]
hotkey=F4
exe=Code.exe
launchCmd=code
name=Visual Studio Code
maximize=true
cycleContinuous=true

[Chrome]
hotkey=F5
exe=chrome.exe
launchCmd=chrome
name=Google Chrome
maximize=true
cycleContinuous=false
```

### 3.4. Maximize on Launch Feature

winguake supports automatically maximizing application windows when they are launched for the first time. This feature uses Windows' native window launch parameters for optimal compatibility and performance.

**How it works:**
- When `maximize=true` is set for an application, it will be launched using `Run(path, , "Max")`
- This directly starts the application in maximized state without needing to wait
- If the application doesn't support launch-time maximization, a backup method will attempt to maximize the window 2 seconds after launch

**Configuration:**
Add `maximize=true` to any application section in your `winguake.ini`:

```ini
[VSCode]
hotkey=F4
exe=Code.exe
launchCmd=code
name=Visual Studio Code
maximize=true

[Chrome]
hotkey=F5
exe=chrome.exe
launchCmd=chrome
name=Google Chrome
maximize=true
cycleContinuous=true
```

**Behavior:**
- **New launches**: Applications with `maximize=true` will start maximized
- **Switching to existing windows**: Window states are preserved (no forced maximization)
- **Minimized windows**: Will be restored but not forced to maximize unless they were already maximized

You can use the following modifier symbols to define hotkeys:

| Symbol | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Example             |
| :----: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
|   #    | Win (Windows logo key). Hotkeys that include Win (e.g. #a) will wait for Win to be released before sending any text containing an L keystroke. This prevents usages of [Send](https://www.autohotkey.com/docs/v2/lib/Send.htm) within such a hotkey from locking the PC. This behavior applies to all sending modes except [SendPlay](https://www.autohotkey.com/docs/v2/lib/Send.htm#SendPlayDetail) (which doesn't need it), [blind mode](https://www.autohotkey.com/docs/v2/lib/Send.htm#blind) and [text mode](https://www.autohotkey.com/docs/v2/lib/Send.htm#SendText). | `#S`: Win+S         |
|   !    | Alt **Note:** Pressing a hotkey which includes Alt may result in extra simulated keystrokes (Ctrl by default). See [A_MenuMaskKey](https://www.autohotkey.com/docs/v2/lib/A_MenuMaskKey.htm).                                                                                                                                                                                                                                                                                                                                                                                 | `!S`: Alt+S         |
|   ^    | Ctrl                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `^S`: Ctrl+S        |
|   +    | Shift                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | `^+S`: Ctrl+Shift+S |

For more hotkey symbol, see [Autohotkey Symbols](https://www.autohotkey.com/docs/v2/Hotkeys.htm#Symbols).

### 3.2. Auto-Start on Boot

The easiest method to enable auto-start is by placing a shortcut to the script in the `Startup` folder.

The `Startup` path (replace `<UserName>` with your actual username) is:

```
C:\Users\<UserName>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
```
