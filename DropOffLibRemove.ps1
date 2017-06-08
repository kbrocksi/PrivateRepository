Get-SPSite -Identity http://dsportal | Get-SPWeb -Limit ALL | ForEach-Object { 
Disable-SPFeature –Identity DocumentRouting –url $_.Url –Confirm:$true

$dropOffLibrary = $_.Lists["Drop Off Library"]
Write-Host $_.url ... "Item Count: " $dropOffLibrary.ItemCount
$dropOffLibrary.AllowDeletion = "True"
$dropOffLibrary.Update()
$dropOffLibrary.Delete()


}
