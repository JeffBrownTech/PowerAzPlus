---
external help file: PowerAzPlus-help.xml
Module Name: PowerAzPlus
online version:
schema: 2.0.0
---

# Import-LogicAppDefinition

## SYNOPSIS
Imnports the definition of an Azure Logic App from a JSON file.

## SYNTAX

```
Import-LogicAppDefinition [-Name] <String> [-ResourceGroupName] <String> [-FileName] <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Export-LogicAppDefinition\` function imports the definition from a JSON and overwrites an existing Logic Apps' workflow definition.
The Logic App Name and Resource Group must be specific.

## EXAMPLES

### Example 1
```
Import-LogicAppDefinition -Name mylogicapp -Resource logicapps-rg -File C:\backup\mylogicapp-export.json
```

This example imports the definition found in C:\backup\mylogicapp-export.json to the Logic App named "mylogicapp".

## PARAMETERS

### -Name
Specifies the name of the Logic App to import the workflow definition to.

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

### -ResourceGroupName
Specifies the resource group name where the Logic App resides.

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

### -FileName
Specifies the file name of the JSON file to import.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

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

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
