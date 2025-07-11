# winguake 

中文 | [English](README_en.md)

winguake 是一款让你可以在 Windows 下通过热键 显示/隐藏/启动（几乎）任意应用窗口，以及在多应用或同应用的多窗口之间切换的轻量化工具（本质是 [AutoHotkey](https://github.com/AutoHotkey/AutoHotkey) v2 脚本）。

- 通过热键**显示/隐藏/启动（几乎）任意应用窗口**
- 通过热键**在多应用或同应用的多窗口之间切换**

## 1. 动机

我们在开发工作时，经常需要用到终端，以及使用 `Ctrl+Tab` 或 `Ctrl+Shift+Tab` 在其他应用与终端之间切换，当你打开的应用多起来时，这有时并不是件很轻松的事。如果你用过 Gnome 下的 [guake](https://github.com/Guake/guake) ，你一定会对它那下拉式终端的体验印象深刻，不过它仅适用于 GNOME 桌面环境。当我在 Windows 下开发，试图复刻 Gnome guake 的体验，我找到了：

- [**Windows 终端**](https://github.com/microsoft/terminal) 自带的 **显示/隐藏 Quake 窗口** 功能. 你可以在 设置 - 操作 中找到它，不过它目前（📅截止 2025-07-09）比较简陋，如: 没有标签和标题，如果开启多个 quake 窗口难以区分，无法调整下拉窗口的大小等等，只能说是可用的，距离好用还有一些距离。
    
- [**windows-terminal-quake**](https://github.com/flyingpie/windows-terminal-quake). 一款 Windows 下不仅可下拉管理终端窗口，而且还可以管理其他应用窗口的工具。WTQ v1 最初是作为 Window 终端配套程序推出（即 Windows 终端自带的 guake 窗口可能使用的是 WTQ 的代码），后重新为 v2 ,并支持其他应用程序。不过目前（📅截止 2025-07-09）该项目仍在开发中，实际使用时仍会有不少 bug 影响体验，如：对其他应用的下拉支持不是很好，界面容易卡死等等。
    

都不太让人满意，为此我基于 [AutoHotkey](https://github.com/AutoHotkey/AutoHotkey) 实现了这个方案。

## 2. 安装

有两种方案可共选择：

### 2.1. 安装 AutoHotkey 后使用 AutoHotkey 启动 winguake.ahk（推荐）

下载 [AutoHotkey v2](https://autohotkey.com/download/ahk-v2.exe) 并安装，下载本项目的 `winguake.ahk` 脚本，然后就可以像使用 Python 调用 py 脚本一样用 autohotkey 调用 ahk 脚本，或者你也可以直接点击 `winguake.ahk`（如果关联了打开 ahk 格式的工具为 autohotkey 的话）。

### 2.2. 下载打包好的便携式 exe

AHK 脚本也可以 [编译](https://wyagd001.github.io/v2/docs/Scripts.htm#ahk2exe)，即与 AutoHotkey 二进制文件结合在一起, 形成一个独立的可执行 (.exe) 文件. 本项目发布的 exe 即是基于此项技术实现，对于不想额外安装 Autohotkey 的用户，可以使用这种方案。

## 3. 使用

目前 winguake 内置如下几个应用的热键配置，如需修改可以直接改 `winguake.ahk` 内的配置部分，也可修改外部 `winguake.ini` 配置文件（见 [配置](#配置)）。

- F3 - Windows 终端
- F4 - VSCode
- F5 - Chrome
- F6 - Obsidian


更多帮助信息可以在托盘菜单 - 帮助中查看。

### 3.1. 配置

winguake 会自动读取 `winguake.ahk` 或 `winguake.exe` 同目录下的配置文件 `winguake.ini` ，如果不存在则跳过。

> 🗒️ 1. 如果你是启动的是 winguake 的快捷方式链接，同样会导航到 winguake 实际文件存放的路径。
> 🗒️ 2. 可以右键 winguake 托盘图标 - `Open Configuration file` 导航到所使用的配置文件。

配置文件为 ini 格式，每个区块（Section）表示一个应用，格式如下：

必须关键字：

- hotkey：要绑定的热键
- exe：进程名（可运行应用后通过 Windows 任务管理器查询）
- launchCmd：启动要执行的命令，这里可以附带启动参数
- name：应用名
- launchPaths：应用路径，支持多个路径（以 `|` 分隔），优先级从左到右

可选关键字：

- disable：是否禁用该应用，可用于覆盖默认配置的应用

> ⚠️ 注意：不可在行末尾添加注释，如需添加，请添加在上一行

示例：

```
[Notepad]
hotkey=F7
exe=notepad.exe
launchCmd=notepad
name=记事本
launchPaths=notepad.exe|C:\Windows\System32\notepad.exe
; set disable=false if you want to register this app
disable=true

```

常用的快捷键符号：

- `#`：Win键
- `!`：Alt键
- `^`：Ctrl键
- `+`：Shift键

更多快捷键符号请参考 [Autohotkey Symbols](https://www.autohotkey.com/docs/v2/Hotkeys.htm#Symbols).

### 3.2. 开机自启动

 最简单的方法是在 `Startup(启动)` 文件夹中放置脚本文件的快捷方式.

Startup 路径为（注意替换 `<UserName>`）：

```
C:\Users\<UserName>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
```
