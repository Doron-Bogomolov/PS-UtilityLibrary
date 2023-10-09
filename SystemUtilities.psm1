# ================================
# Module-wide Metadata and Variables
# ================================
<#
.SYNOPSIS
    A PowerShell module that provides a collection of utility functions for system-level operations.

.DESCRIPTION
    SystemUtilities is a PowerShell module designed to offer reusable functionalities commonly required for system-level operations. These utilities can be easily imported into any PowerShell script to streamline development and reduce redundant code.

.EXAMPLE
    Import-Module ./path/to/SystemUtilities.psm1
    Test-AdminPrivilege

.NOTES
    File Name      : SystemUtilities.psm1
    Author         : Doron Bogomolov
    Prerequisite   : PowerShell V5, Run as Administrator for certain functions
    Last Updated   : 10.05.2023

.LINK
    GitHub Repository - https://github.com/Doron-Bogomolov/PS-UtilityLibrary
#>

# ================================
# Function 1: Test-AdminPrivilege
# ================================
#region Test-AdminPrivilege

# Function: Test-AdminPrivilege
# Description: Ensures the PowerShell script is running with administrator privileges. 
#              If not, it restarts the script as an administrator.
# Parameters: None
# Usage: Test-AdminPrivilege
# Example: Simply add `Test-AdminPrivilege` at the start of your script to enforce admin privileges.

function Test-AdminPrivilege {
    [CmdletBinding()]
    param (
        # Empty param block to support [CmdletBinding()]
    )

    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        # Restart the script as admin
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    }
    else {
        Write-Host "Running with admin privileges" -ForegroundColor Green
    }
}


#endregion Test-AdminPrivilege




# ================================
# Function 2: Initialize-LogFile
# ================================
#region Initialize-LogFile

# Function: Initialize-LogFile
# Description: Initializes a log file for the PowerShell script. Allows specifying the file path, name, and visibility. 
#              If not specified, defaults are used. Default LogPath is the script's directory, and default LogFileName is "logFile.txt".
# Parameters: 
# - LogPath (Alias: p, filepath): The path where the log file will be stored. Default is the script's directory.
# - LogFileName (Alias: n, filename): The name of the log file. Default is "logFile.txt".
# - Visibility (Alias: v, visible): A switch to control the visibility of the log file. Default is hidden.
# Usage: Initialize-LogFile [-LogPath <path>] [-LogFileName <name>] [-Visibility]
# Example 1: Initialize-LogFile -LogPath "C:\Logs" -LogFileName "MyLog.txt" -Visibility
# Example 2: Initialize-LogFile -p "C:\Logs" -n "MyLog.txt" -v

function Initialize-LogFile {
    [CmdletBinding()]
    param (
        [Alias("p", "filepath")]
        [string]$PathParam = $(if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Path $MyInvocation.MyCommand.Path -Parent }),
        
        [Alias("n", "filename")]
        [string]$NameParam = "logFile.txt",
        
        [Alias("v", "visible")]
        [switch]$VisibleParam
    )
    
    $logFile = Join-Path -Path $PathParam -ChildPath $NameParam

    # Check for write permissions to the directory
    $isValidPath = Test-Path $PathParam -IsValid
    if ((Test-Path $PathParam) -and $isValidPath) {

        try {
            $null = New-Item -Path "$PathParam\testWrite.tmp" -ItemType File -ErrorAction Stop
            Remove-Item -Path "$PathParam\testWrite.tmp" -ErrorAction Stop
        }
        catch {
            Write-Host "Insufficient privileges to write to $PathParam. Redirecting to temp folder."
            $PathParam = [System.IO.Path]::GetTempPath()
            $timestamp = Get-Date -Format "yyyyMMddHHmmss"
            $NameParam = "$NameParam-$timestamp.txt"
            $logFile = Join-Path -Path $PathParam -ChildPath $NameParam
        }
    }

    # Create the log file if it does not exist
    if (-not (Test-Path $logFile)) {
        New-Item -Path $logFile -ItemType File
    }

    # Set visibility
    if ($VisibleParam) {
        Set-ItemProperty -Path $logFile -Name Attributes -Value [System.IO.FileAttributes]::Archive
    } else {
        Set-ItemProperty -Path $logFile -Name Attributes -Value ([System.IO.FileAttributes]::Hidden -bor [System.IO.FileAttributes]::Archive)
    }
}

#endregion Initialize-LogFile


# ================================
# Function 3: Show-CustomMenu
# ================================
#region Show-CustomMenu

# Function: Show-CustomMenu
# Description: Displays a customizable menu and returns the selected option.
# Parameters: 
# - MenuName: The name of the menu.
# - OptionNames: An array of option names to display.
#
# Returns: 
# - The selected option's index.
#
# Usage: Show-CustomMenu -MenuName "Mode Selection" -OptionNames @("OU Only", "OU with History")
# Example: $selectedOption = Show-CustomMenu -MenuName "Mode Selection" -OptionNames @("OU Only", "OU with History")

function Show-CustomMenu {
    param (
        [Parameter(Mandatory = $true)]
        [string]$MenuName,
        
        [Parameter(Mandatory = $true)]
        [string[]]$OptionNames
    )
    
    do {
        Clear-Host
        Write-Host "---------------- $MenuName ----------------"
        
        # Display each option with a corresponding number
        for ($i = 0; $i -lt $OptionNames.Length; $i++) {
            Write-Host "$($i + 1). $($OptionNames[$i])"
        }
        
        Write-Host "------------------------------------------------"
        
        try {
            $userInput = Read-Host "Please enter the number corresponding to your choice"
            
            # Check if the user input is a number
            if ($userInput -match '^\d+$') {
                $selectedOption = [int]$userInput
            } else {
                Write-Host "Invalid input. Please enter a number."
                continue
            }
            
            # Validate the user's choice
            if ($selectedOption -ge 1 -and $selectedOption -le $OptionNames.Length) {
                Write-Host "You selected option $($OptionNames[$selectedOption - 1])."
                return $selectedOption
            } else {
                Write-Host "Invalid selection. Please try again."
            }
        }
        catch {
            Write-Host "An error occurred. Please try again."
        }
    } while ($true)
}


#endregion Show-CustomMenu
