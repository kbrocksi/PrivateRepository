Add-PSSnapin Microsoft.SharePoint.Powershell
$Url = "http://..." #Replace URL with your site collection
$RootURL = $url.Split("/") # Split function is required for Host based site collection
$RootURL = $RootURL[0] + "/" + $RootURL[1] + "/" + $RootURL[2]

$logTime = Get-Date -Format "Mm-dd-yyyy_hh-mm-ss"
$Columns = "WebURL" + ";" + "List Default View URL" + ";" + "List Title" + ";" + "Item URL" + ";" + "Name" + ";" + "Type" +";"+"Permission"
$logFile = "D:\UniquePermissions" + $logtime + ".csv" # Log Location
$columns | out-file -filepath $logfile -append

$site=Get-SPSite $url

$Webs = $site.AllWebs | Where-Object { $_.Title -contains "<SearchText>" }
# $Webs = $site.AllWebs

foreach($web in $webs)
{

    if($web.HasUniqueRoleAssignments)

      {
        $WebRoles = $Web.RoleAssignments
        foreach($WebRole in $WebRoles)
            {

            $WebRoleBindings = $WebRole.RoleDefinitionBindings
            foreach($WebRoleBinding in $WebRoleBindings)
               {

                if($webrole.Member.IsDomainGroup -eq $null)
                    {
                    $output = $web.url + ";" + ";" + ";" +  ";" + $WebRole.member.Name + ";" + "SharePoint Group" + ";" + $WebRoleBinding.Name
                    $output | out-file -filepath $logfile -append
                    }
                    else
                    {
                        if($webrole.Member.IsDomainGroup)
                        {
                        $output = $web.url + ";" + ";" + ";" +  ";" + $WebRole.member.Name + ";" + "Domain Group" + ";" + $WebRoleBinding.Name
                        $output | out-file -filepath $logfile -append
                        }
                        else
                       
                        {
                        $output = $web.url + ";" + ";" + ";" +  ";" + $WebRole.member.UserLogin + ";" + "Domain User" + ";" + $WebRoleBinding.Name
                        $output | out-file -filepath $logfile -append
                        }
                    }
                }

            }
       
      }
   
    $lists = $web.Lists
    foreach($list in $lists)
    {
        if($list.HasUniqueRoleAssignments)
        {

            $ListRoles = $list.RoleAssignments
            foreach($listRole in $ListRoles)
                {
           
                    $ListRoleBindings = $listrole.RoleDefinitionBindings
                    foreach($ListRoleBinding in $ListRoleBindings)
                    {
               

                if($listrole.Member.IsDomainGroup -eq $null)
                    {
                    $output = $web.url + ";" + $rooturl + $list.DefaultViewUrl + ";" + $list.Title +  ";" + ";" + $ListRole.Member.Name + ";" + "SharePoint Group" + ";" + $ListRoleBinding.Name
                        $output | out-file -filepath $logfile -append       
                    }
                    else
                    {
                        if($listrole.Member.IsDomainGroup)
                        {
                        $output = $web.url + ";" + $rooturl + $list.DefaultViewUrl + ";" + $list.Title +  ";" + ";" + $ListRole.Member.Name + ";" + "Domain Group" + ";" + $ListRoleBinding.Name
                        $output | out-file -filepath $logfile -append       
                        }
                        else
                       
                        {
                       
                        $output = $web.url + ";" + $rooturl + $list.DefaultViewUrl + ";" + $list.Title +  ";" + ";" + $ListRole.Member.UserLogin + ";" + "Domain User" + ";" + $ListRoleBinding.Name
                        $output | out-file -filepath $logfile -append       

                        }
                    }

  
                    }
           
                }

        }

      

        $Uniqueitems = $list.GetItemsWithUniquePermissions()
            foreach($Uniqueitem in $Uniqueitems)
            {

                $item = $list.GetItemById($Uniqueitem.id)
                $itemRoles = $item.RoleAssignments
                foreach($itemRole in $itemroles)
                    {
                    $itemRoleBindings = $itemrole.RoleDefinitionBindings
                    foreach($itemrolebinding in $itemRoleBindings)
                        {
                       

                        if($itemrole.Member.IsDomainGroup -eq $null)
                    {
                   
                    $output = $web.url + ";" + $rooturl + $list.DefaultViewUrl + ";" + $list.Title +  ";" + $rooturl+ "/" +$item.Url + ";" + $itemRole.Member.Name + ";" + "SharePoint Group" + ";" + $itemRoleBinding.Name
                        $output | out-file -filepath $logfile -append
                   
                   
                    }
                    else
                    {
                        if($itemrole.Member.IsDomainGroup)
                        {
                       
                    $output = $web.url + ";" + $rooturl + $list.DefaultViewUrl + ";" + $list.Title +  ";" + $rooturl+ "/" +$item.Url + ";" + $itemRole.Member.Name + ";" + "Domain Group" + ";" + $itemRoleBinding.Name
                        $output | out-file -filepath $logfile -append

                        }
                        else
                       
                        {
                        $output = $web.url + ";" + $rooturl + $list.DefaultViewUrl + ";" + $list.Title +  ";" + $rooturl+ "/" +$item.Url + ";" + $itemRole.Member.UserLogin + ";" + "Domain User" + ";" + $itemRoleBinding.Name
                        $output | out-file -filepath $logfile -append
                        }
                    }

     }
                    }

            }

    }

    $web.Dispose()

}

$site.Dispose()
