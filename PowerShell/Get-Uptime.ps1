 <##############################################################################

        Get-UpTime.ps1 | 2.0
	kemotep | Apache 2.0
	kemotep@fastmail.com | https://gitlab.com/kemotep/

################################################################################
Neat script from reddit.com/r/sysadmin. TODO: Refactor to "kemotep style" #>

function Get-UpTime {
<# 
.Synopsis
    Get a given computers current uptime
.DESCRIPTION
    This function will allows a user to determine the uptime of a given computer using a wmi query. 
	Useful for determing last boot. 
#>
param (
    [Parameter(mandatory = $true, ValueFromPipeline = $true)]
    [string]$ComputerName = @(".")
      )
process {
# Here we see if the computer responds to a ping, otherwise the WMI queries will fail
    $query = "select * from win32_pingstatus where address = '$ComputerName'"
    $ping = Get-WmiObject -query $query
    if ($ping.protocoladdress) {
        # Ping responded, so now we connect to the computer via WMI
        $os = Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName -ev myError -ea SilentlyContinue
        $LastBootUpTime = $os.ConvertToDateTime($os.LastBootUpTime)
        $LocalDateTime = $os.ConvertToDateTime($os.LocalDateTime)
        # Here we are calculating uptime
        $up = $LocalDateTime - $LastBootUpTime
        # Changing it to a more human readable format
        $uptime = "$($up.Days) days, $($up.Hours)h, $($up.Minutes)mins"
        # We need to save the results for this computer in an object
        $results = new-object psobject
        $results | add-member noteproperty LastBootUpTime $LastBootUpTime
        $results | add-member noteproperty ComputerName $os.csname
        $results | add-member noteproperty uptime $uptime
        # Now we can display the results
        $results | Select-Object ComputerName, LastBootUpTime, uptime
        }
    # Print an error message if it fails
	else {
    "$ComputerName did not respond."
		 }
	}
}
