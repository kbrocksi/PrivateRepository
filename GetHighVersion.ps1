param($url)
start-spassignment -global
function Run-SQLQuery ($SqlServer, $SqlDatabase, $SqlQuery){
 
    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $SqlConnection.ConnectionString = "Server =" + $SqlServer + "; Database =" + $SqlDatabase + "; Integrated Security = True"
    $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
    $SqlCmd.CommandText = $SqlQuery
    $SqlCmd.Connection = $SqlConnection
    $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $SqlAdapter.SelectCommand = $SqlCmd
    $DataSet = New-Object System.Data.DataSet
 
    $SqlAdapter.Fill($DataSet)
    $SqlConnection.Close()
    $DataSet.Tables[0]
 
}
 
function get-impersonatedsite (
    [parameter(mandatory=$true)]
    $url,
    [parameter(mandatory=$true)]
    $username
)
{
    try {
        $site = get-spsite $url -ea 0
        if ($site -eq $null) {
            throw "site not found: $url"
        }
        $web = $site.rootweb
        $user = $web.allusers[$username]
        if ($user -eq $null) {
            throw "user not found: $username"
        }
        $token = $user.usertoken
        $isite = new-object microsoft.sharepoint.spsite($url, $token)
        return $isite
    }
    catch {
        write-host "error:" $_
    }
}
 
 
$wa = Get-SPWebApplication -Identity $url
foreach($db in $wa.ContentDatabases){
 
    #$myQuery = "SELECT userdata.[tp_ID] as ListItemId, userdata.[tp_ListId] as ListId, userdata.[tp_SiteId] as SiteId, userdata.[tp_Version] as myVersion, userdata.tp_Modified as ModifiedDate,lists.[tp_WebId] as WebId
    #FROM [AutoSPInstaller_Content_Portal].[dbo].[AllUserData] userdata
    #INNER JOIN [AutoSPInstaller_Content_Portal].[dbo].[AllLists] lists
    #ON lists.[tp_SiteId] = userdata.[tp_SiteId]
    #AND lists.[tp_ID] = userdata.[tp_ListId]
    #WHERE userdata.[tp_ID] = 321
    #AND userdata.[tp_ListId] = '682F2599-C8C7-4666-B19B-BBD61061CABC'
    #AND userdata.[tp_SiteId] = '6C38CD08-457C-4702-99D5-95AF8F73F065'"
 
    $myQuery = [string]::Format( "SELECT latest.[tp_ID] as ListItemId , latest.[tp_ListId] as ListId, latest.[tp_SiteId] as SiteId, latest.[tp_Version] HighVersion, latest.tp_Modified as ModifiedDate, lists.tp_WebId as WebId
    FROM (
           SELECT [tp_ID], [tp_ListId], [tp_SiteId], max([tp_Version]) as MaxVersion
           FROM [{0}].[dbo].[AllUserData] 
           GROUP BY [tp_ID], [tp_ListId], [tp_SiteId]
           HAVING Count(*) > 1
    ) maxV      
    INNER JOIN [{0}].[dbo].[AllUserData] latest 
    ON latest.[tp_ID] = maxV.[tp_ID] 
    AND latest.[tp_ListId] = maxV.[tp_ListId] 
    AND latest.[tp_SiteId] = maxV.[tp_SiteId] 
    AND latest.tp_Version = maxV.MaxVersion
    INNER JOIN [{0}].[dbo].[AllUserData] older 
    ON older.[tp_ID] = latest.[tp_ID] 
    AND older.[tp_ListId] = latest.[tp_ListId] 
    AND older.[tp_SiteId] = latest.[tp_SiteId] 
    AND older.tp_Version < latest.tp_Version 
    AND older.tp_Modified > latest.tp_Modified
    INNER JOIN [{0}].[dbo].[AllLists] lists
    ON lists.[tp_ID] = latest.[tp_ListId]",$db.Name)
 
    $results = Run-SQLQuery -SqlServer $db.Server -SqlDatabase $db.Name -SqlQuery $myQuery | select ListItemId, ListId, SiteId,WebId
 
    Write-Host $results
 
 
    Foreach($result in $results){
        $site = Get-SPSite -Identity $result.SiteId
        $web =  $site.OpenWeb($result.WebId)      #Get-SPWeb -Identity $result.WebId
        $list = $web.Lists[$result.ListId]
        $item = $list.GetItemById($result.ListItemId)
        # $item.Versions.DeleteAll()
	Write-Host $web.Url
	Write-Host $list.Title
        Write-Host $item.Title
	Write-Host $item.Id
	Write-Host '-----------------'
 
    }
}