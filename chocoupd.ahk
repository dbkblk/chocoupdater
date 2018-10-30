#Include <JSON>
#Include <translations>

version = 0.4
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

; Functions
removeTask()
{
    RunWait, %comspec% /c SCHTASKS /Delete /TN chocoupd -f,,Hide
}

setDailyTask(hour := 09, minute := 00)
{
    command =
    (
    $action = New-ScheduledTaskAction -Execute "%A_ScriptDir%\chocoupd.exe"
    $trigger = New-ScheduledTaskTrigger -Daily -At %hour%:%minute%
    $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable
    Register-ScheduledTask -TaskName chocoupd -Action $action -Trigger $trigger -Settings $settings
    )

    RunWait, PowerShell -Command &{%command%},,Hide
}

getScheduledTime()
{
    FileDelete, %A_Temp%\cmd
    command = Get-ScheduledTaskInfo -TaskName chocoupd 
    RunWait, PowerShell -Command &{%command%} | Out-File %A_Temp%\cmd, , Hide
    FileRead, cmd, %A_Temp%\cmd
    RegExMatch(cmd, "NextRunTime.*(\d{2}`:\d{2}`:\d{2})", reg)
    FileDelete, %A_Temp%\cmd
    return reg1
}

changeScheduledTime(hour := 09, minute := 00)
{
    command =
    (
    $trigger = New-ScheduledTaskTrigger -Daily -At %hour%:%minute%
    Set-ScheduledTask -TaskName chocoupd -Trigger $trigger
    )

    RunWait, PowerShell -Command &{%command%},,Hide
}

getPowerShellVersion()
{
    FileDelete, %A_Temp%\cmd
    RunWait, %comspec% /c @powershell $PSVersionTable.PSVersion > %A_Temp%\cmd, , Hide, var
    version =
    Loop, Read, %A_Temp%\cmd
    {
        If (A_Index = 4)
        {
            RegExMatch(A_LoopReadLine, "(\d)[\s]*(\d)[\s]*(\d*)", reg)
           version := reg1
            
        }    
    }
    FileDelete, %A_Temp%\cmd
    return version
}

; Load settings
EnvGet, localDir, LOCALAPPDATA
IfExist, %localDir%\chocoupd\settings.ini
{
    IniRead, l, %localDir%\chocoupd\settings.ini, Settings, lang
} Else
{
    FileCreatedir, %localDir%\chocoupd\
    l := getLangName(A_Language)
    IniWrite, %l%, %localDir%\chocoupd\settings.ini, Settings, lang
}

; Insert translations routine
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
        MsgBox, , chocoupd, %INSTALL_CHOCOLATEY_NEEDED%
        ExitApp, 0
    }        
}

; Create a scheduled task if not exist
; scheduled := false
; time := getScheduledTime()
; If !time
; {
;     If !silent
;     {
;         SETUP_TASK := tr("SETUP_TASK")
;         MsgBox, 4, chocoupd, %SETUP_TASK%
;         IfMsgBox Yes
;         {
;             setDailyTask()
;             scheduled := true
;         }
;     }
; } Else
; {
;     scheduled := true
; }
FileEncoding, UTF-8

If !dev
    RunWait, cmd /c choco outdated > %A_Temp%\chocoupd.log -Force,, Hide

; Draw the Gui
Gui, Add, ListView, x10 y80 w480 h350 Checked NoSortHdr ReadOnly 0x2000, Nom|Local|Distant
Gui, Add, Picture, x15 y15 w50 h50, res\icon.ico
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
                LV_Add("Check", v1, v2, v3)
                n++
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
    LV_Add("Check", "test", "1", "2")
    LV_Add("Check", "test", "3", "5")
}

LV_ModifyCol(1, 150)
LV_ModifyCol(2, 150)

Gui, Show, w500 h475 Minimize, chocoupd

; Setup configuration GUI
Gui, 2:Font, s10 bold
Gui, 2:Add, Text, xm ym+10, Configuration
Gui, 2:Font
LANGUAGE := tr("LANGUAGE")
Gui, 2:Add, Text, xm yp+40, %LANGUAGE%
Gui, 2:Add, DropDownList, xm+80 yp-5 w150 vLang, English|French|German|Italian|Spanish
dropLang =
(
1 = English = en
2 = French = fr
3 = German = de
4 = Italian = it
5 = Spanish = es
)
AUTO_CHECK_FOR_UPDATES := tr("AUTO_CHECK_FOR_UPDATES")
Gui, 2:Add, Checkbox, xm yp+40 vScheduleTasks gchkScheduleTasks, %AUTO_CHECK_FOR_UPDATES%
;FREQ_EACH_DAY := tr("FREQ_EACH_DAY")
;FREQ_EACH_WEEK := tr("FREQ_EACH_WEEK")
;FREQ_EACH_MONTH := tr("FREQ_EACH_MONTH")
;FREQUENCY := tr("FREQUENCY")
;Gui, 2:Add, Text, xm yp+40 vTxtFrequency, %FREQUENCY%
;Gui, 2:Add, DropDownList, xm+80 yp-5 w90 vFrequence, %FREQ_EACH_DAY%||%FREQ_EACH_WEEK%|%FREQ_EACH_MONTH%
HOUR := tr("HOUR")
Gui, 2:Add, Text, xm yp+40 vTxtHour, %HOUR%
Gui, 2:Add, DropDownList, xm+60 yp-5 w50 vHour, 00|01|02|03|04|05|06|07|08||09|10|12|13|14|15|16|17|18|19|20|21|22|23
Gui, 2:Add, DropDownList, xm+120 yp w50 vMinute, 00||15|30|45
BT_CANCEL := tr("BT_CANCEL")
Gui, 2:Add, Button, xm+30 yp+40 w100 gConfigCancel, %BT_CANCEL%
BT_SAVE := tr("BT_SAVE")
Gui, 2:Add, Button, xp+130 yp w100 gConfigSave, %BT_SAVE%
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
return

Configuration:
{
    ; Set in-use language
    langUsedIndex = ([\d])*\s=\s([\w]*)\s=\s(%l%)
    RegExMatch(dropLang, langUsedIndex, idx)
    GuiControl, 2:ChooseString, Lang, %idx2%  

    ; Check the schedule box if the task already exists
    If (scheduled = true)
    {
        GuiControl, 2:, ScheduleTasks, 1
        schTemp := true
    } Else
    {
        GuiControl, 2:, ScheduleTasks, 0
    }
    time := getScheduledTime()
    RegExMatch(time, "(\d{2}):(\d{2}):\d{2}", subtime)
    If subtime1
    {
        GuiControl, 2:ChooseString, Hour, %subtime1%
        GuiControl, 2:ChooseString, Minute, %subtime2%
    }

    Gui, 2:Show, , chocoupd

    ; Configure the scheduled hour
    Gosub, chkScheduleTasks
}
return

chkScheduleTasks:
{
    GuiControlGet, ScheduleTasks
    If (ScheduleTasks = 1 or schTemp = true)
    {
        GuiControl, 2:Enable, TxtFrequency
        GuiControl, 2:Enable, Frequence
        GuiControl, 2:Enable, TxtHour
        GuiControl, 2:Enable, Hour
        GuiControl, 2:Enable, Minute
        schTemp := false 
    } Else
    {
        GuiControl, 2:Disable, TxtFrequency
        GuiControl, 2:Disable, Frequence
        GuiControl, 2:Disable, TxtHour
        GuiControl, 2:Disable, Hour
        GuiControl, 2:Disable, Minute
    }        
}
return

ConfigCancel:
{
    Gui, 2:Hide
}
return

ConfigSave:
{
    Gui, 2:Hide

    ; Save the language and reload interface
    GuiControlGet, Lang
    langUsedIndex = ([\d])*\s=\s(%Lang%)\s=\s(\w{2})
    RegExMatch(dropLang, langUsedIndex, idx)
    If (l <> idx3)
    {
        IniWrite, %idx3%, %localDir%\chocoupd\settings.ini, Settings, lang
        l = %idx3%
        LANG_RELOAD := tr("LANG_RELOAD")
        MsgBox, , chocoupd, %LANG_RELOAD% %l% %idx3%
    }

    ; Check if the time has changed
    GuiControlGet, ScheduleTasks
    GuiControlGet, Hour
    GuiControlGet, Minute
    timeChanged =
    If ScheduleTasks = 1
    {       
        time := getScheduledTime()
        RegExMatch(time, "(\d{2}):(\d{2}):\d{2}", subtime)
        If (Hour <> subtime1) | (Minute <> subtime2)
        {
            timeChanged = 1
        }
    }    
    
    ; Change task settings
    If (ScheduleTasks = 0)
    {
        removeTask()
        scheduled := false
    }
    If ((ScheduleTasks = 1) && (scheduled = false))
    {
        setDailyTask(Hour, Minute)
        scheduled := true
    }
    If (timeChanged = 1) {
        changeScheduledTime(Hour, Minute)
    }
}
return

GuiClose:
exitapp