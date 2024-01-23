; This AutoHotkey script provides several productivity shortcuts (all browser interactions are using Firefox):
; 
; Win + Y or Win + < opens a new firefox tab, with adress bar selected.
; if alt is pressed, the current clipboard is pasted in the new tab and confirmed with enter (also catches Win+Alt+X for ergonomics)
; if held for more than 500ms (or 1000ms with alt modifier), instead of opening a tab it will preview firefox and then alt+tab back after release
; 
; Enhanced Ctrl + C functionality:
; Double pressing Ctrl+C checks the clipboard content:
; 	If it starts with "http" or "www.", it opens the link in the default browser.
; 	If it contains ".com" or ".de" without spaces, it prepends "https://" and opens the link.
; 	If it's a local file path, it opens the path in the file explorer.
; 	Otherwise, it performs a Google search with the clipboard content.
; Triple pressing Ctrl+C triggers a DuckDuckGo "I'm feeling lucky" search with the clipboard content.
; 
; Ctrl + Alt + Shift + C: Performs an Alt + Tab and paste operation.
; 
; F1 in Notion, means Ctrl + P (aligned behavior with VS Code)
; 
; Pressing Ctrl + L twice in quick succesion in firefox, copies the URL then Alt + Tabs and pastes it


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force ; Replace old instance if script is run again


; #IfWinActive ahk_class MozillaWindowClass
;         Pause::
;                 Send ^{F4}
;         Return
;         NumpadAdd::
;                 Send {PgDn}
;         Return
;         NumpadSub::
;                 Send {PgUp}
;         Return
; #IfWinActive

; Win + Y or Win + < opens a new firefox tab, with adress bar selected.
; if alt is pressed, the current clipboard is pasted in the new tab and confirmed with enter (also catches Win+Alt+X for ergonomics)
; if held for more than 500ms (or 1000ms with alt modifier), instead of opening a tab it will preview firefox and then alt+tab back after release
#<::
#y::
#!y::
#!x::
	; Detect if alt was pressed:
	if (GetKeyState("Alt", "P")) {
		altPressed := 1
		Send {LAlt up}
		Send {Alt up}
	} else {
		altPressed := 0
	}
	Send {LWin up}
	Send {Win up}
	Sleep, 50
	IfWinActive, ahk_class MozillaWindowClass
	{
		if (altPressed) {
			Send ^l
            Sleep, 200
			Send ^v
            Sleep, 50
			Send !{Enter}
		} else {
			Send ^t^l
		}
	}
	else
	{
		WinActivate, ahk_class MozillaWindowClass
		;Send #2
		WinWaitActive, ahk_class MozillaWindowClass, , 2
		Send {LWin up}
		Send {Win up}
		Sleep, 10

		;if not ErrorLevel
		if (altPressed) {
			; Fot alt modifier, always open a new tab and paste the link
			Send ^l
			Sleep, 200
			Send ^v
			Sleep, 50
			Send !{Enter}
		}

		KeyWait LWin
		elapsedtime := A_TickCount - _starttime
		if (altPressed) {
			if (A_TimeSinceThisHotkey > 1000) {
				Send !{Tab}
			}
		} else {
			if (A_TimeSinceThisHotkey > 500) {
				Send !{Tab}
			}
			else {
				Send ^t^l
			}
		}
	}
Return

; pressing ctrl + c twice in a row starts a google search with the clipboard
~^c::
	KeyWait, c
	if (KeyWait("c", "D T0.2")) {
		KeyWait, c
		; Triple Ctrl+C:
		if (KeyWait("c", "D T0.2")) {
			; I'm feeling lucky via duckduckgo
			percent := "%"
			Run, https://duckduckgo.com/?q=%Clipboard%%percent%20!ducky&ia=web

			;; Get Lucky via Google doesn't work without manual redirect :(
			; Run, http://www.google.com/search?ie=UTF-8&oe=UTF-8&sourceid=navclient&gfns=1&q=%Clipboard%
		
		} else {
			; Automatically open links directly in the default browser:
			; Checks if the clipboard starts with "http" or "www." or contains ".com" or ".de" wihout containing a space
			if (SubStr(Clipboard, 1, 4) = "http" or SubStr(Clipboard, 1, 4) = "www.") {
				Run, %Clipboard%
			} else if ((InStr(Clipboard, ".com") or InStr(Clipboard, ".de")) and !InStr(Clipboard, " ")) {
				Clipboard = https://%Clipboard%
				Run, %Clipboard%
			
			; Automatically open file paths on local explorer
			;; Only for C drive:
			; } else if (SubStr(Clipboard, 1, 4) = "C:\\" or SubStr(Clipboard, 1, 4) = "C://") {
			; 	Clipboard := StrReplace(StrReplace(Clipboard, "//", "\"), "\\", "\")
			; 	Run, explorer %Clipboard%
			; } else if (SubStr(Clipboard, 1, 3) = "C:\" or SubStr(Clipboard, 1, 3) = "C:/") {
			; 	Run, explorer %Clipboard%

			; For all drives:
			} else if (SubStr(Clipboard, 2, 3) = ":\\" or SubStr(Clipboard, 2, 3) = "://") {
				Clipboard := StrReplace(StrReplace(Clipboard, "//", "\"), "\\", "\")
				Run, explorer %Clipboard%
			} else if (SubStr(Clipboard, 2, 2) = ":\" or SubStr(Clipboard, 2, 2) = ":/") {
				Run, explorer %Clipboard%

			; Default: Open google search on default browser
			} else {
				Run, https://www.google.com/search?q=%Clipboard%
			}
		}
		; KeyWait, c
		; WinActivate, ahk_class MozillaWindowClass
		winwait ahk_class MozillaWindowClass
		WinActivate, ahk_exe firefox.exe
	}
return

KeyWait(key, options) {
	KeyWait, %key%, %options%
	Return, Not ErrorLevel
}



; ; Deactivating Win+Space command to change input mode
; #Space::
; return

; Alt+Tab and paste after Ctrl+Alt+Shift+C
^!+c:: ; When Ctrl+Alt+Shift+C is pressed
    KeyWait, Ctrl ; Wait for Ctrl key to be released
    KeyWait, Alt ; Wait for Alt key to be released
    KeyWait, Shift ; Wait for Shift key to be released
    Send, ^c ; Simulate Ctrl+C
    Sleep, 100 ; A short delay to ensure the Alt+Tab action is complete
    Send, !{Tab} ; Simulate Alt+Tab
    Sleep, 100 ; A short delay to ensure the Alt+Tab action is complete
    Send, ^v ; Simulate Ctrl+V
return

; pressing F1 in Notion sends Ctrl+P
~F1::
    IfWinActive, ahk_exe Notion.exe ; Check if Notion is the active window
    {
		Send, {F1 up} ; Release the Alt key
        Send, ^p ; Send Ctrl+P
    }
return

SetTitleMatchMode, 2 ; Allows for partial matching of window titles
lastPressTime := 0
; Ctrl+L twice in Firefox copies the URL, alt+tabs and pastes it
~^l:: ; ~Ctrl+L
	; Check if Firefox is the active window
	IfWinActive, ahk_exe firefox.exe
    {
        ; Get the current time
        currentTime := A_TickCount
        
        ; Check if the last press was within 200ms
        if (currentTime - lastPressTime < 200)
		{
			Send {Ctrl up}
			Send {L up}
            ; Perform the desired actions
            Sleep, 100
            Send, ^c ; Ctrl+C
            Sleep, 100
            Send, !{Tab} ; Alt+Tab
            Sleep, 400
            Send, ^v ; Ctrl+V
        }
        
        ; Update the last press time
        lastPressTime := currentTime
    }
return


; ; DEACTIVATED, SINCE MATCHING "SETTINGS" MIGHT RESULT IN FALSE POSITIVES
; ; Pressing Esc twice in Windows Settings results in Alt+F4
; #IfWinActive, Settings
; #IfWinActive ahk_exe SystemSettings.exe
; ~esc::
;     If (A_PriorHotKey = "esc" AND A_TimeSincePriorHotkey < 100)
;         Send, !{F4}
; return
; #IfWinActive
