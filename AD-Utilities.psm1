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
# Purpose: Fetches the Organizational Unit (OU) of a given computer from Active Directory.
# Parameters: 
# - ComputerName: The name of the computer for which the OU needs to be fetched. This is a mandatory parameter.
#
# Returns: 
# - A hash table containing 'ComputerName' and 'OU' if the operation is successful.
# - A hash table containing 'ComputerName' and 'Error' if the operation fails.
#
# Example Usage:
# $result = Get-ComputerOU -ComputerName "DESKTOP-123"

function Get-ComputerOU {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ComputerName
    )

    # Initialize an empty hash table to store the OU and modification details
    $OUHash = @{}

    try {
        # Get the computer object using the Active Directory PowerShell module
        $computerObject = Get-ADComputer $ComputerName -ErrorAction Stop
        # Extract the OU part of the Distinguished Name
        $ou = ($computerObject.DistinguishedName -split ",", 2)[1]

        # Populate the hash table
        $OUHash['ComputerName'] = $ComputerName
        $OUHash['OU'] = $ou

        return $OUHash
    }
    catch {
        # Handle specific exceptions first
        if ($_.Exception -is [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]) {
            $OUHash['Error'] = "Computer not found in AD"
        }
        else {
            $OUHash['Error'] = "An unknown error occurred: $_"
        }

        # Populate the hash table
        $OUHash['ComputerName'] = $ComputerName

        return $OUHash
    }
}

#endregion Get-ComputerOU


# ================================
# Function 2: Get-OUModificationHistory
# ================================
#region Get-OUModificationHistory

# Function: Get-OUModificationHistory
# Purpose: Fetches the Organizational Unit (OU) along with its modification history of a given computer from Active Directory.
# Parameters: 
# - ComputerName: The name of the computer for which the OU and its modification history need to be fetched. This is a mandatory parameter.
#
# Returns: 
# - A hash table containing 'ComputerName', 'OU', 'Created', and 'Modified' if the operation is successful.
# - A hash table containing 'ComputerName' and 'Error' if the operation fails.
#
# Example Usage:
# $result = Get-OUModificationHistory -ComputerName "DESKTOP-123"

function Get-OUModificationHistory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ComputerName
    )

    $OUHistory = @{}

    try {
        $ADComputer = Get-ADComputer $ComputerName -Properties "Created", "Modified", "DistinguishedName"
        $OU = ($ADComputer.DistinguishedName -split ",", 2)[1]

        $OUHistory['ComputerName'] = $ComputerName
        $OUHistory['OU'] = $OU
        $OUHistory['Created'] = $ADComputer.Created
        $OUHistory['Modified'] = $ADComputer.Modified

    } catch {
        if ($_.Exception -is [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]) {
            $OUHistory['Error'] = "Computer not found in AD"
        }
        else {
            $OUHistory['Error'] = "An unknown error occurred: $_"
        }
        $OUHistory['ComputerName'] = $ComputerName
    }

    return $OUHistory
}

#endregion Get-OUModificationHistory