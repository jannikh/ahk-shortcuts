; This AutoHotkey script enhances the clipboard functionality by appending newly copied content to the existing clipboard content, instead of replacing it.
; Hotkey: Ctrl + Alt + C
; The script checks if the current clipboard content ends with a newline, and if not, it adds one before appending the new content.
; This is useful for accumulating multiple copied texts into one clipboard for a combined paste operation.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force ; Replace old instance if script is run again

^!c:: ; Ctrl + Alt + C hotkey
    ; Store current clipboard content
    PrevClipboard := Clipboard

    Clipboard=
    ; Simulate pressing Ctrl + C
    Send, ^c

    ; Wait for clipboard to contain data (with a 1 second timeout)
    ; Sleep, 100
    ClipWait, 1

    ; Check if PrevClipboard ends with a newline (either Windows or Linux style)
    if (SubStr(PrevClipboard, 0) = "`r" or SubStr(PrevClipboard, 0) = "`n")
        Clipboard := PrevClipboard . Clipboard
    else
        Clipboard := PrevClipboard . "`n" . Clipboard

    ; MsgBox, %PrevClipboard%`n`n`n%Clipboard%
return
