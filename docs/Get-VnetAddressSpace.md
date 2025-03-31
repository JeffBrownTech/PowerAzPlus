---
external help file: PowerAzPlus-help.xml
Module Name: PowerAzPlus
online version:
schema: 2.0.0
---

# Get-VnetAddressSpace

## SYNOPSIS
Retrieves the address space of virtual networks (VNets) across one or multiple Azure subscriptions.

## SYNTAX

### Subscription (Default)
```
Get-VnetAddressSpace [-Subscription <String[]>] [-SortByIp] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### AllSubscriptions
```
Get-VnetAddressSpace [-AllSubscriptions] [-SortByIp] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-VnetAddressSpace function retrieves all virtual networks and their associated address spaces in the specified Azure subscriptions. It supports querying a single subscription, multiple subscriptions, or all enabled subscriptions. The output can be sorted by IP address if desired.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-VnetAddressSpace -AllSubscriptions
```

Retrieves the address space of all VNets across all enabled Azure subscriptions.

### Example 2
```powershell
PS C:\> Get-VnetAddressSpace -Subscription "12345678-90ab-cdef-1234-567890abcdef","abcdef12-3456-7890-abcd-ef1234567890" -SortByIp
```

Retrieves the address space of all VNets in the specified subscriptions and sorts the output by IP address.

## PARAMETERS

### -AllSubscriptions
Retrieves VNets from all enabled Azure subscriptions.

```yaml
Type: SwitchParameter
Parameter Sets: AllSubscriptions
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortByIp
Sorts the output based on the numerical value of the first IP address in each address prefix.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subscription
Specifies one or more Azure subscriptions by Subscription ID to retrieve VNets from. If omitted, the default subscription is used.

```yaml
Type: String[]
Parameter Sets: Subscription
Aliases:

Required: False
Position: Named
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
The function sets the subscription context before retrieving VNets.
The `SortByIp` switch converts the first octet of the IP address to an integer for sorting.

## RELATED LINKS
