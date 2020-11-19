Add-Type -Path "c:\setup\sqlite\System.Data.SQLite.dll" # Change path

Function queryDatabase([string]$db, [string]$sql) {
  
    Try {
        If (Test-Path $db) {
            "bin"
            $CONN = New-Object -TypeName System.Data.SQLite.SQLiteConnection
            $CONN.ConnectionString = "Data Source=$db"
            $CONN.Open()
  
            $CMD = $CONN.CreateCommand()
            $CMD.CommandText = $sql
  
            $ADAPTER = New-Object  -TypeName System.Data.SQLite.SQLiteDataAdapter $CMD
            $DATA = New-Object System.Data.DataSet
  
            $ADAPTER.Fill($DATA)
  
            $TABLE = $DATA.Tables
  
            ForEach ($t in $TABLE){
                Write-Output $t
            }
  
            $CMD.Dispose()
            $CONN.Close()
  
        } Else {
            #Log-It "Unable to find database: Query Failed"
            "Error query failed"
        }
  
    } Catch {
        #Log-It "Unable to query database: Error"
        "error"
    }
}
cls
$profileList = Get-ChildItem c:\Users

foreach($profile in $profileList){
$profile.Name
$DBPath = "c:\Users\$($profile.Name)\AppData\Local\Google\Chrome\User Data\Default\History" # Change path
$Rows = New-Object System.Collections.ArrayList
  
$CDate = Get-Date -format "yyyy-MM-dd"
$CTime = Get-Date -format "HH:mm:ss"

$Query = "Select * From urls"

$Query = "SELECT datetime(last_visit_time/1000000-11644473600,'unixepoch','localtime'),
                        url 
                 FROM urls
                 ORDER BY last_visit_time DESC
"
queryDatabase $DBPath $Query
}
