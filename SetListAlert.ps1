$site = Get-SPSite 'http://...'
$web=$site.Rootweb
$list=$web.Lists.TryGetList('Listname')
$user = $web.EnsureUser('Account')
$newAlert = $user.Alerts.Add()
$newAlert.Title = "Listname"
$newAlert.AlertType=[Microsoft.SharePoint.SPAlertType]::List
$newAlert.List = $list
$newAlert.DeliveryChannels = [Microsoft.SharePoint.SPAlertDeliveryChannels]::Email 
$newAlert.EventType = [Microsoft.SharePoint.SPEventType]::Add
$newAlert.AlertFrequency = [Microsoft.SharePoint.SPAlertFrequency]::Immediate 
$newAlert.Update($false)
