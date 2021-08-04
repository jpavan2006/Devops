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

function ExecuteQuery {

[CmdletBinding()]
[OutputType([void])]
param
(
[Parameter(Mandatory)]
$instance,
[Parameter(Mandatory)]
$dbname,
[Parameter(Mandatory)]
$query
)
try {

  $connectionString="server=$instance;initial catalog=$dbname;integrated security=sspi;Connection timeout=3600"
  $sqlquery="$query"
  $sqlconnection= New-Object System.Data.SqlClient.SqlConnection
  $sqlconnection.ConnectionString=$connectionString
  $sqlcmd=New-Object  System.Data.SqlClient.SqlCommand
  $sqlcmd.CommandText=$sqlQuery
  $sqlcmd.Connection=$sqlconnection
  
  $sqladaptor= New-Object  System.Data.SqlClient.SqlDataAdapter
  $sqladaptor.SelectCommand=$sqlcmd
  $ResultSet= New-Object System.Data.DataSet
  $recordcount=$sqladapter.Fill($ResultSet)
  
  $sqlconnection.close()  

  $data =$ResultSet.Tables[0]
  
  return $data
}catch{

Write-Error "Query execution failed : $_.Exception.Message" -ErrorAction Stop
Exit 1
break
}
finally{
 $SqlCmd.Dispose()
 $SqlConnection.Dispose()
}
}

function ExecuteNonQuery {

[CmdletBinding()]
[OutputType([void])]
param
(
[Parameter(Mandatory)]
$instance,
[Parameter(Mandatory)]
$dbname,
[Parameter(Mandatory)]
$query
)
try {

  $connectionString="server=$instance;initial catalog=$dbname;integrated security=sspi;Connection timeout=3600"
  $sqlquery="$query"
  $sqlconnection= New-Object System.Data.SqlClient.SqlConnection
  $sqlconnection.ConnectionString=$connectionString
  $sqlconnection.Open()
  $sqlcmd=$sqlconnection.CreateCommand()
  $sqlcmd.CommandText=$sqlquery
  $sqlcmd.CommandTimeout=0
  $sqlcmd.ExecuteNonQuery()
  $sqlconnection.close()  
}catch{

Write-Error "NonQuery execution failed : $_.Exception.Message" -ErrorAction Stop
Exit 1
break
}
finally{
 $SqlCmd.Dispose()
 $SqlConnection.Dispose()
}
}




#