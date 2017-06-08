Add-PSSnapin microsoft.sharepoint.powershell

$site = Get-SPSite "http://..."
$alertResultsCollection = @()

foreach ($web in $site.AllWebs) {  
   foreach ($alert in $web.Alerts){
        $alertURL = $web.URL + "/" + $alert.ListUrl
        $alertResult = New-Object PSObject
	$alertResult | Add-Member -type NoteProperty -name "List URL" -value $alertURL
	$alertResult | Add-Member -type NoteProperty -name "Alert Title" -value $alert.Title
	$alertResult | Add-Member -type NoteProperty -name "Alert Type" -value $alert.AlertType
	$alertResult | Add-Member -type NoteProperty -name "Subscribed User" -value $alert.User
	$alertResultsCollection += $alertResult
	}
   }

$site.Dispose()
$alertResultsCollection

## Export to CSV

$alertResultsCollection | Export-CSV "Alerts.csv"
