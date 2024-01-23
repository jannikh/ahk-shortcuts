# This script will launch all .ahk files in the same directory as this script that start with a "-"
# You can link this script in your auto-start folder to launch all your scripts and enable/disable individual modules by renaming them

# Get the directory where the PowerShell script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Go into the parent directory
$scriptDir = Split-Path -Parent $scriptDir

# Append the folder "scripts" to the directory
$scriptDir = Join-Path -Path $scriptDir -ChildPath "ahk-scripts"

# Get all .ahk files in the directory that start with a "-"
$ahkFiles = Get-ChildItem -Path $scriptDir -Filter "-*.ahk"

# Loop through each file and launch it
foreach ($file in $ahkFiles) {
    $filePath = $file.FullName
    Start-Process "$filePath"
}
