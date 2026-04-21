$privateFunctions = Get-ChildItem -Path (Join-Path $PSScriptRoot 'Private') -Filter *.ps1 -ErrorAction SilentlyContinue
$publicFunctions = Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public') -Filter *.ps1 -ErrorAction SilentlyContinue

foreach ($file in @($privateFunctions) + @($publicFunctions)) {
    . $file.FullName
}

Export-ModuleMember -Function $publicFunctions.BaseName