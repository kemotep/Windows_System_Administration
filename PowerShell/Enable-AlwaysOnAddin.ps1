<###############################################################################

        Enable-AlwaysOnAddin.ps1 | 2.0
        kemotep | Apache 2.0
	kemotep@fastmail.com | https://gitlab.com/kemotep/
                
################################################################################
This script requires Admin to Run!
This is a task that I required to automate because several end users need a new Office Addin 
Outlook keeps disabling this Addin because it is "too slow" on startup
This addin is necessary for these users and manually enabling it is a terrible solution. 
My research discovered a blog post by Andrei Ghita on August 2, 2017.
So here is Andrei's script uploaded here so I can use it.
#>
function Enable-AlwaysOnAddin {
param(

[Parameter(Mandatory=$true)]

[string]$AddinName,

[Parameter(Mandatory=$false)]

[switch]$Force

)
 

$AddinList = $null

$CrashingAddinList = $null

$DoNotDisableAddinList = $null

 
function Get-Key

(

[string]$ParentKey,

[string]$KeyName)

{
     for ($i = 0; $i -lt $KeyName.Split("\").Count; $i++) {
        try {

           $Key = get-item -Path ("{0}:\{1}" -f $ParentKey,($KeyName.split("\")[0..$i] -join "\"))

        }

        catch {

           $Key = new-item -Path ("{0}:\{1}" -f $ParentKey,($KeyName.split("\")[0..$i] -join "\"))

        }
     }
	 
     return $Key
}

$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
$OutlookVersion = (Get-ItemProperty HKLM:\SOFTWARE\Classes\Outlook.Application\CurVer)."(default)".Replace("Outlook.Application.", "")

if ($Force) {

     $checkPoint = $null
}

else {

     try {

        $CheckPoint = (Get-Item "HKCU:\Software\Microsoft\Office\$OutlookVersion.0\Outlook\Resiliency" | Get-ItemProperty)."CheckPoint" -eq 1

     }
     catch {

        $checkPoint = $false
     }
}

if (-not $checkPoint) {
     Get-Key -ParentKey HKCU -KeyName "Software\Policies\Microsoft\Office\$OutlookVersion.0\Outlook\Resiliency\AddinList" | Set-ItemProperty -Name $AddinName -Value 1
     Get-Key -ParentKey HKCU -KeyName "Software\Microsoft\Office\$OutlookVersion.0\Outlook\Resiliency\DoNotDisableAddinList" | Set-ItemProperty -Name $AddinName -Value 1
     Get-Key -ParentKey HKCU -KeyName "Software\Microsoft\Office\$OutlookVersion.0\Outlook\Resiliency\DisabledItems" | Remove-Item
     Get-Key -ParentKey HKCU -KeyName "Software\Microsoft\Office\$OutlookVersion.0\Outlook\Resiliency\DisabledItems" | Out-Null
     Get-Key -ParentKey HKCU -KeyName "Software\Microsoft\Office\$OutlookVersion.0\Outlook\Resiliency\CrashingAddinList" | Remove-Item
     Get-Key -ParentKey HKCU -KeyName "Software\Microsoft\Office\$OutlookVersion.0\Outlook\Resiliency\CrashingAddinList" | Out-Null
     Get-Key -ParentKey HKCU -KeyName "Software\Microsoft\Office\$OutlookVersion.0\Outlook\Resiliency\NotificationReminderAddinData" | Set-ItemProperty -Name ([string]::Format("{0}\dtype",$AddinName)) -Value 2
     Get-Key -ParentKey HKCU -KeyName "Software\Microsoft\Office\$OutlookVersion.0\Outlook\Resiliency\NotificationReminderAddinData" | Set-ItemProperty -Name $AddinName -Value 2524611661
     Get-Item "HKCU:\Software\Microsoft\Office\$OutlookVersion.0\Outlook\Resiliency" | Set-ItemProperty -Name "CheckPoint" -Value 1
}
}
