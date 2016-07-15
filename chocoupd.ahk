﻿#Include <JSON>
#Include <translations>

version = 0.3a1
dev := false

; Receive arguments
Loop %0%
{
    param := %A_Index%
    If param = -s
    {
        silent = 1
    }
}

; Insert translations routine
l := getLangName(A_Language)
ftr = %A_ScriptDir%\lang\tr_%l%.json
FileEncoding, UTF-8
FileRead, fstr, %ftr%
FileRead, fstren, %A_ScriptDir%\lang\tr.json
tr := JSON.Load(fstr)
tren := JSON.Load(fstren)

; Call a translation or fallback to english
tr(key)
{
    global tr
    global tren
    t := tr[key]
    If !t
        t := tren[key]
    return t
}

; Set tray tooltip
CHECKING := tr("CHECKING")
Menu, Tray, Tip, chocoupd %CHECKING%
Menu, Tray, NoStandard ; Disable AHK script menu

; Check for Chocolatey
IfNotExist, C:\ProgramData\chocolatey\choco.exe
{
    INSTALL_CHOCOLATEY := tr("INSTALL_CHOCOLATEY")
    MsgBox, 4, chocoupd, %INSTALL_CHOCOLATEY%
    IfMsgBox Yes
    {
        ; Install and wait for Chocolatey to be installed
        RunWait *RunAs %comspec% /c @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin && timeout 5
    } else
    {
        INSTALL_CHOCOLATEY_NEEDED := tr("INSTALL_CHOCOLATEY_NEEDED")
        MsgBox % INSTALL_CHOCOLATEY_NEEDED
        ExitApp, 0
    }        
}

; Create a scheduled task if not exist
scheduled := false
RunWait, %comspec% /c SCHTASKS /Query /TN chocoupd /HRESULT > %A_Temp%\ts.log,,Hide
FileRead, sch, %A_Temp%\ts.log
RegExMatch(sch, "chocoupd", ts)
If !ts
{
    scheduled := true
    If !silent
    {
        SETUP_TASK := tr("SETUP_TASK")
        MsgBox, 4, chocoupd, %SETUP_TASK%
        IfMsgBox Yes
        {
            FileEncoding, UTF-16
            ; Dynamically replace the executable path in the task file
            FileRead, task, %A_ScriptDir%\task.xml
            newPath = <Command>%A_ScriptDir%\chocoupd.exe</Command>
            str := RegExReplace(task, "<Command>(.*)</Command>", newPath)
            FileDelete, %A_ScriptDir%\task.xml
            FileAppend, %str%, %A_ScriptDir%\task.xml

            ; Schedule the task
            RunWait, %comspec% /c SCHTASKS /Create /TN chocoupd /xml task.xml,,Hide
        }
    }    
}
FileDelete, %A_Temp%\ts.log
FileEncoding, UTF-8

If !dev
    RunWait, cmd /c choco outdated > %A_Temp%\chocoupd.log -Force,, Hide

; Draw the Gui
Gui, Add, ListView, x10 y80 w480 h350 Checked NoSortHdr ReadOnly -LV0x10, Nom|Local|Distant
Gui, Add, Picture, x15 y15 w50 h50, icon.ico
INSTALL_UPDATES := tr("INSTALL_UPDATES")
Gui, Add, Button, x340 y440 w150 h25 gInstall, %INSTALL_UPDATES%
CONFIGURATION := tr("CONFIGURATION")
Gui, Add, Button, x180 y440 w150 h25 gConfiguration, %CONFIGURATION%
Gui, Font, s10
UPDATE_AVAILABLE := tr("UPDATE_AVAILABLE")
Gui, Add, Text, x75 y20, %UPDATE_AVAILABLE%
SELECT_FILES := tr("SELECT_FILES")
Gui, Add, Text, x75 y45, %SELECT_FILES%
Gui, Add, Text, x10 y445, v%version%
Gui, Font, s8

; Get a list of programs to update
If !dev
{
    n = 0
    Loop, Read, %A_Temp%\chocoupd.log
    {
        RegExMatch(A_LoopReadLine, "(.*)\|(.*)\|(.*)\|(.*)[^?]$", v)
        If v
        {
            If (v2 <> v3)
            {
                n++
                LV_Add("", v1, v2, v3)
                LV_ModifyCol(n, 150)
            }
        }        
    }
    FileDelete, %A_Temp%\chocoupd.log

    If (n = 0)
    {
        ExitApp, 0
    }
} Else
{
    LV_Add("", "test", "1", "2")
    LV_Add("", "test", "3", "5")
    LV_ModifyCol(1, 150)
    LV_ModifyCol(2, 150)
}

Gui, Show, w500 h475 Minimize, chocoupd

; Setup configuration GUI
Gui, 2:Font, s10
Gui, 2:Add, Text, x10 y5, Configuration
Gui, 2:Font, s8
Gui, 2:Add, Checkbox, x10 y30 vScheduleTasks, Automatically check for updates
FREQ_EACH_DAY = Each day
FREQ_EACH_WEEK = Each week
FREQ_EACH_MONTH = Each month
Gui, 2:Add, DropDownList, x10 y55 vFrequence, %FREQ_EACH_DAY%||%FREQ_EACH_WEEK%|%FREQ_EACH_MONTH%

return

Install:
{
    r = 0
    cmd =
    Loop
    {
        r := LV_GetNext(r, "Checked")
        If not r
            break
        LV_GetText(t, r)
        cmd = %cmd% %t%
    }
    Run  *RunAs %comspec% /c cup -y %cmd% && timeout 5
    exitapp
}
Return

Configuration:
{
    
    Gui, 2:Show
}
return

GuiClose:
exitapp