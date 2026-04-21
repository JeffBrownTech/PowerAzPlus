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