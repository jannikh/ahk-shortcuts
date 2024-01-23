# This scripts takes all *.ahk files (except blacklisted ones) located in [project-folder]/ahk-scripts and compiles them to [project-folder]/compiled-executables

# compile.ps1

# Define the paths for the source and destination folders
$sourceFolder = "..\ahk-scripts"
$destinationFolder = "..\compiled-executables"
$ahkCompiler = "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" # Adjust this path to the actual location of Ahk2Exe.exe on your system

# Create an array of blacklisted file names (without the .ahk extension)
$blacklist = @(
    "hotstring",
    "AI auto complete"
)

# Ensure the destination directory exists
if (-not (Test-Path -Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder
}

# Get all .ahk files in the source folder
$ahkFiles = Get-ChildItem -Path $sourceFolder -Filter *.ahk

foreach ($file in $ahkFiles) {
    # Check if the file is not in the blacklist
    $excludeFile = $false
    foreach ($blockedName in $blacklist) {
        if ($file.Name -match $blockedName) {
            Write-Host "Skipping blacklisted file: $($file.Name)"
            $excludeFile = $true
            break
        }
    }

    if (-not $excludeFile) {
        # Define the output path for the compiled executable
        $exePath = Join-Path $destinationFolder ($file.BaseName + ".exe")
        
        # Compile the script to an executable using Ahk2Exe
        & $ahkCompiler /in $file.FullName /out $exePath
    }
}