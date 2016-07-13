Menu, Tray, Tip, Compilation

compiler = C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe
fahk = chocoupd.ahk

; Get version
FileRead, ahk, %fahk%
RegExMatch(ahk, "version = (.*)", v)

; Compilation
RunWait, "%compiler%" /in %fahk% /out "bin\chocoupd_x32.exe" /icon res\icon.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 32-bit.bin" /mpress 1
RunWait, "%compiler%" /in %fahk% /out "bin\chocoupd.exe" /icon res\icon.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 64-bit.bin" /mpress 1,,Hide

; Copy language
FileCopy, %A_ScriptDir%\lang\*.json, %A_ScriptDir%\bin\lang\
FileCopy, %A_ScriptDir%\res\icon.ico, %A_ScriptDir%\bin\

; Ajout des informations de version
;RunWait, tools\gorc\GoRC.exe /fo bin/resources.res version.rc,,Hide
;SetWorkingDir, %A_ScriptDir%\bin
;res = %A_ScriptDir%\tools\reshacker\ResourceHacker.exe -add analyse_ssp.exe, analyse_ssp.exe, resources.res,,,
;RunWait, %res%,,Hide
;FileDelete, resources.res

; Notification utilisateur
TrayTip, Compilation, Compilation du programme terminée, 5, 1

ExitApp