---
external help file: PowerAzPlus-help.xml
Module Name: PowerAzPlus
online version:
schema: 2.0.0
---

# Export-LogicAppDefinition

## SYNOPSIS
Exports the definition of an Azure Logic App to a JSON file.

## SYNTAX

```
Export-LogicAppDefinition [-Name] <String> [[-FilePath] <String>] [[-FileName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The `Export-LogicAppDefinition` function retrieves the definition of a specified Azure Logic App and saves it as a JSON file to the specified file path. If the `FileName` parameter is not provided, a default name is generated based on the Logic App name and the current date/time.

## EXAMPLES

### Example 1
```powershell
Export-LogicAppDefinition -Name "MyLogicApp" -FilePath "C:\Exports" -FileName "MyLogicApp.json"
```

This example exports the definition of the Logic App named "MyLogicApp" to the file `C:\Exports\MyLogicApp.json`.

### Example 2: Exporting all Logic Apps in a Subscription
```powershell
Get-AzLogicApp | Export-LogicAppDefinition -FilePath "C:\Exports"
```

This example exports the definitions of all Logic Apps in the current Azure subscription to the `C:\Exports` directory. File names are automatically generated.

## PARAMETERS

### -Name
Specifies the name of the Logic App to export. This parameter accepts input from the pipeline and by property name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -FilePath
Specifies the directory path where the exported JSON file will be saved. If not provided, the current working directory is used by default.

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

### -FileName
Specifies the name of the JSON file to be created. If not provided, a name will be generated in the format `<LogicAppName>_<Timestamp>.json`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
