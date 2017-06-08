$site = Get-SPSite 'http://dsportal'
$web=$site.Rootweb
$list=$web.Lists.TryGetList('dSPACE News Important')
$user = $web.EnsureUser('dspace.de\karstenb')
$newAlert = $user.Alerts.Add()
$newAlert.Title = "dSPACE Important News"
$newAlert.AlertType=[Microsoft.SharePoint.SPAlertType]::List
$newAlert.List = $list
$newAlert.DeliveryChannels = [Microsoft.SharePoint.SPAlertDeliveryChannels]::Email 
$newAlert.EventType = [Microsoft.SharePoint.SPEventType]::Add
$newAlert.AlertFrequency = [Microsoft.SharePoint.SPAlertFrequency]::Immediate 
$newAlert.Update($false)