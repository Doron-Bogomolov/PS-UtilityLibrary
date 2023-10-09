# Import the module

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # Restart the script as admin
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -NoExit -File `"$PSCommandPath`"" -Verb RunAs #NoExit is temp
    exit
}


$LocalPath = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$ModulePath = Join-Path -Path $LocalPath -ChildPath 'SystemUtilities.psm1'
Import-Module $ModulePath

# Call the function
Test-AdminPrivilege
