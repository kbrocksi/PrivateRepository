Add-PSSnapin Microsoft.SharePoint.Powershell
$searchapp = Get-SPEnterpriseSearchServiceApplication -Identity "Search Service Application"
$bindingflags = [Reflection.BindingFlags] "Public,Static"
$type = $searchApp.GetType().Assembly.GetType("Microsoft.Office.Server.Search.Administration.CrawlReportJobDefinition")
$type2 = $searchApp.GetType().Assembly.GetType("Microsoft.Office.Server.Search.Administration.CrawlReportCleanupJobDefinition")
$ensureCrawlReportTimerjob = $type.GetMethod("EnsureJob", $BindingFlags)
$ensureCrawlReportCleanupTimerjob = $type2.GetMethod("EnsureJob", $BindingFlags)
$ensureCrawlReportTimerjob.Invoke($null, $searchApp)
$ensureCrawlReportCleanupTimerjob.Invoke($null, $searchApp)