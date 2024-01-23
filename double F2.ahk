; pressing F2 twice in a row copies the file name and alt + tabs
; This enables you to easily copy the file name of the selected file in Windows Explorer

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; pressing F2 twice in a row copies the file name and alt+tabs
~F2::
	KeyWait, F2
	if (KeyWait("F2", "D T0.2")) {
		KeyWait, F2
		Send ^c
		Send {Esc}
		Send !{Tab}
	}
return

KeyWait(key, options) {
	KeyWait, %key%, %options%
	Return, Not ErrorLevel
}