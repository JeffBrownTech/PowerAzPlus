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

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
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
