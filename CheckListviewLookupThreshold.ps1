$Log = "D:\ListviewLookupThreshold.txt"
"Lists with greater than 8 lookup fields: " + (Get-Date) > $Log
"————————————————————" >> $Log
Foreach ($WebApp in (Get-SPWebApplication))
{
"Checking Web Application " + $WebApp.Name | Write-Host -ForegroundColor Green;
Foreach ($Site in $WebApp.Sites)
{
"-Checking Site " + $Site.Url | Write-Host -ForegroundColor Green;
Foreach ($Web in $Site.AllWebs)
{
"–Checking Web " + $Web.Url | Write-Host -ForegroundColor Green;
Foreach ($List In $Web.Lists)
{$Fields = $List.Fields | Where {$_.Type -eq "Lookup” -and $_.SourceID -ne "http://schemas.microsoft.com/sharepoint/v3"};
if ($Fields.Count -gt 7) {"List found with ” + $Fields.Count + ” lookup fields, Name:” + $List.Title + ", Web URL:” + $Web.Url + ", List URL:” + $List.DefaultViewUrl >> $Log}
}
}
$Site.Dispose()
}
}
