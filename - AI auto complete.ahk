; This autohotkey script is used to auto-complete or interpret given text using GPT-3.5 or GPT-4
; Hotkey: Ctrl + Win + Y
; Available modifiers:
;   - Shift: Use GPT-4 instead of GPT-3.5
;   - Alt: Interpret the text instead of auto-completing it
; The script always tries to copy the currently selected text or the active line that is being typed upon

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force ; Replace old instance if script is run again

; Alt: Interpret
; Shift: GPT-4
^#y:: ; Ctrl+Win+Y
+^#y:: ; Ctrl+Win+Shift+Y
!^#y:: ; Alt+Ctrl+Win+Y
!+^#y:: ; Alt+Ctrl+Win+Shift+Y
    ; Shift: GPT-4 instead of 3.5-turbo
    ; Alt: Interpret instead of auto-complete

	; Check if the Shift key is pressed
	if GetKeyState("Shift", "P")
	{
		shiftFlag := True ; Set the flag indicating Shift was pressed
		Send, {LShift up} ; Release the Shift key
	}
	else
	{
		shiftFlag := False ; Reset the flag
	}

	; Check if the Alt key is pressed
	if GetKeyState("Alt", "P")
	{
		altFlag := True ; Set the flag indicating Alt was pressed
		Send, {LAlt up} ; Release the Alt key
	}
	else
	{
		altFlag := False ; Reset the flag
	}

    ; Wait for all modifier keys to be released
    ; KeyWait Ctrl
    ; KeyWait Win
	Send {LWin up}
	Send {LCtrl up}

    ; Clear the clipboard
    clipboard := ""

    ; Press Ctrl+C
    Send, ^c
    ClipWait, 0.5 ; Wait for clipboard to contain data (0.5 seconds timeout)

    self_select := False
    ; Check if clipboard is still empty
    if (clipboard = "") {
        self_select := True
        ; Press Shift+Home then Ctrl+C
        Send, +{Home}
        Sleep, 50 ; Wait a tiny bit
        Send, ^c
        ClipWait, 0.5 ; Wait for clipboard to contain data
    }

	; Check the active window's application
	WinGet, activeProcess, ProcessName, A

	; Check if the active application is VSCode or VSCodium
	if (activeProcess = "Code.exe" or activeProcess = "VSCodium.exe") {
		
		; Check if clipboard ends with a linebreak
		if (InStr(Clipboard, "`n", 0) = StrLen(Clipboard)) {
			Send, +{Home}
			Send, +{Home}
    		self_select := True
			Send, ^c
		}
	}

    ; If self-select: press Right, Send "..."
    if (self_select) {
        Send, {Right}
        Sleep, 50
        Send, ...
        Sleep, 50
    }

    ; Replace %CLIPBOARD% in the command with the actual clipboard content
    cmdCommand := "py .\auto-completion.py """ clipboard """ --force --copy"
	if shiftFlag {
		cmdCommand := cmdCommand . " --gpt4"
	}

    cmdCommand := StrReplace(cmdCommand, "`r`n", "\n")
	cmdCommand := StrReplace(cmdCommand, "`n", "\n")

    ; Set a timer for the command
    ; SetTimer, CommandTimeout, -2000 ; 2 seconds timeout
	if altFlag {
        ; For debugging:
		; Run, cmd.exe /k %cmdCommand%

        cmdCommand := cmdCommand . " --interpret"
	}
    RunWait, %cmdCommand%, , Hide
    ; SetTimer, CommandTimeout, Off ; Turn off the timer

    ; If the timeout was hit, the following label would have set the variable
    if (timeout_hit) {
        ; if (self_select) {
        ;     Send, {Right}
        ; }
        return
    }

    ; If self-select: press 3x backspace, Shift+Home
    if (self_select) {
        ; Send, {Backspace 3}
        Sleep, 50
        Send, +{Home}
		if (activeProcess = "Code.exe" or activeProcess = "VSCodium.exe") {
	        ; Send, +{Home}
		}
    }

    ; Press Ctrl+V
    Sleep, 50
    Send, ^v
return

CommandTimeout:
    ; This label is hit if the command takes more than 2 seconds
    timeout_hit := True
return
