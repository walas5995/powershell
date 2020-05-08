import-module EnhancedHTML2 -Force
. .\html\cuerpoHTML.ps1  
$TableBody,$StrBody=""
$Files = Get-Service | Select-Object Name,DisplayName,Status -First 5
$domainController = get-service -Name NTDS,ADWS,DNS,DNSCache,KDC,W32Time,NetLogon,DHCP,KDC

$TableBody+=$bootstrap
#$TableBody+=$precontenido
<#
$Files | ForEach-Object {                
  [string]$Var=$_.status
  if ($Var -eq "Stopped") {
              $TableBody+="<tr><td>$($_.name)</td><td style=`"border-style:solid;border-color: red`">$($_.status)</td></tr>"
          }else{
              $TableBody+="<tr><td>$($_.name)</td><td style =`"border-style:solid;border-color: orange`">$($_.status)</td></tr>"
          }                            
  }
#>
$pc="WS2019"
$cabecera=@"
<!-- Begin Page Content -->
<div class="container-fluid">

<!-- Page Heading -->
<h1 class="h3 mb-2 text-gray-800">Servicios</h1>
<p class="mb-4"> Mostramos un listado de todos los servicios de windows</a>.</p>

<!-- DataTales Example -->
<div class="card shadow mb-4">
<div class="card-header py-3">
<h6 class="m-0 font-weight-bold text-primary">$pc</h6>
</div>
<div class="card-body">
<div class="table-responsive">
"@
$TableBody+=$cabecera
$parametros=@{'Properties'=@{n='Nombre';e={$_.name}},@{n='Estado';e={$_.status};css={if($_.status -eq 'Running'){'green'}else{'red'}}}}
$TableBody += $files | ConvertTo-EnhancedHTMLFragment @parametros -as Table -TableCssID "dataTable" -TableCssClass "table table-bordered" -MakeTableDynamic
$TableBody+=$postcontenido

$TableBody | Out-File -Encoding utf8 -filepath "C:\inetpub\wwwroot\servicios.html" -Force