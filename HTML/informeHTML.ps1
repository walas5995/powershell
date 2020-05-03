$info = Get-ComputerInfo

write-Host $info | select CsName
$resultado = $info | Select CsName,csdomain,OsArchitecture,WindowsProductName | ConvertTo-EnhancedHTMLFragment -As Table -PreContent "<h2>Dynamic Services</h2>" -MakeTableDynamic
#$resultado = $info | select csname,csdomain,WindowsProductName,OsArchitecture | ConvertTo-EnhancedHTMLFragment -As Table -PreContent "<h2> Normal Services</h2>"
ConvertTo-EnhancedHTML -HTMLFragments $resultado -CssUri C:\scripts\style.css | Out-File c:\scripts\informe.html


#Servicios del equipo: Rojo si está parado y Verde si está corriendo
Get-service | Select Name , DisplayName , Status |ConvertTo-Html -Title "Services" -Body "Localhost Service" |
foreach {if($_ -like "*<td>Running</td>*"){$_ -replace "<tr>", "<tr bgcolor=green>"}
elseif($_ -like "*<td>Stopped</td>*"){$_ -replace "<tr>", "<tr bgcolor=red>"}
else{$_}} | Out-File c:\scripts\services.html