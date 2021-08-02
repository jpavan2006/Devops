#Import-Module sqlps -DiableNameChecking

function GetDBInstance {

[CmdletBinding()]
[OutputType([void])]
param
(
[Parameter(Mandatory)] 
$environment,
[Parameter(Mandatory)] 
$workspace
)
	try {
	#$json_file=$($workspace)\Conf\environments.json
	write-host " build file :   $environment and $workspace"
	
	$json_file="$workspace\Conf\environments.json"
	$converted = (Get-Content -Raw -Path $json_file)  -split '(?s)/\*.*?\*/' -notmatch '^\s*$' | ForEach-Object { $_.Trim(); } | ConvertFrom-Json
	#$converted = (Get-Content -Raw -Path $json_file)  | ForEach-Object { $_.Trim(); } | ConvertFrom-Json
	
	$envs=$converted.environments
	Write-Host "converted is $envs"
	$instance ="$($envs."$environment".host),$($envs."$environment".port)"
	return $instance

	}
	catch {
	Write-Host "Failed to read JSON: $_.Exception.Message" -ErrorAction stop | out-null
	Exit 1
	break

	}

}