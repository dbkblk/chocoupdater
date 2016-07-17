Menu, Tray, Tip, Compilation

compiler = C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe
fahk = chocoupd.ahk

Loop %0%
{
    param := %A_Index%
    If param = -l
    {
        launch = 1
    }
}

; Get version
FileRead, ahk, %fahk%
RegExMatch(ahk, "version = (.*)", v)

; Compilation
If launch <> 1
    RunWait, "%compiler%" /in %fahk% /out "bin\chocoupd_x32.exe" /icon res\icon.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 32-bit.bin" /mpress 1,,Hide

RunWait, "%compiler%" /in %fahk% /out "bin\chocoupd.exe" /icon res\icon.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 64-bit.bin" /mpress 1,,Hide

; Copy language
RunWait, .tx\tx.exe pull -a,,Hide
FileDelete, %A_ScriptDir%\bin\lang\*.json
FileDelete, %A_ScriptDir%\bin\task.xml
FileCopy, %A_ScriptDir%\lang\*.json, %A_ScriptDir%\bin\lang\
FileCopy, %A_ScriptDir%\res\icon.ico, %A_ScriptDir%\bin\res\icon.ico
FileCopy, %A_ScriptDir%\res\task.xml, %A_ScriptDir%\bin\res\task.xml

SetWorkingDir, %A_ScriptDir%\bin
; Launch the program or prepare for release
If launch = 1
{
    Run, chocoupd
} Else
{
    RunWait, 7za a -tzip -r chocoupd_v%v1%.zip *.*,,Hide
    SetWorkingDir, %A_ScriptDir%
    FileMove, %A_ScriptDir%\bin\chocoupd_v%v1%.zip, %A_ScriptDir%\archives\chocoupd_v%v1%.zip, 1
}

; Notification
TrayTip, Compilation, Compilation du programme terminée, 5, 1

ExitApp