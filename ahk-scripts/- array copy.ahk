; This AutoHotkey script allows you to copy or cut multiple lines of text and paste them individually.
; It uses an array to store the copied lines and a flag to indicate the array copy mode.
; If the copied text contains line breaks, it splits the text by line breaks and stores the lines in the array.
; The script then enables the array copy mode and allows you to paste the lines one by one.
; If the last element is reached, it disables the array copy mode and displays a warning, prompting you to paste the last element.
; Hotkeys:
; Ctrl + Win + Alt + Shift + C: Captures multiple lines into a persistent clipboard array and enables copy-array-mode.
; Ctrl + Win + Alt + Shift + X: Cuts and captures multiple lines into a persistent clipboard array and enables copy-array-mode.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force ; Replace old instance if script is run again

; Initialize persistent clipboard array variable
clipboardArray := []
; Initialize copy-array-mode flag
copyArrayMode := false

; Ctrl+Win+Alt+Shift+C hotkey
; Captures multiple lines into a persistent clipboard array and enables copy-array-mode.
^#!+c::
    ; Release all keys
    Send, {Ctrl up}{Win up}{Alt up}{Shift up}{c up}
    
    ; Press Ctrl+C
    Send, ^c
    Sleep, 100 ; Wait for the clipboard to be populated
    
    PrepareArrayCopy()
return

; Ctrl+Win+Alt+Shift+X hotkey
; Captures multiple lines into a persistent clipboard array and enables copy-array-mode.
^#!+x::
    ; Release all keys
    Send, {Ctrl up}{Win up}{Alt up}{Shift up}{x up}
    
    ; Press Ctrl+X
    Send, ^x
    Sleep, 100 ; Wait for the clipboard to be populated
    
    PrepareArrayCopy()
return

PrepareArrayCopy() {
    global clipboardArray, copyArrayMode

    ; Check if clipboard contains line breaks
    if !InStr(clipboard, "`n") && !InStr(clipboard, "`r")
    {
        copyArrayMode := false
        TrayTip, Array Copy Mode, ⚠ No line breaks found in the copied string. Disabling Array Copy Mode, , 16
        ; MsgBox, No line break found. Aborting.
        return
    }
    
    ; Split the clipboard content by line breaks
    clipboardArray := StrSplit(clipboard, "`n")
    
    ; Copy the first element into the clipboard and remove it from the array
    clipboard := clipboardArray[1]
    clipboardArray.RemoveAt(1)
    
    ; Remove trailing line breaks from the clipboard
    clipboard := RegExReplace(clipboard, "\r?\n?$", "")
    
    ; Enable copy-array-mode
    copyArrayMode := true
    TrayTip, Array Copy Mode, 📄 Enabling Array Copy Mode, , 16
}

; Ctrl+V hotkey
; Pastes the next string from the persistent clipboard array if copy-array-mode is enabled.
~^v::
    ; Check if copy-array-mode is enabled
    if (copyArrayMode)
    {
		Sleep, 100 ; Wait for the clipboard to be pasted

		; Copy the next string from the array into the clipboard
        clipboard := clipboardArray[1]
        clipboardArray.RemoveAt(1)
        
        ; Remove trailing line breaks from the clipboard
        clipboard := RegExReplace(clipboard, "\r?\n?$", "")
    
        ; If the array is now empty, disable copy-array-mode
        if (clipboardArray.MaxIndex() < 1)
        {
			copyArrayMode := false
			TrayTip, Array Copy Mode, Disabling Array Copy Mode. You can now paste the last element, , 16
        }
    }
return
