#Requires AutoHotkey v2.0
; Windows Quake - Quick Window Switcher
; AutoHotkey v2 Script
; Author：Sean2077

VERSION := "1.3.0"
SCRIPT_NAME := "winguake(v" . VERSION . ")"

; ==================== 多语言支持 ====================
; 检测系统语言并设置对应的语言包
SYSTEM_LANG := A_Language
IS_CHINESE := (SYSTEM_LANG = "0804" || SYSTEM_LANG = "0404" || SYSTEM_LANG = "0C04" || SYSTEM_LANG = "1004" || SYSTEM_LANG = "1404")

; 语言包
Lang := {}

if (IS_CHINESE) {
    ; 中文语言包
    Lang.SCRIPT_FULLNAME := "Windows Quake - 快速窗口切换器 (v" . VERSION . ")"
    Lang.CONFIG_EMPTY := "配置文件为空"
    Lang.CONFIG_SUCCESS := "读取配置文件成功 🎉🎉🎉"
    Lang.CONFIG_FAILED := "读取配置文件失败 💩💩💩"
    Lang.CONFIG_NOT_FOUND := "未找到配置文件，使用默认配置"
    Lang.CONFIG_VALIDATION_PASSED := "所有配置验证通过"
    Lang.CONFIG_VALIDATION_ISSUES := "配置验证发现问题：`n`n"
    Lang.CONFIG_FILE_MISSING := "未找到配置文件"
    Lang.CONFIG_FILE_CREATE_PROMPT := "`n是否要创建新的配置文件？"
    Lang.HOTKEY_REGISTER_FAILED := "热键注册失败"
    Lang.APP_NOT_FOUND := "未找到应用"
    Lang.APP_MINIMIZED := "已最小化"
    Lang.APP_ACTIVATED := "已激活"
    Lang.APP_ALL_MINIMIZED := "所有窗口已最小化"
    Lang.APP_STARTING := "正在启动"
    Lang.APP_STARTING_MAXIMIZED := "正在启动（最大化）"
    Lang.APP_MAXIMIZED := "已最大化"
    Lang.APP_MAXIMIZED_BACKUP := "已最大化（备用方法）"
    Lang.APP_MAXIMIZED_FAILED := "备用最大化失败"
    Lang.APP_ALREADY_MAXIMIZED := "已经是最大化状态"
    Lang.LAUNCH_FAILED := "启动失败"
    Lang.LAUNCH_FAILED_MSG := "无法启动应用程序。`n请确保应用程序已正确安装。"
    Lang.STATUS_TITLE := "应用状态"
    Lang.STATUS_HEADER := "Windows Quake - 应用程序状态：`n`n"
    Lang.STATUS_WINDOWS := "个窗口"
    Lang.STATUS_ACTIVE := "活动"
    Lang.STATUS_MINIMIZED := "最小化"
    Lang.STATUS_NOT_RUNNING := "未运行"
    Lang.MENU_TOGGLE := "切换"
    Lang.MENU_SHOW_STATUS := "显示应用状态"
    Lang.MENU_SHOW_CONFIG := "编辑当前应用配置状态"
    Lang.MENU_OPEN_DIR := "打开脚本和配置文件目录"
    Lang.MENU_OPEN_CONFIG := "打开配置文件"
    Lang.MENU_HELP := "帮助"
    Lang.MENU_EXIT := "退出"
    Lang.HELP_TITLE := "帮助"
    Lang.HELP_CURRENT_APPS := "`n`n当前管理的应用程序：`n"
    Lang.HELP_HOTKEY_DESC := "`n`n热键说明：`n    热键        - 切换对应应用程序的显示/隐藏/启动"
    Lang.HELP_FUNCTION_DESC := "`n`n功能说明：`n    • 首次按下热键将启动对应的应用程序`n    • 单窗口：活动时最小化，非活动时激活`n    • 多窗口：提供两种循环模式（可通过 cycleContinuous 选项配置）`n    • 显示窗口标题和编号，便于识别"
    Lang.HELP_CYCLE_LOGIC := "`n`n多窗口循环逻辑：`n    1. 首次按下：激活第一个窗口`n    2. 继续按下：依次激活后续窗口`n    3. 最后窗口行为（取决于 cycleContinuous 设置）：`n       - cycleContinuous=true（默认）：跳回第一个窗口并继续循环`n       - cycleContinuous=false：最小化所有窗口`n    4. 所有窗口最小化时：再次按下从第一个窗口开始"
    Lang.HELP_CONFIG_OPTIONS := "`n`n配置选项：`n    • cycleContinuous: true/false - 控制多窗口循环行为`n    • maximize: true/false - 是否在启动时最大化窗口`n    • disable: true/false - 是否禁用此应用程序"
    Lang.HELP_ADD_APPS := "`n`n添加新应用程序：`n    只需在脚本开头的 Apps 部分添加新的应用程序配置即可！`n    您也可以修改配置文件，通过右键单击`"打开配置文件`"找到配置文件位置。`n`n    右键单击系统托盘图标可访问更多功能。"
    Lang.CONFIG_TITLE := "当前配置"
    Lang.CONFIG_HEADER := "当前应用配置（有效部分）：`n`n"
    Lang.CONFIG_HOTKEY := "  热键："
    Lang.CONFIG_PROCESS := "  进程名："
    Lang.CONFIG_LAUNCH_CMD := "  启动命令："
    Lang.CONFIG_DISPLAY_NAME := "  显示名称："
    Lang.CONFIG_LAUNCH_PATHS := "  启动路径："
    Lang.CONFIG_DISABLED := "  已禁用："
    Lang.CONFIG_MAXIMIZE := "  启动时最大化："
    Lang.CONFIG_CYCLE := "  持续循环："
    Lang.YES := "是"
    Lang.NO := "否"
    Lang.STARTUP_TITLE := "启动通知"
    Lang.STARTUP_RUNNING := "正在运行"
    Lang.VALIDATION_TITLE := "配置验证"
    Lang.UPDATED := "已更新"
    Lang.APPLICATIONS := "个应用程序"
    Lang.NO_UPDATES := "未找到有效的配置更新"
    ; 配置编辑器相关文本
    Lang.CONFIG_EDITOR_HELP := "在下方编辑配置，然后点击 '保存并应用' 来更新设置。配置采用INI格式。"
    Lang.CONFIG_SAVE_APPLY := "保存并应用"
    Lang.CONFIG_RESET := "重置"
    Lang.CONFIG_FORMAT_DESC := "配置文件格式说明："
    Lang.CONFIG_SECTION_DESC := "每个应用程序一个段落 [AppName]"
    Lang.CONFIG_OPTIONS_DESC := "支持的配置项：hotkey, exe, launchCmd, name, launchPaths, maximize, cycleContinuous, disable"
    Lang.CONFIG_PATHS_DESC := "launchPaths 用 | 分隔多个路径"
    Lang.CONFIG_SAVE_SUCCESS := "配置已保存并应用成功！"
    Lang.CONFIG_VALIDATION_FAILED := "配置验证失败，请检查配置格式。"
    Lang.CONFIG_SAVE_FAILED := "保存配置文件失败："
    Lang.CONFIG_RESET_CONFIRM := "确定要重置到当前配置吗？所有未保存的更改将丢失。"
} else {
    ; 英文语言包（默认）
    Lang.SCRIPT_FULLNAME := "Windows Quake - Quick Window Switcher (v" . VERSION . ")"
    Lang.CONFIG_EMPTY := "configuration is empty"
    Lang.CONFIG_SUCCESS := "Read config file successful 🎉🎉🎉"
    Lang.CONFIG_FAILED := "Read config file failed 💩💩💩"
    Lang.CONFIG_NOT_FOUND := "Config file not found, use default"
    Lang.CONFIG_VALIDATION_PASSED := "All configuration validation passed"
    Lang.CONFIG_VALIDATION_ISSUES := "Configuration validation found issues:`n`n"
    Lang.CONFIG_FILE_MISSING := "Configuration file not found"
    Lang.CONFIG_FILE_CREATE_PROMPT := "`nDo you want to create a new one?"
    Lang.HOTKEY_REGISTER_FAILED := "Failed to register hotkey"
    Lang.APP_NOT_FOUND := "Not found"
    Lang.APP_MINIMIZED := "is minimized"
    Lang.APP_ACTIVATED := "is activated"
    Lang.APP_ALL_MINIMIZED := "all windows are minimized"
    Lang.APP_STARTING := "Starting"
    Lang.APP_STARTING_MAXIMIZED := "Starting (maximized)"
    Lang.APP_MAXIMIZED := "maximized"
    Lang.APP_MAXIMIZED_BACKUP := "maximized (backup method)"
    Lang.APP_MAXIMIZED_FAILED := "backup maximize failed"
    Lang.APP_ALREADY_MAXIMIZED := "already maximized"
    Lang.LAUNCH_FAILED := "Launch Failed"
    Lang.LAUNCH_FAILED_MSG := "Unable to start application.`nPlease ensure the application is installed correctly."
    Lang.STATUS_TITLE := "Application Status"
    Lang.STATUS_HEADER := "Windows Quake - application status:`n`n"
    Lang.STATUS_WINDOWS := "windows"
    Lang.STATUS_ACTIVE := "Active"
    Lang.STATUS_MINIMIZED := "Minimized"
    Lang.STATUS_NOT_RUNNING := "Not Running"
    Lang.MENU_TOGGLE := "Toggle"
    Lang.MENU_SHOW_STATUS := "Show app status"
    Lang.MENU_SHOW_CONFIG := "Edit current app config status"
    Lang.MENU_OPEN_DIR := "Open directory of script and config file"
    Lang.MENU_OPEN_CONFIG := "Open configuration file"
    Lang.MENU_HELP := "Help"
    Lang.MENU_EXIT := "Exit"
    Lang.HELP_TITLE := "Help"
    Lang.HELP_CURRENT_APPS := "`n`nCurrent managed applications:`n"
    Lang.HELP_HOTKEY_DESC := "`n`nHotkey Description:`n    Hotkey        - Toggle corresponding application display/hide/launch"
    Lang.HELP_FUNCTION_DESC := "`n`nFunction Description:`n    • The first press of the hotkey will start the corresponding application`n    • Single window: Minimize when active, activate when inactive`n    • Multi-window: Two cycle modes available (configurable via cycleContinuous option)`n    • Display window titles and numbers for easy identification"
    Lang.HELP_CYCLE_LOGIC := "`n`nMulti-window cycle logic:`n    1. First press: Activate the first window`n    2. Continue pressing: Activate subsequent windows in turn`n    3. Last window behavior (depends on cycleContinuous setting):`n       - cycleContinuous=true (default): Jump back to first window and continue cycling`n       - cycleContinuous=false: Minimize all windows`n    4. When all windows minimized: Press again to start from the first window"
    Lang.HELP_CONFIG_OPTIONS := "`n`nConfiguration options:`n    • cycleContinuous: true/false - Controls multi-window cycling behavior`n    • maximize: true/false - Whether to maximize window on startup`n    • disable: true/false - Whether to disable this application"
    Lang.HELP_ADD_APPS := "`n`nAdding new applications:`n    Simply add new application configurations to the Apps section at the beginning of the script!`n    You can also modify configuration file which can be located by right-clicking the `"Open Configuration file`".`n`n    Right-clicking the system tray icon provides access to more features."
    Lang.CONFIG_TITLE := "Current Configuration"
    Lang.CONFIG_HEADER := "Current application configuration (valid parts):`n`n"
    Lang.CONFIG_HOTKEY := "  Hotkey: "
    Lang.CONFIG_PROCESS := "  Process Name: "
    Lang.CONFIG_LAUNCH_CMD := "  Launch Command: "
    Lang.CONFIG_DISPLAY_NAME := "  Display Name: "
    Lang.CONFIG_LAUNCH_PATHS := "  Launch Paths: "
    Lang.CONFIG_DISABLED := "  Disabled: "
    Lang.CONFIG_MAXIMIZE := "  Maximize on Start: "
    Lang.CONFIG_CYCLE := "  Cycle Continuous: "
    Lang.YES := "Yes"
    Lang.NO := "No"
    Lang.STARTUP_TITLE := "Startup Notification"
    Lang.STARTUP_RUNNING := "is running"
    Lang.VALIDATION_TITLE := "Configuration Validation"
    Lang.UPDATED := "Updated: "
    Lang.APPLICATIONS := " applications"
    Lang.NO_UPDATES := "No valid configuration updates found"
    ; 配置编辑器相关文本
    Lang.CONFIG_EDITOR_HELP := "Edit the configuration below, then click 'Save & Apply' to update settings. Configuration uses INI format."
    Lang.CONFIG_SAVE_APPLY := "Save & Apply"
    Lang.CONFIG_RESET := "Reset"
    Lang.CONFIG_FORMAT_DESC := "Configuration Format:"
    Lang.CONFIG_SECTION_DESC := "Each application has a section [AppName]"
    Lang.CONFIG_OPTIONS_DESC := "Supported options: hotkey, exe, launchCmd, name, launchPaths, maximize, cycleContinuous, disable"
    Lang.CONFIG_PATHS_DESC := "launchPaths use | to separate multiple paths"
    Lang.CONFIG_SAVE_SUCCESS := "Configuration saved and applied successfully!"
    Lang.CONFIG_VALIDATION_FAILED := "Configuration validation failed, please check the format."
    Lang.CONFIG_SAVE_FAILED := "Failed to save configuration file:"
    Lang.CONFIG_RESET_CONFIRM := "Are you sure you want to reset to current configuration? All unsaved changes will be lost."
}

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
    maximize: true,                  ; 启动时最大化
    cycleContinuous: true            ; 多窗口循环模式：true=持续循环不最小化，false=循环到最后窗口时最小化所有窗口
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
    maximize: true,  ; 默认启动时最大化
    cycleContinuous: true  ; 多窗口循环模式：持续循环不最小化
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
    maximize: true,  ; 默认启动时最大化
    cycleContinuous: true  ; 多窗口循环模式：持续循环不最小化
}

; ==================== 读取配置文件 ====================

; 转换字符串为布尔值
ConvertToBool(value) {
    ; 去除前后空格并转为小写
    cleanValue := Trim(StrLower(value))

    ; 检查真值
    if (cleanValue = "true" || cleanValue = "yes" || cleanValue = "1" || cleanValue = "on") {
        return true
    }

    ; 检查假值
    if (cleanValue = "false" || cleanValue = "no" || cleanValue = "0" || cleanValue = "off" || cleanValue = "") {
        return false
    }

    ; 默认返回假值
    return false
}

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
        ToolTip(Lang.CONFIG_EMPTY, , , 1)
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

                    case "maximize", "cycleContinuous", "disable":
                        ; 处理布尔类型的配置
                        Apps[sectionName].%keyName% := ConvertToBool(value)

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

                    case "maximize", "cycleContinuous", "disable":
                        ; 处理布尔类型的配置
                        newApp.%keyName% := ConvertToBool(value)

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
            if (!newApp.HasOwnProp("maximize"))
                newApp.maximize := false
            if (!newApp.HasOwnProp("cycleContinuous"))
                newApp.cycleContinuous := true
            if (!newApp.HasOwnProp("disable"))
                newApp.disable := false

            Apps[sectionName] := newApp
            updatedApps.Push(sectionName . " (New)")
        }
    }

    ; 显示更新结果
    if (updatedApps.Length > 0) {
        message := Lang.UPDATED . updatedApps.Length . Lang.APPLICATIONS . "`n"
        for index, appName in updatedApps {
            message .= "- " . appName . "`n"
        }
        ToolTip(message, , , 1)
        SetTimer(() => ToolTip("", , , 1), -3000)
    } else {
        ToolTip(Lang.NO_UPDATES, , , 1)
        SetTimer(() => ToolTip("", , , 1), -2000)
    }

    return ValidateAllConfigs()
}


; 辅助函数：验证配置完整性
ValidateAppConfig(appName, appConfig) {
    issues := []
    ; 检查是否被禁用，若被禁用则跳过验证
    if (IsDisabled(appConfig))
        return issues

    ; 检查真正必需的字段（启动应用的最小要求）
    if (!appConfig.HasOwnProp("hotkey") || appConfig.hotkey = "")
        issues.Push("missing hotkey configuration: hotkey")

    if (!appConfig.HasOwnProp("exe") || appConfig.exe = "")
        issues.Push("missing process name configuration: exe")

    ; launchCmd 或 launchPaths 至少需要一个
    hasLaunchCmd := appConfig.HasOwnProp("launchCmd") && appConfig.launchCmd != ""
    hasLaunchPaths := appConfig.HasOwnProp("launchPaths") && appConfig.launchPaths.Length > 0

    if (!hasLaunchCmd && !hasLaunchPaths)
        issues.Push("missing launch method: need either launchCmd or launchPaths")

    ; name 如果为空，设置默认值而不是报错
    if (!appConfig.HasOwnProp("name") || appConfig.name = "")
        appConfig.name := appName

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
        message := Lang.CONFIG_VALIDATION_ISSUES
        for appName, issues in allIssues {
            message .= "[" . appName . "]`n"
            for index, issue in issues {
                message .= "  - " . issue . "`n"
            }
            message .= "`n"
        }
        MsgBox(message, Lang.VALIDATION_TITLE . " - " . SCRIPT_NAME, "T15")
        ; 仅存在热键冲突或有效应用配置为0的情况认为配置失败
        if allIssues.Has("HotKey Conflict!") || Apps.Count = 0
            return false
    }


    ToolTip(Lang.CONFIG_VALIDATION_PASSED, , , 1)
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
        MsgBoxResult := MsgBox(Lang.CONFIG_FILE_MISSING . ": " . configFile . Lang.CONFIG_FILE_CREATE_PROMPT, Lang.CONFIG_FILE_MISSING . " - " . SCRIPT_NAME, 4)
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
    ; 使用可编辑的配置窗口
    ShowConfigEditor()
}

; 显示配置编辑器窗口
ShowConfigEditor() {
    ; 生成当前配置的INI格式文本
    configText := GenerateConfigText()

    ; 创建GUI窗口
    configGui := Gui("+Resize +MinSize500x400", Lang.CONFIG_TITLE . " - " . SCRIPT_NAME)
    configGui.MarginX := 10
    configGui.MarginY := 10

    ; 添加说明文本
    infoCtrl := configGui.Add("Text", "w580 h30 +Wrap", Lang.CONFIG_EDITOR_HELP)
    infoCtrl.SetFont("s9")

    ; 添加编辑控件（可编辑，支持滚动）
    editCtrl := configGui.Add("Edit", "VScroll HScroll w580 h300", configText)
    editCtrl.SetFont("s9", "Consolas")  ; 使用等宽字体便于编辑

    ; 添加按钮行
    buttonY := 350

    ; 保存并应用按钮
    saveBtn := configGui.Add("Button", "x10 y" . buttonY . " w120 h30", Lang.CONFIG_SAVE_APPLY)
    saveBtn.OnEvent("Click", (*) => SaveConfigFromEditor(editCtrl, configGui))

    ; 重置按钮
    resetBtn := configGui.Add("Button", "x140 y" . buttonY . " w80 h30", Lang.CONFIG_RESET)
    resetBtn.OnEvent("Click", (*) => ResetConfigEditor(editCtrl))

    ; 关闭按钮
    closeBtn := configGui.Add("Button", "x480 y" . buttonY . " w100 h30", Lang.MENU_EXIT)
    closeBtn.OnEvent("Click", (*) => configGui.Destroy())

    ; 设置窗口事件
    configGui.OnEvent("Close", (*) => configGui.Destroy())
    configGui.OnEvent("Escape", (*) => configGui.Destroy())

    ; 显示窗口
    configGui.Show("w600 h400")

    ; 窗口大小调整事件
    configGui.OnEvent("Size", ConfigEditor_Size)

    ConfigEditor_Size(GuiObj, MinMax, Width, Height) {
        if (MinMax = -1)  ; 最小化时不处理
            return

        ; 调整控件大小和位置
        newWidth := Width - 20
        newEditHeight := Height - 100
        newButtonY := Height - 40

        infoCtrl.Move(, , newWidth)
        editCtrl.Move(, , newWidth, newEditHeight)

        ; 重新定位按钮
        saveBtn.Move(, newButtonY)
        resetBtn.Move(, newButtonY)
        closeBtn.Move(newWidth - 100, newButtonY)
    }
}

; 生成配置文本（INI格式）
GenerateConfigText() {
    configText := "; " . Lang.SCRIPT_FULLNAME . " Configuration File`n"
    configText .= "; " . Lang.CONFIG_FORMAT_DESC . "`n"
    configText .= "; " . Lang.CONFIG_SECTION_DESC . "`n"
    configText .= "; " . Lang.CONFIG_OPTIONS_DESC . "`n"
    configText .= "; " . Lang.CONFIG_PATHS_DESC . "`n`n"

    sortedApps := GetSortedApps(true)  ; 包含禁用的应用
    for index, appData in sortedApps {
        appName := appData.key
        appConfig := appData.config

        configText .= "[" . appName . "]`n"

        ; 基本配置
        configText .= "hotkey=" . appConfig.hotkey . "`n"
        configText .= "exe=" . appConfig.exe . "`n"
        configText .= "launchCmd=" . appConfig.launchCmd . "`n"
        configText .= "name=" . appConfig.name . "`n"

        ; 启动路径（转换为 | 分隔的字符串）
        if (appConfig.launchPaths.Length > 0) {
            pathStr := ""
            for i, path in appConfig.launchPaths {
                pathStr .= path
                if (i < appConfig.launchPaths.Length)
                    pathStr .= "|"
            }
            configText .= "launchPaths=" . pathStr . "`n"
        }

        ; 可选配置
        if (appConfig.HasOwnProp("maximize"))
            configText .= "maximize=" . (appConfig.maximize ? "true" : "false") . "`n"
        if (appConfig.HasOwnProp("cycleContinuous"))
            configText .= "cycleContinuous=" . (appConfig.cycleContinuous ? "true" : "false") . "`n"
        if (appConfig.HasOwnProp("disable"))
            configText .= "disable=" . (appConfig.disable ? "true" : "false") . "`n"

        configText .= "`n"
    }

    return configText
}

; 从编辑器保存配置
SaveConfigFromEditor(editCtrl, configGui) {
    configText := editCtrl.Text

    ; 获取配置文件路径
    configPath := GetConfigFilePath()

    try {
        ; 保存到文件
        FileDelete(configPath)  ; 删除旧文件
        FileAppend(configText, configPath, "UTF-8")

        ; 重新加载配置
        if (LoadConfig(configPath)) {
            ; 重新注册热键
            RegisterHotkeys()

            ; 重建托盘菜单
            CreateTrayMenu()

            ; 显示成功消息
            MsgBox(Lang.CONFIG_SAVE_SUCCESS, Lang.CONFIG_TITLE . " - " . SCRIPT_NAME, "T3")

            ; 关闭编辑器窗口
            configGui.Destroy()
        } else {
            ; 配置验证失败
            MsgBox(Lang.CONFIG_VALIDATION_FAILED, Lang.CONFIG_TITLE . " - " . SCRIPT_NAME, 0x10)
        }
    } catch as e {
        ; 保存失败
        MsgBox(Lang.CONFIG_SAVE_FAILED . " " . e.message, Lang.CONFIG_TITLE . " - " . SCRIPT_NAME, 0x10)
    }
}

; 重置配置编辑器内容
ResetConfigEditor(editCtrl) {
    result := MsgBox(Lang.CONFIG_RESET_CONFIRM, Lang.CONFIG_TITLE . " - " . SCRIPT_NAME, 4)
    if (result = "Yes") {
        editCtrl.Text := GenerateConfigText()
    }
}

; 显示可滚动文本窗口（保留用于其他功能）
ShowScrollableText(text, title := "Information", width := 600, height := 400) {
    ; 创建GUI窗口
    configGui := Gui("+Resize +MinSize400x300", title)
    configGui.MarginX := 10
    configGui.MarginY := 10

    ; 添加编辑控件（只读，支持滚动）
    editCtrl := configGui.Add("Edit", "ReadOnly VScroll HScroll w" . (width - 40) . " h" . (height - 80), text)
    editCtrl.SetFont("s9", "Consolas")  ; 使用等宽字体便于阅读

    ; 添加关闭按钮
    closeBtn := configGui.Add("Button", "w100 h30", Lang.MENU_EXIT)
    closeBtn.OnEvent("Click", (*) => configGui.Destroy())

    ; 设置窗口事件
    configGui.OnEvent("Close", (*) => configGui.Destroy())
    configGui.OnEvent("Escape", (*) => configGui.Destroy())

    ; 居中显示窗口
    configGui.Show("w" . width . " h" . height)

    ; 窗口大小调整事件
    configGui.OnEvent("Size", ConfigGui_Size)

    ConfigGui_Size(GuiObj, MinMax, Width, Height) {
        if (MinMax = -1)  ; 最小化时不处理
            return

        ; 调整编辑控件大小
        editCtrl.Move(, , Width - 40, Height - 80)
        ; 调整按钮位置
        closeBtn.Move((Width - 100) / 2, Height - 50)
    }
}

IsDisabled(appConfig) {
    if !appConfig.HasOwnProp("disable")
        return false

    ; 如果 disable 是布尔值，直接返回
    if (Type(appConfig.disable) = "Integer")
        return appConfig.disable

    ; 如果是字符串，进行转换
    return ConvertToBool(appConfig.disable)
}

; 获取按快捷键排序的应用列表
GetSortedApps(includeDisabled := false) {
    sortedApps := []

    ; 收集所有应用
    for appKey, appConfig in Apps {
        if (!includeDisabled && IsDisabled(appConfig)) {
            continue
        }
        sortedApps.Push({ key: appKey, config: appConfig })
    }

    ; 按快捷键排序
    if (sortedApps.Length > 1) {
        loop sortedApps.Length - 1 {
            outer := A_Index
            loop sortedApps.Length - outer {
                inner := A_Index
                ; 使用字符串比较
                hotkey1 := sortedApps[inner].config.hotkey
                hotkey2 := sortedApps[inner + 1].config.hotkey
                if (StrCompare(hotkey1, hotkey2) > 0) {
                    temp := sortedApps[inner]
                    sortedApps[inner] := sortedApps[inner + 1]
                    sortedApps[inner + 1] := temp
                }
            }
        }
    }

    return sortedApps
}


configFile := GetConfigFilePath()
if (FileExist(configFile)) {
    if (LoadConfig(configFile)) {
        ShowNotification(Lang.CONFIG_SUCCESS . ": " . configFile)
    } else {
        ShowNotification(Lang.CONFIG_FAILED . ": " . configFile)
        ; ShowCurrentConfig()
        ExitApp()
    }
} else {
    ShowNotification(Lang.CONFIG_NOT_FOUND . ": " . configFile)
}

; ShowCurrentConfig()


; ==================== 全局状态跟踪 ====================
; 记录每个应用的当前活动窗口索引
AppWindowIndex := Map()

; ==================== 自动化热键注册 ====================
; 🤖 这部分会自动根据配置创建热键，无需手动修改！

; 存储已注册的热键
RegisteredHotkeys := Map()

; 根据配置自动注册热键
RegisterHotkeys()

RegisterHotkeys() {
    ; 先清除所有已注册的热键
    ClearAllHotkeys()

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
                RegisteredHotkeys[appConfig.hotkey] := appKey
            }
            catch as err {
                ShowNotification(Lang.HOTKEY_REGISTER_FAILED . ": " . appConfig.hotkey . " - " . err.message)
            }
        }
    }
}

; 清除所有已注册的热键
ClearAllHotkeys() {
    for hotkey, appKey in RegisteredHotkeys {
        try {
            Hotkey(hotkey, "Off")
        } catch {
            ; 忽略清除失败的热键
        }
    }
    RegisteredHotkeys.Clear()
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

        ; 按窗口创建时间排序，确保顺序一致
        ; 这样可以避免窗口顺序变化导致的问题
        if (windows.Length > 1) {
            ; 简单的冒泡排序，按窗口句柄排序（通常反映创建顺序）
            loop windows.Length - 1 {
                outer := A_Index
                loop windows.Length - outer {
                    inner := A_Index
                    if (windows[inner] > windows[inner + 1]) {
                        temp := windows[inner]
                        windows[inner] := windows[inner + 1]
                        windows[inner + 1] := temp
                    }
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
        ShowNotification(Lang.APP_NOT_FOUND . ": " . appKey)
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
            ShowNotification(appConfig.name . " " . Lang.APP_MINIMIZED)
            AppWindowIndex[appKey] := 0  ; 重置索引
        }
        else {
            ; 窗口存在但不活动 - 激活
            if (isMinimized = -1) {
                WinRestore(hwnd)
            }
            WinActivate(hwnd)
            WinShow(hwnd)
            ShowNotification(appConfig.name . " " . Lang.APP_ACTIVATED)
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
    nextIndex := 0

    ; 检查当前是否有活动的应用窗口
    activeWindowIndex := 0
    for i, hwnd in windows {
        if (WinActive(hwnd)) {
            activeWindowIndex := i
            break
        }
    }

    ; 确定下一个窗口索引
    if (activeWindowIndex > 0) {
        ; 基于当前活动窗口计算下一个窗口
        nextIndex := activeWindowIndex + 1
    } else {
        ; 没有检测到活动窗口，基于保存的索引计算
        if (currentIndex <= 0 || currentIndex > windowCount) {
            ; 索引无效，从第一个窗口开始
            nextIndex := 1
        } else {
            ; 基于保存的索引计算下一个窗口
            nextIndex := currentIndex + 1
        }
    }

    ; 处理循环边界
    if (nextIndex > windowCount) {
        ; 检查是否启用了持续循环模式
        if (appConfig.HasOwnProp("cycleContinuous") && appConfig.cycleContinuous) {
            ; 持续循环模式：回到第一个窗口
            nextIndex := 1
        } else {
            ; 默认模式：最小化所有窗口
            for hwnd in windows {
                if (WinGetMinMax(hwnd) != -1) {  ; 如果窗口没有最小化
                    WinMinimize(hwnd)
                }
            }
            ShowNotification(appConfig.name . " " . Lang.APP_ALL_MINIMIZED . " (total " . windowCount . ")")
            AppWindowIndex[appKey] := 0  ; 重置索引
            return
        }
    }

    ; 激活目标窗口
    targetHwnd := windows[nextIndex]

    if (WinGetMinMax(targetHwnd) = -1) {  ; 如果窗口最小化了
        WinRestore(targetHwnd)
    }
    WinActivate(targetHwnd)
    WinShow(targetHwnd)

    ; 更新索引
    AppWindowIndex[appKey] := nextIndex

    ; 生成窗口标题信息
    windowTitle := WinGetTitle(targetHwnd)
    if (StrLen(windowTitle) > 50) {
        windowTitle := SubStr(windowTitle, 1, 50) . "..."
    }

    ; 添加循环标记
    cycleInfo := ""
    if (nextIndex = 1 && (activeWindowIndex = windowCount || currentIndex = windowCount)) {
        cycleInfo := " (cycle)"
    }

    ShowNotification(appConfig.name . " window " . nextIndex . "/" . windowCount . cycleInfo . ": " . windowTitle)
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
                    ShowNotification("✓ " . appConfig.name . " " . Lang.APP_MAXIMIZED_BACKUP)
                } else {
                    ShowNotification("⚠ " . appConfig.name . " " . Lang.APP_MAXIMIZED_FAILED)
                }
            } else {
                ; 已经是最大化状态
                ShowNotification("✓ " . appConfig.name . " " . Lang.APP_ALREADY_MAXIMIZED)
            }
        }
        catch as e {
            ; 静默失败，不显示错误信息
        }
    }
}

; 启动应用程序
LaunchApp(appKey, *) {
    if (!Apps.Has(appKey)) {
        ShowNotification(Lang.APP_NOT_FOUND . ": " . appKey)
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
                ShowNotification(Lang.APP_STARTING . " " . appConfig.name . " (" . Lang.APP_MAXIMIZED . ")...")

                ; 添加备用方案：如果应用不支持启动时最大化，2秒后尝试手动最大化
                SetTimer(() => BackupMaximizeWindow(appKey), -2000)
            } else {
                Run(path)
                ShowNotification(Lang.APP_STARTING . " " . appConfig.name . "...")
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
        MsgBox(Lang.LAUNCH_FAILED_MSG . " " . appConfig.name, Lang.LAUNCH_FAILED . " - " . SCRIPT_NAME, 0x10)
    }
}

; 显示通知
ShowNotification(message, delay := 500) {
    ToolTip(message)
    SetTimer(() => ToolTip(), -delay)
}

; ==================== 扩展功能 ====================

; 显示应用状态
ShowAppStatus() {
    status := Lang.STATUS_HEADER

    sortedApps := GetSortedApps(true)  ; 包含禁用的应用
    for index, appData in sortedApps {
        appKey := appData.key
        appConfig := appData.config

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

            statusText := windowCount . " " . Lang.STATUS_WINDOWS
            if (activeCount > 0) {
                statusText .= " (" . Lang.STATUS_ACTIVE . ": " . activeCount . ")"
            }
            if (minimizedCount > 0) {
                statusText .= " (" . Lang.STATUS_MINIMIZED . ": " . minimizedCount . ")"
            }

            status .= appConfig.hotkey . " - " . appConfig.name . ": " . statusText . "`n"
        }
        else {
            status .= appConfig.hotkey . " - " . appConfig.name . ": " . Lang.STATUS_NOT_RUNNING . "`n"
        }
    }

    MsgBox(status, Lang.STATUS_TITLE . " - " . SCRIPT_NAME, 0x1000)
}

; ==================== 系统托盘菜单 ====================

; 🤖 自动根据配置创建托盘菜单
CreateTrayMenu()

CreateTrayMenu() {
    ; 清除默认菜单并创建自定义菜单
    A_TrayMenu.Delete()

    ; 为每个应用添加菜单项（按快捷键排序）
    sortedApps := GetSortedApps(false)  ; 不包含禁用的应用
    for index, appData in sortedApps {
        appKey := appData.key
        appConfig := appData.config
        A_TrayMenu.Add(Lang.MENU_TOGGLE . " " . appConfig.name . " (" . appConfig.hotkey . ")", ToggleApp.Bind(appKey))
    }

    A_TrayMenu.Add()  ; 分隔线
    A_TrayMenu.Add(Lang.MENU_SHOW_STATUS, (*) => ShowAppStatus())
    A_TrayMenu.Add(Lang.MENU_SHOW_CONFIG, (*) => ShowCurrentConfig())
    A_TrayMenu.Add(Lang.MENU_OPEN_DIR, (*) => OpenScriptDirectory())
    A_TrayMenu.Add(Lang.MENU_OPEN_CONFIG, (*) => OpenConfigFile())
    A_TrayMenu.Add(Lang.MENU_HELP, ShowHelp)
    A_TrayMenu.Add()  ; 分隔线
    A_TrayMenu.Add(Lang.MENU_EXIT, (*) => ExitApp())

    ; 设置默认菜单项
    A_TrayMenu.Default := Lang.MENU_SHOW_STATUS
}

; ==================== 帮助和管理 ====================

; 显示帮助
ShowHelp(*) {
    ; 动态生成帮助文本
    helpText := Lang.SCRIPT_FULLNAME . Lang.HELP_CURRENT_APPS

    ; 列出所有配置的应用（按快捷键排序）
    sortedApps := GetSortedApps(true)  ; 包含禁用的应用
    for index, appData in sortedApps {
        appConfig := appData.config
        helpText .= appConfig.hotkey . "  - " . appConfig.name . "`n"
    }

    helpText .= Lang.HELP_HOTKEY_DESC
    helpText .= Lang.HELP_FUNCTION_DESC
    helpText .= Lang.HELP_CYCLE_LOGIC
    helpText .= Lang.HELP_CONFIG_OPTIONS
    helpText .= Lang.HELP_ADD_APPS

    MsgBox(helpText, Lang.HELP_TITLE . " - " . SCRIPT_NAME)
}


; ==================== 初始化 ====================

; 生成启动通知
GenerateStartupNotification()

GenerateStartupNotification() {
    appList := ""
    sortedApps := GetSortedApps(false)  ; 不包含禁用的应用
    for index, appData in sortedApps {
        appConfig := appData.config
        appList .= "- " . appConfig.hotkey . ":" . appConfig.name . "`n"
    }

    MsgBox(SCRIPT_NAME . " " . Lang.STARTUP_RUNNING . " `n`n" . appList, Lang.STARTUP_TITLE . " - " . SCRIPT_NAME, "T15")
}