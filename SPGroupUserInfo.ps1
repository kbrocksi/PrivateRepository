[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
$site = New-Object Microsoft.SharePoint.SPSite("http://...")
$groups = $site.RootWeb.sitegroups
$output = foreach ($grp in $groups) {$grp.name + ";" + $grp.Owner;}
$output | Out-File d:\GrpOwner.csv




[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
$site = New-Object Microsoft.SharePoint.SPSite("http://...")
$groups = $site.RootWeb.sitegroups
foreach ($grp in $groups) {"Group: " + $grp.name + " Owner: " + $grp.Owner; foreach ($user in $grp.users) {"  User: " + $user.name} }