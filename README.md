# winguake

[中文](README-zh.md) | English

winguake is a lightweight tool for Windows that allows you to show, hide, or launch (almost) any application window using hotkeys, as well as switch between multiple windows of different applications or multiple windows of the same application. It is essentially an [AutoHotkey](https://github.com/AutoHotkey/AutoHotkey) v2 script.

* Use hotkeys to **show, hide, or launch (almost) any application window**
* Use hotkeys to **switch between multiple applications or multiple windows of the same application**

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

winguake has hotkey configurations for the following applications by default. You can modify these in the `winguake.ahk` script or the external `winguake.ini` configuration file (see [Configuration](#configuration)).

* F3 - Windows Terminal
* F4 - VSCode
* F5 - Chrome
* F6 - Obsidian

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

> ⚠️ Note: Do not add comments at the end of a line. If you want to add a comment, do so on the previous line.

Example:

```
[Notepad]
hotkey=F7
exe=notepad.exe
launchCmd=notepad
name=Notepad
launchPaths=notepad.exe|C:\Windows\System32\notepad.exe
; set disable=false if you want to register this app
disable=true
```

### 3.2. Auto-Start on Boot

The easiest method to enable auto-start is by placing a shortcut to the script in the `Startup` folder.

The `Startup` path (replace `<UserName>` with your actual username) is:

```
C:\Users\<UserName>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
```
