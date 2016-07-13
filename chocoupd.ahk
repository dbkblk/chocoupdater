#Include <JSON>
#Include <translations>

version = 0.2

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
text := tr("CHECKING")
Menu, Tray, Tip, chocoupd %text%

; Check for Chocolatey
IfNotExist, C:\ProgramData\chocolatey\choco.exe
{
    text := tr("INSTALL_CHOCOLATEY")
    MsgBox, 4, chocoupd, %text%
    IfMsgBox Yes
    {
        ;text := tr["INSTALL_UPDATES"]
        ;MsgBox % text
        ;Run *RunAs %comspec% /c @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin && timeout 5
    } else
    {
        text := tr("INSTALL_CHOCOLATEY_NEEDED")
        MsgBox % text
        ExitApp, 0
    }        
}
    

RunWait, cmd /c choco outdated > %A_Temp%\chocoupd.log -Force,, Hide

; Draw the Gui
Gui, Add, ListView, x10 y80 w480 h350 Checked NoSortHdr ReadOnly -LV0x10, Nom|Local|Distant
Gui, Add, Picture, x15 y15 w50 h50, icon.ico
text := tr("INSTALL_UPDATES")
Gui, Add, Button, x340 y440 w150 h25 gInstall, %text%
Gui, Font, s10
text := tr("UPDATE_AVAILABLE")
Gui, Add, Text, x75 y20, %text%
text := tr("SELECT_FILES")
Gui, Add, Text, x75 y45, %text%
Gui, Add, Text, x10 y445, v%version%
Gui, Font, Default

; Get a list of programs to update
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
        ;MsgBox, Nom : %v1%`nVersion locale : %v2%`nVersion distante : %v3%
    }        
}
FileDelete, %A_Temp%\chocoupd.log

If (n = 0)
{
    ExitApp, 0
}

Gui, Show, w500 h475, chocoupd
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

GuiClose:
exitapp