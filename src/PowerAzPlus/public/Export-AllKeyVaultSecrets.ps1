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