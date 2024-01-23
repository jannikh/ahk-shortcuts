; This AutoHotkey script automatically shows and hides the taskbar tray based on the mouse position.
; It checks the mouse position every 100ms. When the mouse moves to a specific "show" area on the screen (defined by xshow and taskbarHeight) in the bottom right corner of the main screen, it simulates a click to show the taskbar and then returns the mouse to its original position.
; When the mouse moves out of a specific "hide" area (defined by xhide and yhide), and if autohide is enabled, it simulates a click to hide the taskbar and then returns the mouse to its original position.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force ; Replace old instance if script is run again

#Persistent  ; Keeps the script running
SetTimer, CheckMousePosition, 100  ; Checks the mouse position every 100ms
CoordMode, Mouse, Screen  ; Sets mouse coordinate mode to be relative to the screen

; Initialize variables with default values
xclick := 360
xshow := xclick + 100
xhide := xshow + 40
taskbarHeight := 40
yhide := taskbarHeight + 4 * 46
autohide := false
isinarea := false

; Function to check the mouse's position
CheckMousePosition:
    ; Get the current mouse position
    MouseGetPos, mouseX, mouseY
    
    ; Get the main monitor dimensions
    SysGet, MonitorWorkArea, MonitorWorkArea
    monitorWidth := MonitorWorkAreaRight
    monitorHeight := MonitorWorkAreaBottom + taskbarHeight
    
    ; Check if the mouse is in the "show" area and not already in the area
    ; if ((mouseX >= MonitorWorkAreaLeft && mouseX <= MonitorWorkAreaRight && mouseY >= MonitorWorkAreaTop && mouseY <= MonitorWorkAreaBottom) and !isinarea and mouseX > (monitorWidth - xshow) and mouseY > (monitorHeight - taskbarHeight))
	if (!isinarea and mouseX > (monitorWidth - xshow) and mouseY > (monitorHeight - taskbarHeight))
    {
        ; Store the current mouse position
        origX := mouseX, origY := mouseY
        
        ; Perform the click
        ; Click % (monitorWidth - xclick + 10) "," (monitorHeight - taskbarHeight // 2)
        ; Better for instant movement:
        MouseMove % (monitorWidth - xclick + 10), % (monitorHeight - taskbarHeight // 2), 0
        Click
        
        ; Return to stored mouse position
        MouseMove, %origX%, %origY%, 0

        ; The following does not work for the taskbar:
        ; ; Get the active window's position
        ; WinGetPos, winX, winY,,, A
        ; ; Calculate window-relative coordinates
        ; x := monitorWidth - xclick + 10 - winX
        ; y := monitorHeight - taskbarHeight // 2 - winY
        ; ; Perform the click
        ; ControlClick, x%x% y%y%, A
        
        ; Set isinarea to true
        isinarea := true
    }
    
    ; Check if the mouse is in the "hide" area and already in the area
    if (isinarea and mouseX < (monitorWidth - xhide) and mouseY < (monitorHeight - yhide))
    {
        ; Set isinarea to false
        isinarea := false
        
        ; If autohide is enabled
        if (autohide)
        {
            ; Store the current mouse position
            origX := mouseX, origY := mouseY
            
            ; Perform the click
            Click % (monitorWidth - xclick + 10) "," (monitorHeight - taskbarHeight // 2)
            
            ; Return to stored mouse position
            MouseMove, %origX%, %origY%
        }
    }
return
