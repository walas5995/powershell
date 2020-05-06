#$info = Get-Service

#write-Host $info | select CsName
#$resultado = $info | Select CsName,csdomain,OsArchitecture,WindowsProductName | ConvertTo-EnhancedHTMLFragment -As Table -PreContent "<h2>Dynamic Services</h2>" -MakeTableDynamic
Import-Module -Name EnhancedHTML2
$fragment = Get-WmiObject -Class Win32_LogicalDisk |
Select-Object -Property PSComputerName,DeviceID,FreeSpace,Size | ConvertTo-EnhancedHTMLFragment -As Table -MakeTableDynamic |
Out-File c:\scripts\informe.html


#Servicios del equipo: Rojo si está parado y Verde si está corriendo
<#
Get-service | Select Name , DisplayName , Status |ConvertTo-Html -Title "Services" -Body "Localhost Service" |
foreach {if($_ -like "*<td>Running</td>*"){$_ -replace "<tr>", "<tr bgcolor=green>"}
elseif($_ -like "*<td>Stopped</td>*"){$_ -replace "<tr>", "<tr bgcolor=red>"}
else{$_}} | Out-File c:\scripts\services.html


Get-service | Select Name , DisplayName , Status |ConvertTo-Html -Title "Services" -Body "Localhost Service" |
Out-File c:\scripts\services.html
#>