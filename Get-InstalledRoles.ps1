function get-InstalledRoles {
    $srvmanager = Get-Module servermanager -ErrorAction SilentlyContinue
    if (-not $srvmanager) {
        try {
            Import-Module servermanager -ErrorAction Stop -WarningAction SilentlyContinue
            $srvmanager = $true
        }
        catch {
            Write-Output "Unable to Import ServerManager module in powershell"
        }
    }

    if ($srvmanager) {
        try {
            $FeaturesandRoles = Get-WindowsFeature -ErrorAction Stop
            if ($FeaturesandRoles) {
                $installedRoles = $FeaturesandRoles | Where-Object { $_.Installed -and $_.FeatureType -eq "Role" } | Select-Object DisplayName, Name
                if ($installedRoles) {
                    Write-Output "Following Roles installed on $($env:COMPUTERNAME):`n"
                    $installedRoles | ForEach-Object { Write-Output "$($_.DisplayName) ($($_.Name))" }
                }
            }
            else {
                Write-Output "no Features and roles installed"
            }
        }
        catch {
            Write-Output "Unable to fetch windows features and roles"
        }
    }
}
