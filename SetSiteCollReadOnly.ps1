# Define whether ReadOnly will be set to true or false
[bool]$readOnly = $true

# Set excluded paths as comma-delimited strings
# Note: Web applications must end in a trailing slash, where site collections do not
[array]$excludedPaths = "http://applications.domain.lab/", 
                        "http://mysite.domain.lab", 
                        "http://portal.domain.lab/sites/siteA", 
                        “http://portal.domain.lab/search”

# Get all Web applications (except Central Admin)
Get-SPWebApplication | ForEach-Object {
    
    if ($excludedPaths -notcontains $_.Url)
    {
        # Enumerate all content databases in each Web application
        if ($_.ContentDatabases -ne $null) {
            $_.ContentDatabases | ForEach-Object {
            
                # Enumerate all site collections in each content database
                if ($_.Sites -ne $null) {
                    $_.Sites | ForEach-Object {
                        
                        # Check if there are sites where the property should not be changed
                        if ($excludedPaths -notcontains $_.Url)
                        {
                            Write-Host "Changing ReadOnly property for site" $_.Url
                            
                            # Set ReadOnly property
                            $_.ReadOnly = $readOnly
                            Write-Host "ReadOnly property for site" $_.Url "set to" $_.ReadOnly
                            
                            # Dispose site collection object
                            $_.Dispose()
                        }
                        else
                        {
                            # Confirm if no changes made on excluded sites
                            Write-Host "No changes made for site" $_.Url
                        }
                    }
                }
            }
        }
    }
    else
    {
        # Confirm if no changes made on excluded web applications
        Write-Host "No changes made for web application" $_.Url
    }
}
