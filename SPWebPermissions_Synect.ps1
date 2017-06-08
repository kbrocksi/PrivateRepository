Add-PSSnapin Microsoft.SharePoint.Powershell
$Url = "http://dsportal" #Replace URL with your site collection
$RootURL = $url.Split("/") # Split function is required for Host based site collection
$RootURL = $RootURL[0] + "/" + $RootURL[1] + "/" + $RootURL[2]

$logTime = Get-Date -Format "Mm-dd-yyyy_hh-mm-ss"
$Columns = "List Title" + ";" + "Item URL" + ";" + "Name" + ";" + "Created" + ";" + "Created by" + ";" + "Modified" + ";" + "Modified by" + ";" + "Check out to"
$logFile = "D:\UniqueListItems" + $logtime + ".csv" # Log Location
$columns | out-file -filepath $logfile -append

$site=Get-SPSite $url

# $Webs = $site.AllWebs | Where-Object { $_.Url -contains "PE/ECTA/ECTA%20Intern/EDM" }
$Webs = Get-SPWeb -identity "http://dsportal/OurCompany/Departments/PE/ECTA/ECTA Intern/EDM"
# $Webs = $site.AllWebs

foreach($web in $webs)
{
    $lists = $web.Lists
    foreach($list in $lists)
    {
        $Uniqueitems = $list.GetItems()
            foreach($Uniqueitem in $Uniqueitems)
            {
                $item = $list.GetItemById($Uniqueitem.id)
                $output = $list.Title +  ";" + $item.Url + ";" + $item.Name + ";" + $item["Created"] + ";" + $item["Author"] + ";" + $item["Modified"] + ";" + $item["Editor"] + ";" + $item["Check out to"]
                $output | out-file -filepath $logfile -append
            }
     }
    $web.Dispose()
}
$site.Dispose()