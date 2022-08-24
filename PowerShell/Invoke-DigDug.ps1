<###############################################################################
	
        Invoke-DigDug | 2.0
	kemotep | Apache 2.0
	kemotep@fastmail.com | https://gitlab.com/kemotep/

################################################################################
This is my take on FizzBuzz, or in this case DigDug. With parameter binding you can pass through your own inputs.
Default is `-Min 1 -Max 100` Use your own with the `-Min` and `-Max` flags.
#>

function Invoke-DigDug { 
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false, Position = 0)]
		$Min = 1,
	[Parameter(Mandatory = $false, Position = 1)]
		$Max = 100
	)
	for ($X = $Min; $X -le $Max; $X++) {
		$Output = ""
		if ($X % 3 -eq 0) { $Output += "Dig" }
		if ($X % 5 -eq 0) { $Output += "Dug" }
		if ($Output -eq "") { $Output = $X }
		Write-Output $Output
	}
}
