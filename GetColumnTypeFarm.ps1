$TTNExcludeLists = "Solution Gallery", 
                "Workflow Tasks", 
                "Master Page Gallery"

Get-SPSite -Limit All | Get-SPWeb -Limit All | Select -ExpandProperty Lists | Where { -Not ($TTNExcludeLists -Contains $_.Title) } | Select -ExpandProperty Fields | 
  Where { $_.TypeDisplayName -eq "Cascading Lookup Plus" -and 
          $_.Hidden -eq $false -and 
          $_.FromBaseType -eq $false } | 
  Select {$_.ParentList.ParentWebUrl}, 
         {$_.ParentList}, 
         {$_.Title},
         {$_.LookupWebId},
         {$_.LookupList},
         {$_.LookupField} | Export-CSV d:\ccl.csv