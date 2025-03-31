function Export-LogicAppDefinition {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $Name,

        [Parameter()]
        [ValidateScript(
            {
                if (Test-Path -Path $_) { $true } else { $false }
            },
            ErrorMessage = "'{0}' is not a valid path."
        )]
        [string]
        $FilePath = (Get-Location),

        [Parameter()]
        [ValidatePattern("\.json$", ErrorMessage = "'{0}' should have a .json file extension.")]
        [string]
        $FileName
    )

    process {
        $logicApp = Get-AzLogicApp -Name $Name

        # Creating process-specific variable so it can be nulled out when executing across multiple pipeline inputs
        $processFileName = $FileName

        # If the LogicApp exists
        if ($logicApp) {
            Write-Verbose -Message "Processing $Name"

            # Creating a process-loop specific variable
            if (-not $processFileName) {
                $processFileName = "$($Name)_$(Get-Date -Format FileDateTimeUniversal).json"
            }

            try {
                Write-Verbose -Message "Exporting Logic App definition to $processFileName."
                $logicApp.Definition.ToString() | Out-File -FilePath "$FilePath\$processFileName" -ErrorAction STOP
                $file = Get-Item -Path "$FilePath\$processFileName"

                $output = [PSCustomObject]@{
                    LogicApp = $logicApp.Name
                    File     = $file.FullName
                }

                $output
            }
            catch {
                $errorMessage = (Get-Error -Newest 1).Exception.Message
                Write-Warning -Message "There was an issue exporting the Logic App definition for $Name : $errorMessage"
            }
            finally {
                $processFileName = $null
            }
        }
        else {
            Write-Warning -Message "No Logic Apps found named $Name. Double check your spelling or current subscription context using Get-AzContext."
        }
    } # End process lbock
}

function Import-LogicAppDefinition {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $Name,

        [Parameter(Mandatory)]
        [string]
        $ResourceGroupName,

        [Parameter(Mandatory)]
        [ValidateScript(
            {
                if (Test-Path -Path $_) { $true } else { $false }
            },
            ErrorMessage = "'{0}' is not a valid path."            
        )]
        [string]
        $FileName
    )
    
    Write-Verbose -Message "Processing $Name"

    try {
        Set-AzLogicApp -Name $Name -ResourceGroupName $ResourceGroupName -DefinitionFilePath $FileName -ErrorAction STOP
    }
    catch {
        $errorMessage = (Get-Error -Newest 1).Exception.Message
        Write-Warning -Message "There was an issue importing the Logic App definition for $name : $errorMessage"
    }    
}

function Get-VnetAddressSpace {
    [CmdletBinding(
        DefaultParameterSetName = "Subscription"
    )]

    param(
        [Parameter(ParameterSetName = "AllSubscriptions")]
        [switch]
        $AllSubscriptions,

        [Parameter(ParameterSetName = "Subscription")]
        [string[]]
        $Subscription,

        [Parameter()]
        [switch]
        $SortByIp
    )

    # Get subscriptions based on parameter set
    $allSubs = if ($AllSubscriptions) {
        Get-AzSubscription -WarningAction SilentlyContinue | Where-Object State -EQ 'Enabled'
    }
    else {
        $Subscription | ForEach-Object { Get-AzSubscription -SubscriptionId $_ -WarningAction SilentlyContinue }
    }

    foreach ($sub in $allSubs) {
        Set-AzContext -SubscriptionObject $sub | Out-Null

        $allVnets = Get-AzVirtualNetwork
        $results = [System.Collections.Generic.List[PSCustomObject]]::new()
        
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

function Export-AllKeyVaultSecrets {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $VaultName,

        [Parameter()]
        [ValidateScript({
                if (Test-Path -Path $_) { return $true }
                else { return $false }
            })]
        [string]
        $OutputPath
    )

    Write-Warning -Message "The target and destination key vaults must use the same subscription and be in an Azure region in the same geography (for example, North America)."

    # Gets current location for file exports if not specified as a parameter
    if ([String]::IsNullOrEmpty($OutputPath)) {
        $OutputPath = Get-Location
    }

    # Verify valid key vault
    $validKeyVault = Get-AzKeyVault -VaultName $VaultName -ErrorAction Stop
    if ([string]::IsNullOrEmpty($validKeyVault)) {
        throw "Key Vault not found or invalid name: $VaultName."
    }

    $allSecrets = Get-AzKeyVaultSecret -VaultName $VaultName

    if ($allSecrets.Count -gt 0) {
        foreach ($secret in $allSecrets) {
            $secretName = $secret.Name

            # Generate timestamp for filename
            $epoch = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
            $microseconds = [math]::Round(([DateTimeOffset]::UtcNow - (Get-Date "1970-01-01T00:00:00Z")).TotalMicroseconds) % 1000000
            $timestamp = "{0}.{1}" -f $epoch, ($microseconds.ToString("000000"))
    
            $fileName = "$OutputPath\\$secretName-$timestamp"
    
            Backup-AzKeyVaultSecret -VaultName $VaultName -Name $secretName -OutputFile $fileName
        }
    }
    else {
        Write-Warning -Message "Key Vault $VaultName does not contain any secrets."
    }
}

function Import-AllKeyVaultSecrets {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $VaultName,

        [Parameter(Mandatory)]
        [ValidateScript({
                if (Test-Path -Path $_) { return $true }
                else { return $false }
            })]
        [string]
        $InputFilePath
    )

    Write-Warning -Message "The target and destination key vaults must use the same subscription and be in an Azure region in the same geography (for example, North America)."

    $validKeyVault = Get-AzKeyVault -VaultName $VaultName -ErrorAction Stop
    if ([string]::IsNullOrEmpty($validKeyVault)) {
        throw "Key Vault not found or invalid name: $VaultName."
    }

    $backupSecretFiles = Get-ChildItem -Path $InputFilePath

    if ($backupSecretFiles.Count -gt 0) {
        foreach ($file in $backupSecretFiles) {
            Restore-AzKeyVaultSecret -VaultName $VaultName -InputFile $file.FullName
        }
    }
    else {
        Write-Warning -Message "No files found in $InputFilePath."
    }
}
