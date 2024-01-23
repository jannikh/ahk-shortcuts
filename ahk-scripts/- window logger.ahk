; Script Summary /  What It Does:
; Window Logging: This AutoHotkey script logs the active window title along with the application process name.
; Time Stamping: It records the start and end timestamps for each active window.
; Duration Calculation: The script calculates the duration for which each window is active and appends it to the log.
; Idle State Detection: The script detects if the computer is idle for more than one minute and appends "\t(IDLE)" to the window title.
; Logging Breaks: If the active window remains the same but exceeds a certain time interval, it logs a break in the form of empty lines.
; Title Processing: The script processes the window title to handle specific cases. For instance, if the window title contains "Mozilla Firefox Private Browsing", it is replaced with the exact string "Mozilla Firefox Private Browsing".
; VLC Logging: If the active window is VLC media player and it remains active for more than 10 seconds, the script logs this activity to a separate file named ..\logs\vlclogfile.txt.
; Default Values: In cases where the window title or process name is empty, the script defaults these values to "Windows" and "System" respectively. This ensures that all activities are logged, even if the window title or process name cannot be retrieved.
; 
; Settings:
; checkInterval: The interval at which the script checks the active window. It is set to 1 second
; currentWindowTitle, currentStartTimestamp, currentEndTimestamp, currentStartTickCount: Variables that store the current window's information and the tick count when the window became active.
; idleTime: Keeps track of the idle time based on user input (mouse/keyboard). If the idle time exceeds 1 minute, the script considers the state as idle.
; 
; Log Format:
; The log entries are saved in a text file with the following format:
; [Start Timestamp] - [End Timestamp]    [Duration]    [Window Title] ([Process Name])
; Special Cases:
; If the computer is idle, "\t(IDLE)" is appended to the window title.
; Five empty lines are appended to indicate a break in logging activities when the check interval is significantly exceeded.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent ; Keep the script running
#SingleInstance, Force ; Replace old instance if script is run again

checkInterval := 1000 ; Check every 1 second (in milliseconds)
SetTimer, LogActiveWindow, %checkInterval%

; Initialize variables
currentWindowTitle := ""
currentProcessName := ""
currentStartTimestamp := CurrentTime
currentEndTimestamp := CurrentTime
currentStartTickCount := A_TickCount
lastInvocationTickCount := 0

FileAppend, `n`n`n`n`nReinitialized autohotkey script, ..\logs\windowlogfile.txt

return

LogActiveWindow:
    ; Update timeSinceLastCheck based on last function call
    timeSinceLastCheck := (lastInvocationTickCount = 0) ? 0 : (A_TickCount - lastInvocationTickCount)
    lastInvocationTickCount := A_TickCount

    ; Check for idle time (in milliseconds)
    idleTime := A_TimeIdlePhysical

    ; Get the active window title and process
    WinGetActiveTitle, OriginalTitle
    Title := GetProcessedTitle(OriginalTitle)
    WinGet, ProcessName, ProcessName, A
    ProcessName := StrReplace(ProcessName, ".exe", "") ; Remove .exe from the process name
    
    idleInfo := ""

    ; Append " (IDLE)" if idle for more than 1 minute
    if (idleTime > 60000) {
        idleInfo := Chr(9) "(IDLE)"
    }

    ; Format datetime in German format (dd.mm.yyyy hh:mm:ss)
    FormatTime, CurrentTime,, dd.MM.yyyy HH:mm:ss

    ; Check if the title has changed or if the interval has passed
    if (Title != currentWindowTitle) or (timeSinceLastCheck > (checkInterval + 1000)) {
        ; Log the previous window details if available
        ; if (currentWindowTitle != "") {
            ; Calculate duration in milliseconds
            duration := A_TickCount - currentStartTickCount
            
            ; Convert milliseconds to seconds, minutes, and hours
            seconds := floor(duration // 1000)
            minutes := floor(seconds // 60)
            hours := floor(minutes // 60)

            ; Format the duration string
            durationString := ""
            if (hours > 0) {
                durationString := Format("{1:1}:{2:02}:{3:02}", hours, minutes - (hours * 60), seconds - (minutes * 60))
            } else if (minutes > 0) {
                durationString := Format("   {1:1}:{2:02}", minutes, seconds - (minutes * 60))
            } else if (seconds >= 10) {
                durationString := Format("    :{1:02}", seconds)
            } else if (seconds > 0) {
                durationString := Format("      {1:1}", seconds)
            } else {
                durationString := "      0"
            }
            
            if (currentWindowTitle == "" AND currentProcessName == "Explorer") {
                currentWindowTitle = Windows
            }
            if (currentWindowTitle == "" AND currentProcessName == "") {
                currentWindowTitle = Windows
                currentProcessName = System
            }

            FileAppend, %currentStartTimestamp% - %currentEndTimestamp%	%durationString%	%currentWindowTitle% (%currentProcessName%)%idleInfo%`n, ..\logs\windowlogfile.txt

            if (currentProcessName == "vlc" AND InStr(currentWindowTitle, " - VLC media player") AND seconds > 10) {
                FileAppend, %currentStartTimestamp% - %currentEndTimestamp%	%durationString%	%currentWindowTitle% (%currentProcessName%)%idleInfo%`n, ..\logs\vlclogfile.txt
            }

            ; Log five empty lines if the interval has passed for the same title
            if (timeSinceLastCheck > (checkInterval + 1000)) {
                FileAppend, `n`n`n`n`n, ..\logs\windowlogfile.txt
            }
        ; }
        
        ; Update variables with new window title and timestamp
        currentWindowTitle := Title
        currentProcessName := ProcessName
        currentStartTimestamp := CurrentTime
        currentStartTickCount := A_TickCount
    }
    
    ; Format datetime in German format (dd.mm.yyyy hh:mm:ss)
    FormatTime, CurrentTime,, HH:mm:ss

    ; Update the end-timestamp
    currentEndTimestamp := CurrentTime
    
return

GetProcessedTitle(title) {
    if (InStr(title, "Mozilla Firefox Private Browsing")) {
        return "Mozilla Firefox Private Browsing"
    }
    return title
}
