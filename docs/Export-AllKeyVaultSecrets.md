---
external help file: PowerAzPlus-help.xml
Module Name: PowerAzPlus
online version:
schema: 2.0.0
---

# Export-AllKeyVaultSecrets

## SYNOPSIS
Exports all secrets from an Azure Key Vault and saves them as backup files.

## SYNTAX

```
Export-AllKeyVaultSecrets [-VaultName] <String> [[-OutputPath] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Export-AllKeyVaultSecrets function retrieves all secrets from the specified Azure Key Vault and exports them as backup files. The function ensures the Key Vault exists before proceeding and generates timestamped filenames for each exported secret.

## EXAMPLES

### Example 1
```powershell
PS C:\> Export-AllKeyVaultSecrets -VaultName "MyKeyVault"
```

Exports all secrets from "MyKeyVault" and saves them in the current working directory.

### Example 2
```powersell
PS C:\> Export-AllKeyVaultSecrets -VaultName "MyKeyVault" -OutputPath "C:\Backup\Secrets"
```

Exports all secrets from "MyKeyVault" and saves them in the specified directory.

## PARAMETERS

### -OutputPath
Specifies the directory where the exported secrets will be saved. If not provided, the function uses the current working directory. The provided path must exist.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VaultName
Specifies the name of the Azure Key Vault from which secrets will be exported. This parameter is required.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES
Requires Azure PowerShell (`Az` module).
The target and destination Key Vaults must be in the same subscription and an Azure region within the same geography.
Each exported secret file is named using the format: `<SecretName>-<UnixEpochTimestamp>.<Microseconds>`.
The function checks if the Key Vault exists before proceeding.
If no secrets are found in the Key Vault, a warning message is displayed.

## RELATED LINKS
