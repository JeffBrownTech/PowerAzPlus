function Export-LogicAppDefinition {
    <#
        .SYNOPSIS
        Exports the definition of an Azure Logic App to a JSON file.

        .DESCRIPTION
        The `Export-LogicAppDefinition` function retrieves the definition of a specified Azure Logic App and saves it as a JSON file to the specified file path.
        If the `FileName` parameter is not provided, a default name is generated based on the Logic App name and the current date/time.

        .PARAMETER Name
        Specifies the name of the Logic App to export. This parameter accepts input from the pipeline and by property name.

        .PARAMETER FilePath
        Specifies the directory path where the exported JSON file will be saved. If not provided, the current working directory is used by default.

        .PARAMETER FileName
        Specifies the name of the JSON file to be created. If not provided, a name will be generated in the format `<LogicAppName>_<Timestamp>.json`.

        .EXAMPLE
        Export-LogicAppDefinition -Name "MyLogicApp" -FilePath "C:\Exports" -FileName "MyLogicApp.json"

        This example exports the definition of the Logic App named "MyLogicApp" to the file `C:\Exports\MyLogicApp.json`.

        .EXAMPLE
        Get-AzLogicApp | Export-LogicAppDefinition -FilePath "C:\Exports"

        This example exports the definitions of all Logic Apps in the current Azure subscription to the `C:\Exports` directory. File names are automatically generated.

        .INPUTS
        [string]
        Accepts the name of the Logic App as a string input, either through direct parameter input or the pipeline.

        .OUTPUTS
        [PSCustomObject]
        Returns a custom object containing the name of the Logic App and the full path of the exported JSON file.

        .LINK
        https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)] # ValueFromPipeline and ValueFromPipelineByPropertyName allow processing input objects through the pipeline
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

    # Process blocks automatically loop through any input objects coming through the pipeline
    process {
        $logicApp = Get-AzLogicApp -Name $Name

        # Creating process-specific variable so it can be nulled out when executing across multiple pipeline inputs
        $processFileName = $FileName

        # If the LogicApp exists
        if ($logicApp) {
            # Using Write methods to output to console
            Write-Verbose -Message "Processing $Name"

            # Creating a process-loop specific variable
            if (-not $processFileName) {
                $processFileName = "$($Name)_$(Get-Date -Format FileDateTimeUniversal).json"
            }

            # try/catch/finally block for error handling
            try {
                Write-Verbose -Message "Exporting Logic App definition to $processFileName."
                $logicApp.Definition.ToString() | Out-File -FilePath "$FilePath\$processFileName" -ErrorAction STOP
                $file = Get-Item -Path "$FilePath\$processFileName"

                # Creating a custom object to output what the function did
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
                # Finally blocks always execute whether or not an error occurred. In this case, nulling out a variable.
                $processFileName = $null
            }
        }
        # If the LogicApp does not exist
        else {
            Write-Warning -Message "No Logic Apps found named $Name. Double check your spelling or current subscription context using Get-AzContext."
        }
    } # End process lbock
}
