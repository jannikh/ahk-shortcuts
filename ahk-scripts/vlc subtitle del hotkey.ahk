; This AutoHotkey script enhances the functionality of the Del key in VLC media player. It requires the VLSub addon and provides three hotkeys:
; Hotkeys (only when VLC media player is the active window):
; 	Del: Automatically adds English subtitles. It pauses the video, opens the VLSub window, selects the 'Search by name' option, waits for the subtitle list to load, selects a subtitle, and resumes the video.
; 		pressing Del again lets you select the subtitle file (this behavior might already be deprecated and replaced by Shift + Del)
; 	Ctrl + Del: Similar to Del, but selects the 'Search by hash' option in VLSub.
; 	Shift + Del: Pauses the video, opens the VLSub window, selects the 'Search by name' option, and waits for the user to manually select a subtitle.
; (It uses the KeyWait function to wait for the Del key to be released before executing the hotkey actions.)

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; pressing Del in VLC automatically adds English subtitles. Needs VLSub addon
; pressing Del again lets you select the subtitle file
SetTitleMatchMode, 2
#IfWinActive, VLC media player
	~Del::
		KeyWait, Del
		Send {Space}
		Send f
		Sleep, 50
		Send !i
		Sleep, 100
		Send {Up}
		Sleep, 50
		Send {Enter}
		Sleep, 100
		Send {Tab}
		Send {Tab}
		Send {Tab}
		Send {Enter}
		Sleep, 5000
		Send {Tab}
		Send {Tab}
		Send {Tab}
		Send {Space}
		Sleep, 100
		Send {Tab}
		Send {Tab}
		Send {Tab}
		Send {Enter}
		Sleep, 100
		Send {Esc}
		Send f
		Send {Space}
	return

	~^Del::
		KeyWait, Del
		Send {Space}
		Send f
		Sleep, 50
		Send !i
		Sleep, 100
		Send {Up}
		Sleep, 50
		Send {Enter}
		Sleep, 100
		Send Sp
		Send {Tab}
		Send {Tab}
		Send {Tab}
		Send {Enter}
		Sleep, 5000
		Send {Tab}
		Send {Tab}
		Send {Tab}
		Send {Space}
		Sleep, 100
		Send {Tab}
		Send {Tab}
		Send {Tab}
		Send {Enter}
		Sleep, 100
		Send {Esc}
		Send f
		Send {Space}
	return

	~+Del::
		KeyWait, Del
		Send {Space}
		Send f
		Sleep, 50
		Send !i
		Sleep, 100
		Send {Up}
		Sleep, 50
		Send {Enter}
		Sleep, 100
		Send {Tab}
		Send {Tab}
		Send {Tab}
		Send {Enter}
	return
#IfWinActive

KeyWait(key, options) {
	KeyWait, %key%, %options%
	Return, Not ErrorLevel
}