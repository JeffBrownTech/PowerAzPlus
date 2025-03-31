---
external help file: PowerAzPlus-help.xml
Module Name: PowerAzPlus
online version:
schema: 2.0.0
---

# Import-AllKeyVaultSecrets

## SYNOPSIS
Imports all Key Vault secrets from backup files into a specified Azure Key Vault.

## SYNTAX

```
Import-AllKeyVaultSecrets [-VaultName] <String> [-InputFilePath] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Import-AllKeyVaultSecrets function restores all Key Vault secrets from backup files stored in a specified directory. It ensures that the target Key Vault exists before proceeding. The function processes all backup files in the provided directory and restores them to the specified Key Vault.

## EXAMPLES

### Example 1
```powershell
PS C:\> Import-AllKeyVaultSecrets -VaultName "MyKeyVault" -InputFilePath "C:\Backup\Secrets"
```

Restores all secrets from the specified directory to the "MyKeyVault" Key Vault.

## PARAMETERS

### -InputFilePath
Specifies the directory containing the backup files to be restored. This parameter is required and must be a valid path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VaultName
Specifies the name of the Azure Key Vault where secrets will be imported. This parameter is required.

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
The function verifies that the Key Vault exists before proceeding.
If no backup files are found in the specified directory, a warning message is displayed.

## RELATED LINKS
