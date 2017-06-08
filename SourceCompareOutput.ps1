Add-PSSnapin Microsoft.SharePoint.PowerShell

$url = "http://dsportal"
$site = get-spsite $url

#Create array variable to store data
$siteitems = $null
$siteitems = @()

#Loop to collect Site, list, and list item
$Webs = $site.AllWebs | Where-Object { $_.Title -contains "Product Information Portal" }
# $Webs = $site.AllWebs

foreach($web in $webs)
        
    {Write-Host $web.url -foregroundcolor yellow ; 
        foreach($List in $web.lists)
            {foreach($item in $List.Items)
                {$props = @{'Site' = $web.Url;'List'=$List.Title;'Item'=$Item.Name} ; $siteitemarray = New-Object -TypeName PSObject -Property $props ; $siteitems += $siteitemarray  
				}
			}	
	}

#Output to CSV
$siteitems | Export-Csv d:\2010_Source_siteoutput.csv