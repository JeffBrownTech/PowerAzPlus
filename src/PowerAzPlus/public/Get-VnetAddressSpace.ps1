function Get-VnetAddressSpace {
    [CmdletBinding(
        DefaultParameterSetName = "SubscriptionId"
    )]

    param(
        [Parameter(ParameterSetName = "AllSubscriptions")]
        [switch]
        $AllSubscriptions,

        [Parameter(ParameterSetName = "SubscriptionId")]
        [string[]]
        $SubscriptionId,

        [Parameter(ParameterSetName = "SubscriptionName")]
        [string[]]
        $SubscriptionName,

        [Parameter()]
        [switch]
        $SortByIp
    )

    # Get subscriptions based on parameter set
    $allSubs = if ($PSCmdlet.ParameterSetName -eq "AllSubscriptions") {
        Get-AzSubscription -WarningAction SilentlyContinue | Where-Object State -EQ 'Enabled'
    }
    elseif ($PSCmdlet.ParameterSetName -eq "SubscriptionId") {
        $SubscriptionId | ForEach-Object { Get-AzSubscription -SubscriptionId $_ -WarningAction SilentlyContinue }
    }
    elseif ($PSCmdlet.ParameterSetName -eq "SubscriptionName") {
        $SubscriptionName | ForEach-Object { Get-AzSubscription -SubscriptionName $_ -WarningAction SilentlyContinue }
    }
    else {
        (Get-AzContext).Subscription.Id
    }

    $results = [System.Collections.Generic.List[PSCustomObject]]::new()

    foreach ($sub in $allSubs) {
        Set-AzContext -SubscriptionObject $sub -WarningAction SilentlyContinue | Out-Null

        $allVnets = Get-AzVirtualNetwork        
        
        foreach ($vnet in $allVnets) {
            $addressSpace = $vnet.AddressSpaceText
            $allPrefixes = ($addressSpace | ConvertFrom-Json).AddressPrefixes

            foreach ($prefix in $allPrefixes) {
                $baseAddress, $cidr = $prefix.Split('/')
                $octets = $baseAddress -split '\.'
                
                # Convert IP to an integer for sorting
                $octetInteger = ([int]$octets[0] * 16777216) + # 256^3
                                ([int]$octets[1] * 65536) + # 256^2
                                ([int]$octets[2] * 256) + # 256^1
                                ([int]$octets[3]) # 256^0

                $results.Add(
                    [PSCustomObject]@{
                        PSTypeName       = "VnetObjectSortable"
                        VnetName         = $vnet.Name
                        SubscriptionName = $sub.Name
                        SubscriptionId   = $sub.Id
                        ResourceGroup    = $vnet.ResourceGroupName
                        Location         = $vnet.Location
                        AddressPrefix    = $prefix
                        CIDR             = $cidr
                        IPAddressInteger = $octetInteger
                    }
                ) | Out-Null # Suppress output of .Add() to console                
            }
        }
    }

    # Sort results if the SortByIP switch is used
    if ($SortByIP) {
        $results = $results | Sort-Object IPAddressInteger
    }

    $results
}