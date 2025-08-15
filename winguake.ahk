#Requires AutoHotkey v2.0
; Windows Quake - Multi-App Manager
; AutoHotkey v2 Script
; Author：Sean2077

VERSION := "1.0.4"
SCRIPT_NAME := "winguake(v" . VERSION . ")"
SCRIPT_FULLNAME := "Windows Quake - Multi-App Manager (v" . VERSION . ")"


; 设置脚本为单实例运行
#SingleInstance Force

; 设置托盘图标提示
A_IconTip := SCRIPT_NAME

; ==================== 应用配置 ====================
; 🎯 只需要在这里添加/修改应用配置即可！
; 格式：键名 => { 配置项 }

Apps := Map()

; Windows Terminal 配置
Apps["Terminal"] := {
    hotkey: "F3",                    ; 快捷键
    exe: "WindowsTerminal.exe",      ; 进程名
    launchCmd: "wt.exe",             ; 启动命令
    launchPaths: [                   ; 启动路径列表（按优先级）
        "wt.exe",
        "C:\Users\" . A_UserName . "\AppData\Local\Microsoft\WindowsApps\wt.exe"
    ],
    name: "Windows Terminal",        ; 显示名称
    maximize: true                   ; 启动时最大化
}


Apps["VSCode"] := {
    hotkey: "F4",
    exe: "Code.exe",
    launchCmd: "code",
    launchPaths: [
        "code",
        "C:\Users\" . A_UserName . "\AppData\Local\Programs\Microsoft VS Code\Code.exe"
    ],
    name: "Visual Studio Code",
    maximize: true  ; 默认启动时最大化
}

Apps["Chrome"] := {
    hotkey: "F5",
    exe: "chrome.exe",
    launchCmd: "chrome",
    launchPaths: [
        "chrome",
        "C:\Program Files\Google\Chrome\Application\chrome.exe",
        "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
    ],
    name: "Google Chrome",
    maximize: true  ; 默认启动时最大化
}

Apps["Obsidian"] := {
    hotkey: "F6",
    exe: "Obsidian.exe",
    launchCmd: "obsidian://",
    launchPaths: [
        "obsidian://",
        "C:\Program Files\Obsidian\Obsidian.exe"
    ],
    name: "Obsidian"
}

; Apps["Notepad++"] := {
;     hotkey: "F7",
;     exe: "notepad++.exe",
;     launchCmd: "notepad++",
;     launchPaths: [
;         "notepad++",
;         "C:\Program Files\Notepad++\notepad++.exe",
;         "C:\Program Files (x86)\Notepad++\notepad++.exe"
;     ],
;     name: "Notepad++"
; }


; ==================== 读取配置文件 ====================

; 获取脚本真实路径（处理快捷方式）
GetScriptRealPath() {
    scriptPath := A_ScriptFullPath

    ; 检查是否是快捷方式(.lnk)
    if (SubStr(scriptPath, -3) = ".lnk") {
        ; 创建 Shell 对象解析快捷方式
        shell := ComObject("WScript.Shell")
        shortcut := shell.CreateShortcut(scriptPath)
        scriptPath := shortcut.TargetPath
    }

    return scriptPath
}

; 获取配置文件路径
GetConfigFilePath() {
    realScriptPath := GetScriptRealPath()

    ; 获取脚本目录和文件名（不含扩展名）
    scriptDir := RegExReplace(realScriptPath, "\\[^\\]+$")
    scriptNameNoExt := "winguake"  ; 默认配置文件名

    ; 构建配置文件路径
    configPath := scriptDir . "\" . scriptNameNoExt . ".ini"

    return configPath
}


LoadConfig(configFile) {
    ; 获取配置文件中的所有 Section
    allSections := IniRead(configFile)
    if (allSections = "") {
        ToolTip("configuration is empty", , , 1)
        SetTimer(() => ToolTip("", , , 1), -2000)
        return true
    }

    sectionArray := StrSplit(allSections, "`n")
    updatedApps := []

    ; 遍历每个 Section
    for index, sectionName in sectionArray {
        ; 跳过空的 Section 名称
        if (sectionName = "")
            continue

        ; 检查是否是已知的 App
        if (Apps.Has(sectionName)) {
            ; 获取当前 Section 的所有键
            allKeys := IniRead(configFile, sectionName)
            if (allKeys = "")
                continue

            keyArray := StrSplit(allKeys, "`n")

            ; 遍历每个键值对
            for keyIndex, keyValuePair in keyArray {
                if (keyValuePair = "")
                    continue

                ; 解析 key=value 格式
                equalPos := InStr(keyValuePair, "=")
                if (equalPos = 0)
                    continue

                keyName := SubStr(keyValuePair, 1, equalPos - 1)
                value := SubStr(keyValuePair, equalPos + 1)

                ; 跳过空键名或空值
                if (keyName = "" || value = "")
                    continue

                ; 根据键名更新对应的配置
                switch keyName {
                    case "launchPaths":
                        ; 处理数组类型的配置
                        ; 格式：path1|path2|path3
                        if (InStr(value, "|")) {
                            Apps[sectionName].launchPaths := StrSplit(value, "|")
                        } else {
                            Apps[sectionName].launchPaths := [value]
                        }

                    default:
                        Apps[sectionName].%keyName% := value
                }
            }

            updatedApps.Push(sectionName)
        } else {
            ; 如果是新的 App，创建新的配置
            newApp := {}

            ; 获取当前 Section 的所有键
            allKeys := IniRead(configFile, sectionName)
            if (allKeys = "")
                continue

            keyArray := StrSplit(allKeys, "`n")

            ; 遍历每个键值对
            for keyIndex, keyValuePair in keyArray {
                if (keyValuePair = "")
                    continue

                ; 解析 key=value 格式
                equalPos := InStr(keyValuePair, "=")
                if (equalPos = 0)
                    continue

                keyName := SubStr(keyValuePair, 1, equalPos - 1)
                value := SubStr(keyValuePair, equalPos + 1)

                ; 跳过空键名或空值
                if (keyName = "" || value = "")
                    continue

                ; 根据键名设置配置
                switch keyName {
                    case "launchPaths":
                        ; 处理数组类型的配置
                        if (InStr(value, "|")) {
                            newApp.launchPaths := StrSplit(value, "|")
                        } else {
                            newApp.launchPaths := [value]
                        }

                    default:
                        newApp.%keyName% := value
                }
            }

            ; 为新 App 设置默认值
            if (!newApp.HasOwnProp("hotkey"))
                newApp.hotkey := ""
            if (!newApp.HasOwnProp("exe"))
                newApp.exe := ""
            if (!newApp.HasOwnProp("launchCmd"))
                newApp.launchCmd := ""
            if (!newApp.HasOwnProp("name"))
                newApp.name := sectionName
            if (!newApp.HasOwnProp("launchPaths"))
                newApp.launchPaths := []

            Apps[sectionName] := newApp
            updatedApps.Push(sectionName . " (New)")
        }
    }

    ; 显示更新结果
    if (updatedApps.Length > 0) {
        message := "Updated: " . updatedApps.Length . " applications`n"
        for index, appName in updatedApps {
            message .= "- " . appName . "`n"
        }
        ToolTip(message, , , 1)
        SetTimer(() => ToolTip("", , , 1), -3000)
    } else {
        ToolTip("No valid configuration updates found", , , 1)
        SetTimer(() => ToolTip("", , , 1), -2000)
    }

    return ValidateAllConfigs()
}


; 辅助函数：验证配置完整性
ValidateAppConfig(appName, appConfig) {
    issues := []
    ; 检查是否被禁用，若被禁用则跳过
    if (appConfig.HasOwnProp("disable") && appConfig.disable)
        return issues

    ; 检查必需字段
    if (!appConfig.HasOwnProp("hotkey") || appConfig.hotkey = "")
        issues.Push("missing hotkey configuration: hotkey")

    if (!appConfig.HasOwnProp("exe") || appConfig.exe = "")
        issues.Push("missing process name configuration: exe")

    if (!appConfig.HasOwnProp("launchCmd") || appConfig.launchCmd = "")
        issues.Push("missing launch command configuration: launchCmd")

    if (!appConfig.HasOwnProp("name") || appConfig.name = "")
        issues.Push("missing display name configuration: name")

    if (!appConfig.HasOwnProp("launchPaths") || appConfig.launchPaths.Length = 0)
        issues.Push("missing launch paths configuration: launchPaths")

    return issues
}

; 辅助函数：验证所有应用配置
ValidateAllConfigs() {
    allIssues := Map()
    registeredHotkeys := Map()

    for appName, appConfig in Apps {
        issues := ValidateAppConfig(appName, appConfig)
        if (issues.Length > 0) {
            allIssues[appName] := issues
            Apps.Delete(appName)  ; 删除有问题的应用配置
        } else {
            ; 记录有效的应用
            ; 跳过禁用的应用配置
            if (IsDisabled(appConfig)) {
                continue
            }
            if registeredHotkeys.Has(appConfig.hotkey) {
                if !allIssues.Has("HotKey Conflict!") {
                    allIssues["HotKey Conflict!"] := []
                }
                allIssues["HotKey Conflict!"].Push(appName . "'s hotkey '" . appConfig.hotkey . "' is already in use by " . registeredHotkeys[appConfig.hotkey])
            } else {
                registeredHotkeys[appConfig.hotkey] := appName
            }
        }
    }

    if (allIssues.Count > 0) {
        message := "Configuration validation found issues:`n`n"
        for appName, issues in allIssues {
            message .= "[" . appName . "]`n"
            for index, issue in issues {
                message .= "  - " . issue . "`n"
            }
            message .= "`n"
        }
        MsgBox(message, "Configuration Validation - " . SCRIPT_NAME, "T15")
        ; 仅存在热键冲突或有效应用配置为0的情况认为配置失败
        if allIssues.Has("HotKey Conflict!") || Apps.Count = 0
            return false
    }


    ToolTip("All configuration validation passed", , , 1)
    SetTimer(() => ToolTip("", , , 1), -2000)
    return true

}

; 辅助函数：打开脚本真实路径
OpenScriptDirectory() {
    local dir
    SplitPath(configFile, , &dir)
    Run(dir)
}

OpenConfigFile() {
    ; 判断是否存在配置文件
    if !FileExist(configFile) {
        ; 如果配置文件不存在，提示用户是否创建
        MsgBoxResult := MsgBox("Configuration file not found: " . configFile . "`nDo you want to create a new one?", "Configuration File Missing - " . SCRIPT_NAME, 4)
        if (MsgBoxResult = "No") {
            return  ; 用户选择不创建，直接返回
        }
        ; 创建新的配置文件
        FileAppend("", configFile)
    }
    Run(configFile)
}


; 辅助函数：显示当前配置
ShowCurrentConfig() {
    message := "Current application configuration (valid parts):`n`n"

    for appName, appConfig in Apps {
        message .= "[" . appName . "]`n"
        message .= "  Hotkey: " . appConfig.hotkey . "`n"
        message .= "  Process Name: " . appConfig.exe . "`n"
        message .= "  Launch Command: " . appConfig.launchCmd . "`n"
        message .= "  Display Name: " . appConfig.name . "`n"
        message .= "  Launch Paths: "

        if (appConfig.launchPaths.Length > 0) {
            for index, path in appConfig.launchPaths {
                message .= path
                if (index < appConfig.launchPaths.Length)
                    message .= " | "
            }
        }
        message .= "`n"
        message .= "  Disabled: " . (IsDisabled(appConfig) ? "Yes" : "No") . "`n"
        message .= "`n"
    }

    ; 使用 MsgBox 显示详细信息
    MsgBox(message, "Current Configuration - " . SCRIPT_NAME, "T15")
}

IsDisabled(appConfig) {
    if !appConfig.HasOwnProp("disable")
        return false
    if appConfig.disable = "No" || appConfig.disable = "0" || appConfig.disable = "OFF" || appConfig.disable = "false"
        return false
    return true
}


configFile := GetConfigFilePath()
if (FileExist(configFile)) {
    if (LoadConfig(configFile)) {
        ShowNotification("Read config file: " . configFile . " successful 🎉🎉🎉")
    } else {
        ShowNotification("Read config file: " . configFile . " failed 💩💩💩")
        ; ShowCurrentConfig()
        ExitApp()
    }
} else {
    ShowNotification("Config file not found: " . configFile . " use default")
}

; ShowCurrentConfig()


; ==================== 全局状态跟踪 ====================
; 记录每个应用的当前活动窗口索引
AppWindowIndex := Map()

; ==================== 自动化热键注册 ====================
; 🤖 这部分会自动根据配置创建热键，无需手动修改！

; 根据配置自动注册热键
RegisterHotkeys()

RegisterHotkeys() {
    for appKey, appConfig in Apps {
        if (IsDisabled(appConfig)) {
            continue
        }

        ; 初始化窗口索引
        AppWindowIndex[appKey] := 0

        ; 注册主热键（如 F3）
        if (appConfig.HasOwnProp("hotkey") && appConfig.hotkey != "") {
            try
            {
                Hotkey(appConfig.hotkey, ToggleApp.Bind(appKey))
            }
            catch as err {
                ShowNotification("Failed to register hotkey: " . appConfig.hotkey . " - " . err.message)
            }
        }
    }
}

; ==================== 核心函数 ====================

; 获取应用的所有窗口句柄
GetAppWindows(exe) {
    windows := []

    ; 使用 WinGetList 获取所有匹配的窗口
    try {
        winList := WinGetList("ahk_exe " . exe)

        ; 过滤出可见的、有标题的窗口
        for hwnd in winList {
            if (WinExist("ahk_id " . hwnd)) {
                ; 检查窗口是否可见且有标题
                title := WinGetTitle("ahk_id " . hwnd)
                if (title != "" && IsWindow(hwnd)) {
                    windows.Push(hwnd)
                }
            }
        }
    }
    catch {
        ; 如果出错，返回空数组
    }

    return windows
}

; 检查是否为有效窗口
IsWindow(hwnd) {
    try {
        ; 检查窗口是否可见
        return DllCall("IsWindowVisible", "Ptr", hwnd)
    }
    catch {
        return false
    }
}

; 切换应用程序显示/隐藏（支持多窗口循环）
ToggleApp(appKey, *) {
    if (!Apps.Has(appKey)) {
        ShowNotification("Not found: " . appKey)
        return
    }

    appConfig := Apps[appKey]
    windows := GetAppWindows(appConfig.exe)

    ; 如果没有窗口，启动应用
    if (windows.Length = 0) {
        LaunchApp(appKey)
        return
    }

    ; 如果只有一个窗口，使用原来的逻辑
    if (windows.Length = 1) {
        hwnd := windows[1]
        isMinimized := WinGetMinMax(hwnd)

        if (WinActive(hwnd)) {
            ; 当前活动窗口 - 最小化
            WinMinimize(hwnd)
            ShowNotification(appConfig.name . " is minimized")
            AppWindowIndex[appKey] := 0  ; 重置索引
        }
        else {
            ; 窗口存在但不活动 - 激活
            if (isMinimized = -1) {
                WinRestore(hwnd)
            }
            WinActivate(hwnd)
            WinShow(hwnd)
            ShowNotification(appConfig.name . " is activated")
            AppWindowIndex[appKey] := 1
        }
        return
    }

    ; 多窗口处理逻辑
    HandleMultipleWindows(appKey, windows, appConfig)
}

; 处理多窗口循环激活
HandleMultipleWindows(appKey, windows, appConfig) {
    currentIndex := AppWindowIndex[appKey]
    windowCount := windows.Length

    ; 检查当前是否有活动的应用窗口
    activeWindowIndex := 0
    for i, hwnd in windows {
        if (WinActive(hwnd)) {
            activeWindowIndex := i
            break
        }
    }

    ; 如果当前有活动窗口
    if (activeWindowIndex > 0) {
        ; 如果是最后一个窗口，最小化所有窗口
        if (currentIndex >= windowCount) { ; 这里用 >= 是为了处理窗口减少的情况
            for hwnd in windows {
                if (WinGetMinMax(hwnd) != -1) {  ; 如果窗口没有最小化
                    WinMinimize(hwnd)
                }
            }
            ShowNotification(appConfig.name . " all windows are minimized (total " . windowCount . ")")
            AppWindowIndex[appKey] := 0  ; 重置索引
        }
        else {
            ; 激活下一个窗口
            nextIndex := currentIndex + 1
            nextHwnd := windows[nextIndex]

            if (WinGetMinMax(nextHwnd) = -1) {  ; 如果窗口最小化了
                WinRestore(nextHwnd)
            }
            WinActivate(nextHwnd)
            WinShow(nextHwnd)

            windowTitle := WinGetTitle(nextHwnd)
            if (StrLen(windowTitle) > 50) {
                windowTitle := SubStr(windowTitle, 1, 50) . "..."
            }

            ShowNotification(appConfig.name . " window " . nextIndex . "/" . windowCount . ": " . windowTitle)
            AppWindowIndex[appKey] := nextIndex
        }
    }
    else {
        ; 没有活动窗口，激活第一个窗口
        firstHwnd := windows[1]

        if (WinGetMinMax(firstHwnd) = -1) {  ; 如果窗口最小化了
            WinRestore(firstHwnd)
        }
        WinActivate(firstHwnd)
        WinShow(firstHwnd)

        windowTitle := WinGetTitle(firstHwnd)
        if (StrLen(windowTitle) > 50) {
            windowTitle := SubStr(windowTitle, 1, 50) . "..."
        }

        ShowNotification(appConfig.name . " window 1/" . windowCount . ": " . windowTitle)
        AppWindowIndex[appKey] := 1
    }
}

; 备用最大化方案（用于不支持启动时最大化的应用）
BackupMaximizeWindow(appKey) {
    if (!Apps.Has(appKey)) {
        return
    }

    appConfig := Apps[appKey]
    windows := GetAppWindows(appConfig.exe)

    if (windows.Length > 0) {
        firstWindow := windows[1]
        try {
            ; 检查窗口是否已经是最大化状态
            currentState := WinGetMinMax(firstWindow)
            windowTitle := WinGetTitle(firstWindow)

            if (currentState != 1) {  ; 如果不是最大化状态
                WinActivate(firstWindow)
                Sleep(100)
                WinMaximize(firstWindow)

                ; 验证最大化是否成功
                Sleep(100)
                newState := WinGetMinMax(firstWindow)
                if (newState = 1) {
                    ShowNotification("✓ " . appConfig.name . " maximized (backup method)")
                } else {
                    ShowNotification("⚠ " . appConfig.name . " backup maximize failed")
                }
            } else {
                ; 已经是最大化状态
                ShowNotification("✓ " . appConfig.name . " already maximized")
            }
        }
        catch as e {
            ; 静默失败，不显示错误信息
        }
    }
}

; 简单的窗口最大化备用方案（适用于不支持启动时最大化的应用）
WaitAndMaximizeWindow(appKey) {
    if (!Apps.Has(appKey)) {
        return
    }

    appConfig := Apps[appKey]
    windows := GetAppWindows(appConfig.exe)

    if (windows.Length > 0) {
        firstWindow := windows[1]
        try {
            WinActivate(firstWindow)
            Sleep(100)
            WinMaximize(firstWindow)
            ShowNotification("✓ " . appConfig.name . " maximized as fallback")
        }
        catch as e {
            ShowNotification("Failed to maximize " . appConfig.name . ": " . e.message)
        }
    } else {
        ; 简单重试一次
        static retryCount := Map()
        if (!retryCount.Has(appKey)) {
            retryCount[appKey] := 0
        }

        retryCount[appKey]++
        if (retryCount[appKey] < 2) {
            SetTimer(() => WaitAndMaximizeWindow(appKey), -2000)
        } else {
            retryCount.Delete(appKey)
        }
    }
}

; 启动应用程序
LaunchApp(appKey, *) {
    if (!Apps.Has(appKey)) {
        ShowNotification("Not found: " . appKey)
        return
    }

    appConfig := Apps[appKey]
    launched := false

    ; 尝试各种启动路径
    for path in appConfig.launchPaths {
        try
        {
            ; 如果设置了自动最大化，直接以最大化状态启动
            if (appConfig.HasOwnProp("maximize") && appConfig.maximize) {
                Run(path, , "Max")  ; 第三个参数 "Max" 表示最大化启动
                ShowNotification("Starting " . appConfig.name . " (maximized)...")

                ; 添加备用方案：如果应用不支持启动时最大化，2秒后尝试手动最大化
                SetTimer(() => BackupMaximizeWindow(appKey), -2000)
            } else {
                Run(path)
                ShowNotification("Starting " . appConfig.name . "...")
            }

            launched := true
            AppWindowIndex[appKey] := 0  ; Reset index
            break
        }
        catch {
            continue
        }
    }

    if (!launched) {
        MsgBox("Unable to start " . appConfig.name . "。`nPlease ensure the application is installed correctly。", "Launch Failed - " . SCRIPT_NAME, 0x10)
    }
}

; 显示通知
ShowNotification(message, delay := 1500) {
    ToolTip(message)
    SetTimer(() => ToolTip(), -delay)
}

; ==================== 扩展功能 ====================

; 显示应用状态
ShowAppStatus() {
    status := "Windows Quake - application status:`n`n"

    for appKey, appConfig in Apps {
        windows := GetAppWindows(appConfig.exe)
        windowCount := windows.Length

        if (windowCount > 0) {
            activeCount := 0
            minimizedCount := 0

            for hwnd in windows {
                if (WinActive(hwnd)) {
                    activeCount++
                }
                else if (WinGetMinMax(hwnd) = -1) {
                    minimizedCount++
                }
            }

            statusText := windowCount . " windows"
            if (activeCount > 0) {
                statusText .= " (Active: " . activeCount . ")"
            }
            if (minimizedCount > 0) {
                statusText .= " (Minimized: " . minimizedCount . ")"
            }

            status .= appConfig.hotkey . " - " . appConfig.name . ": " . statusText . "`n"
        }
        else {
            status .= appConfig.hotkey . " - " . appConfig.name . ": Not Running`n"
        }
    }

    MsgBox(status, "Application Status - " . SCRIPT_NAME, 0x1000)
}

; ==================== 系统托盘菜单 ====================

; 🤖 自动根据配置创建托盘菜单
CreateTrayMenu()

CreateTrayMenu() {
    ; 清除默认菜单并创建自定义菜单
    A_TrayMenu.Delete()

    ; 为每个应用添加菜单项
    for appKey, appConfig in Apps {
        if IsDisabled(appConfig) {
            continue
        }
        A_TrayMenu.Add("Toggle " . appConfig.name . " (" . appConfig.hotkey . ")", ToggleApp.Bind(appKey))
    }

    A_TrayMenu.Add()  ; 分隔线
    A_TrayMenu.Add("Show app status", (*) => ShowAppStatus())
    A_TrayMenu.Add("Show current app config status", (*) => ShowCurrentConfig())
    A_TrayMenu.Add("Open directory of script and config file", (*) => OpenScriptDirectory())
    A_TrayMenu.Add("Open configuration file", (*) => OpenConfigFile())
    A_TrayMenu.Add("Help", ShowHelp)
    A_TrayMenu.Add()  ; 分隔线
    A_TrayMenu.Add("Exit", (*) => ExitApp())

    ; 设置默认菜单项
    A_TrayMenu.Default := "Show app status"
}

; ==================== 帮助和管理 ====================

; 显示帮助
ShowHelp(*) {
    ; 动态生成帮助文本
    helpText := SCRIPT_FULLNAME . "`n`nCurrent managed applications:`n"

    ; 列出所有配置的应用
    for appKey, appConfig in Apps {
        helpText .= appConfig.hotkey . "  - " . appConfig.name . "`n"
    }

    helpText .= "
    (

Hotkey Description:
    Hotkey        - Toggle corresponding application display/hide/launch

Function Description:
    • The first press of the hotkey will start the corresponding application
    • Single window: Minimize when active, activate when inactive
    • Multi-window: Cycle through each window, minimize all when on the last window
    • Display window titles and numbers for easy identification

Multi-window cycle logic:
    1. First press: Activate the first window
    2. Continue pressing: Activate subsequent windows in turn
    3. Last window: Minimize all windows
    4. Press again: Start again from the first window

Adding new applications:
    Simply add new application configurations to the Apps section at the beginning of the script!
    You can also modify configuration file which can be located by right-clicking the 'Open Configuration file'.

    Right-clicking the system tray icon provides access to more features.
    )"

    MsgBox(helpText, "Help - " . SCRIPT_NAME)
}


; ==================== 初始化 ====================

; 生成启动通知
GenerateStartupNotification()

GenerateStartupNotification() {
    appList := ""
    for appKey, appConfig in Apps {
        if IsDisabled(appConfig) {
            continue
        }
        appList .= "- " . appConfig.hotkey . ":" . appConfig.name . "`n"
    }

    MsgBox(SCRIPT_NAME . " is running `n`n" . appList, "Startup Notification - " . SCRIPT_NAME, "T15")
}