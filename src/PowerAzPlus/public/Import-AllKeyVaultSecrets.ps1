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