function crearHTML{
    param (
        [Parameter(Mandatory = $True, Position = 1)]
        $info
    )
    <#
    $Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@
#>
#region CSS
$Header = @"
<style>
table{

}
.enhancedhtml-dynamic-table{
    background-color: #333;
	color: white;
	padding: 25px;  
}
h2{
    text-align: center;
}
thead{
    background-color:#333;
    color:white;
    text-align:left;
    vertical-align:bottom;
}
</style>
"@
#endregion
    import-module EnhancedHTML2 -Force 
    $resultado = $info | ConvertTo-EnhancedHTMLFragment -As Table -PreContent "<h2>Informe Walas</h2>" -MakeTableDynamic
    #-CssStyleSheet  $Header  -CssUri .\style.css
    ConvertTo-EnhancedHTML -HTMLFragments $resultado -CssStyleSheet $Header | Out-File c:\scripts\informe.html
}

$info = Get-Service
crearhtml $info