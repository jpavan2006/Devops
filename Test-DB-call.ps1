#Set-ExecutionPolicy Unrestricted

$environment=$args[0]
$workspace=$args[1]

write-host "passed $environment and passed $workspace"

#$workspace=$($workspace)
#$workspace="C:\2021-projects\Devops"
Write-Host $workspace
$psscript="$($workspace)\Devops\build-functions.ps1"
.$psscript

$instance = GetDBInstance -environment $environment -workspace $workspace

Write-Host " Instance" $instance

