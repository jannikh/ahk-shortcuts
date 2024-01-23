# AutoHotkey Scripts

This repository contains my everyday autohotkey shortcuts to make life easier and gain hyperspeed working on your computer 🚀

### Available scripts and functionalities:
- Array copy and paste to easily paste single lines from a multiline clipboard successively
- Append to clipboard
- AI auto completion and command execution using GPT-3.5 or GPT-4
- Collection of useful shortcuts, mostly related to browser interactions
- Copy file names
- Play / pause media
- VLC subtitle activation
- System tray focus and opening
- Open system tray on hover
- Window logger
- Autostart selected ahk scripts  
  
## Array copy and paste to easily paste single lines from a multiline clipboard successively
*File "- array copy.ahk"*  
  
This AutoHotkey script allows you to copy or cut multiple lines of text and paste them individually. This can for example be used when you have to fill out a form with a list of values.

It uses an array to store the copied lines and a flag to indicate the array copy mode.  
If the copied text contains line breaks, it splits the text by line breaks and stores the lines in the array.  
The script then enables the array copy mode and allows you to paste the lines one by one.  
If the last element is reached, it disables the array copy mode and displays a warning, prompting you to paste the last element.  

**Hotkeys:**  
`Ctrl + Win + Alt + Shift + C`: Captures multiple lines into a persistent clipboard array and enables copy-array-mode.  
`Ctrl + Win + Alt + Shift + X`: Cuts and captures multiple lines into a persistent clipboard array and enables copy-array-mode.  
  
  
  
## Append to clipboard
*File "- ctrl+alt+c append.ahk"*  
  
This AutoHotkey script enhances the clipboard functionality by appending newly copied content to the existing clipboard content, instead of replacing it.

It is the counterpart to the "array copy" script, which allows you to copy multiple lines of text and paste them individually.

**Hotkey:** `Ctrl + Alt + C`  

The script checks if the current clipboard content ends with a newline, and if not, it adds one before appending the new content.  
This is useful for accumulating multiple copied texts into one clipboard for a combined paste operation.  
  
  
  

## AI auto completion and command execution using GPT-3.5 or GPT-4
*File "- AI auto complete.ahk"*  
  
This autohotkey script is used to auto-complete or interpret given text using GPT-3.5 or GPT-4  

**Hotkey:** `Ctrl + Win + Y`

**Available modifiers:**  
- Shift: Use GPT-4 instead of GPT-3.5
- Alt: Interpret the text instead of auto-completing it

The script always tries to copy the currently selected text or the active line that is being typed upon  

Uses the `auto-completion.py` which in itself can be a useful tool with CLI commands to be integrated anywhere:

### *"auto-completion.py"*

This Python script is a command-line interface (CLI) tool that uses OpenAI's GPT-3.5-Turbo or GPT-4 models to auto-complete or interpret text.

Here's a breakdown of its functionality:
1. Auto-completion: Given a sentence fragment, the tool completes the sentence using the AI model. The completion is designed to be accurate and concise.
2. Interpretation: Given a sentence fragment, the tool provides an interpretation or answer using the AI model. The response is designed to be exact and concise.

The tool accepts several command-line arguments:
- text: The beginning of the text to complete or interpret. This is a required argument.
- -i or --interpret: If this flag is set, the tool will interpret the input text instead of auto-completing it.
- -f or --force: If this flag is set, the tool will allow answers that modify the start string.
- -c or --copy: If this flag is set, the tool will copy the result to the clipboard.
- -4 or --gpt4: If this flag is set, the tool will use the GPT-4 model (instead of the default GPT-3.5-Turbo).

### Requirements (for both "- AI auto complete.ahk" and "auto-completion.py"):

1. The OPENAI_API_KEY environment variable has to be set to your OpenAI API key.
1. Python 3.8 or higher has to be installed.
1. Install the two libraries openai and pyperclip: `pip install openai pyperclip`
  
  
  
## Collection of useful shortcuts, mostly related to browser interactions
*File "- useful all day shortcuts.ahk"*  
  
This AutoHotkey script provides several productivity shortcuts (all browser interactions are using Firefox):  

### Quickly switching to firefox tabs:  
`Win + Y` or `Win + <` opens a new firefox tab, with adress bar selected.  
if `alt` is pressed, the current clipboard is pasted in the new tab and confirmed with enter (also accepts `Win + Alt + X` for ergonomics)  

If held for more than 500ms (or 1000ms with alt modifier), instead of opening a tab it will preview firefox and then alt+tab back after release  
  
### Enhanced `Ctrl + C` functionality:  
**Double pressing `Ctrl+C`** checks the clipboard content:  
	If it starts with "http" or "www.", it opens the link in the default browser.
      	If it contains ".com" or ".de" without spaces, it prepends "https://" and opens the link.
      	If it's a local file path, it opens the path in the file explorer.
      	Otherwise, it performs a Google search with the clipboard content.
      Triple pressing Ctrl+C triggers a DuckDuckGo "I'm feeling lucky" search with the clipboard content.  
  
`Ctrl + Alt + Shift + C` performs an `Alt + Tab` and paste operation.  
  
### Copy and paste website link:
Pressing `Ctrl + L` twice in quick succesion in firefox copies the URL then `Alt + Tabs` and pastes it in whatever text fields is open in the other application.  
  
### Notion shortcuts:
`F1` in Notion binds to `Ctrl + P` (aligned behavior with VS Code)  
  
  
## Copy file names
*File "double F2.ahk"*  
  
pressing `F2` twice in a row copies the file name and `alt + tabs`  

This enables you to easily copy the file name of a selected file in Windows Explorer  
  
  
  
## Play / pause media
*File "- RCtrl+F12 = play-pause.ahk"*  
  
This script adds a play / pause hotkey, triggered by `right control + F12`
  
  
  
  
## VLC subtitle activation
*File "vlc subtitle del hotkey.ahk"*  
  
This AutoHotkey script enhances the functionality of the `Del` key in VLC media player. 

It requires the VLSub addon and only acts when VLC media player is the active window.

**Hotkeys:**

`Del`: Automatically adds English subtitles. It pauses the video, opens the VLSub window, selects the 'Search by name' option, waits for the subtitle list to load, selects a subtitle, and resumes the video.
pressing `Del` again lets you select the subtitle file (this behavior might already be deprecated and replaced by `Shift + Del`)

`Ctrl + Del`: Similar to `Del`, but selects the 'Search by hash' option in VLSub.

`Shift + Del`: Pauses the video, opens the VLSub window, selects the 'Search by name' option, and waits for the user to manually select a subtitle.
(It uses the KeyWait function to wait for the `Del` key to be released before executing the hotkey actions.)  
  

  
## System tray focus and opening
*File "- win+b plus enter.ahk"*  
  
Pressing `Windows key + B` will focus the system tray and open it automatically.  

Pressing it again will focus and open the first icon in the system tray.  
  
   
  
## Open system tray on hover
*File "automatically open system tray.ahk"*  
  
This AutoHotkey script automatically shows and hides the system tray based on the mouse position.  

(This is more aggressive than the alternative System tray focus and opening)

It checks the mouse position every 100ms. When the mouse moves to a specific "show" area on the screen (defined by xshow and taskbarHeight) in the bottom right corner of the main screen, it simulates a click to show the taskbar and then returns the mouse to its original position.  
When the mouse moves out of a specific "hide" area (defined by xhide and yhide), and if autohide is enabled, it simulates a click to hide the taskbar and then returns the mouse to its original position.  
  
  
  
## Window logger
*File "- window logger.ahk"*  
  
**Window Logging**: This AutoHotkey script logs the active window title along with the application process name.  

*Time Stamping*: It records the start and end timestamps for each active window.  

*Duration Calculation*: The script calculates the duration for which each window is active and appends it to the log.  

*Idle State Detection*: The script detects if the computer is idle for more than one minute and appends "\t(IDLE)" to the window title.  

*Logging Breaks*: If the active window remains the same but exceeds a certain time interval, it logs a break in the form of empty lines.  

*Title Processing*: The script processes the window title to handle specific cases. For instance, if the window title contains "Mozilla Firefox Private Browsing", it is replaced with the exact string "Mozilla Firefox Private Browsing".  

*VLC Logging*: If the active window is VLC media player and it remains active for more than 10 seconds, the script logs this activity to a separate file named .\vlclogfile.txt.  

*Default Values*: In cases where the window title or process name is empty, the script defaults these values to "Windows" and "System" respectively. This ensures that all activities are logged, even if the window title or process name cannot be retrieved.  
  
**Settings**:  
checkInterval: The interval at which the script checks the active window. It is set to 1 second  
currentWindowTitle, currentStartTimestamp, currentEndTimestamp, currentStartTickCount: Variables that store the current window's information and the tick count when the window became active.  
idleTime: Keeps track of the idle time based on user input (mouse/keyboard). If the idle time exceeds 1 minute, the script considers the state as idle.  
  
**Log Format**:  
The log entries are saved in a text file with the following format:  
[Start Timestamp] - [End Timestamp]    [Duration]    [Window Title] ([Process Name])  
Special Cases:  
If the computer is idle, "\t(IDLE)" is appended to the window title.  
Five empty lines are appended to indicate a break in logging activities when the check interval is significantly exceeded.  
  
  
  
## Autostart selected ahk scripts
*File "\_AutoStart_all_ahk_scripts_that_start_with_-.ps1"*  
  
This script will launch all .ahk files in the same directory as this script that start with a "-" 

You can link this script in your auto-start folder to launch all your scripts and enable/disable individual modules by renaming them  
  
 