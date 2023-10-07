# ================================
# Module-wide Metadata and Variables
# ================================
<#
    .SYNOPSIS
        A PowerShell module library for Active Directory utility functions.

    .DESCRIPTION
        This PowerShell module library, AD-Utilities, provides a collection of utility functions that are commonly used for Active Directory operations. The aim is to facilitate and expedite Active Directory related tasks through reusable code.

    .NOTES
        File Name      : AD-Utilities.psm1
        Author         : Doron Bogomolov
        Prerequisite   : PowerShell V5, Run as Administrator
        Last Updated   : 10.05.2023

    .LINK
        GitHub Repository - https://github.com/Doron-Bogomolov/PS-UtilityLibrary
#>


# ================================
# Function 1: Get-ComputerOU
# ================================
#region Get-ComputerOU

# Function: Get-ComputerOU
# Description: Fetches the Organizational Unit (OU) of a given computer from Active Directory.
# Parameters: 
# - ComputerName: The name of the computer for which the OU needs to be fetched. This is a mandatory parameter.
#
# Returns: 
# - A custom object containing 'ComputerName' and 'OU' if the operation is successful.
# - An error object if the operation fails.
#
# Example Usage:
# $result = Get-ComputerOU -ComputerName "DESKTOP-123"

function Get-ComputerOU {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ComputerName
    )

    $OUInfo = New-Object PSObject -property @{
        'ComputerName' = $ComputerName
        'OU'           = $null
    }

    try {
        $computerObject = Get-ADComputer $ComputerName -ErrorAction Stop
        $ou = ($computerObject.DistinguishedName -split ",", 2)[1]
        $OUInfo.OU = $ou
    }
    catch {
        Write-Error "An error occurred: $_"
        return $null
    }

    return $OUInfo
}

#endregion Get-ComputerOU


# ================================
# Function 2: Get-OUModificationHistory
# ================================
#region Get-OUModificationHistory

# Function: Get-OUModificationHistory
# Description: Fetches the Organizational Unit (OU) and its modification history of a given computer from Active Directory.
# Parameters: 
# - ComputerName: The name of the computer for which the OU and its modification history need to be fetched.
#
# Returns: 
# - A custom object containing 'ComputerName', 'OU', 'Created', and 'Modified' if the operation is successful.
# - An error object if the operation fails.
#
# Example Usage:
# $result = Get-OUModificationHistory -ComputerName "DESKTOP-123"

function Get-OUModificationHistory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ComputerName
    )

    $OUHistory = New-Object PSObject -property @{
        'ComputerName' = $ComputerName
        'OU'           = $null
        'Created'      = $null
        'Modified'     = $null
    }

    try {
        $ADComputer = Get-ADComputer $ComputerName -Properties "Created", "Modified" -ErrorAction Stop
        $OU = ($ADComputer.DistinguishedName -split ",", 2)[1]
        $OUHistory.OU = $OU
        $OUHistory.Created = $ADComputer.Created
        $OUHistory.Modified = $ADComputer.Modified
    }
    catch {
        Write-Error "An error occurred: $_"
        return $null
    }

    return $OUHistory
}

#endregion Get-OUModificationHistory