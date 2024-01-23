; Pressing Windows key + B will focus the system tray and open it automatically.
; Pressing it again will focus and open the first icon in the system tray.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force ; Replace old instance if script is run again

~#b:: ; Win+B
    Send, {Space}
return
