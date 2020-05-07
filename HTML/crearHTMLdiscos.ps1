import-module EnhancedHTML2 -Force
. .\html\cuerpoHTML.ps1  
$TableBody,$StrBody=""

$partitions= Get-WmiObject -Class Win32_LogicalDisk -Filter 'DriveType = 3' |
Select-Object PSComputerName, Caption,@{N='Capacity_GB'; E={[math]::Round(($_.Size / 1GB), 2)}},@{N='FreeSpace_GB'; E={[math]::Round(($_.FreeSpace / 1GB), 2)}},@{N='PercentUsed'; E={[math]::Round(((($_.Size - $_.FreeSpace) / $_.Size) * 100), 2) }},@{N='PercentFree'; E={[math]::Round((($_.FreeSpace / $_.Size) * 100), 2) }}

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
<h1 class="h3 mb-2 text-gray-800">Espacio en disco</h1>
<p class="mb-4"> Mostramos un listado de todos los porcentajes de espacio en disco ocupado</a>.</p>

<!-- DataTales Example -->
<div class="card shadow mb-4">
<div class="card-header py-3">
<h6 class="m-0 font-weight-bold text-primary">$pc</h6>
</div>
<div class="card-body">
<div class="table-responsive">
"@
$TableBody+=$cabecera

foreach($z in $partitions)
{  
    $task1=@"
<div class="col-xl-3 col-md-4 mb-4">
              <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                      <div class="h4 font-weight-bold text-info text-uppercase mb-1">$($z.Caption)</div>
                      <div class="row no-gutters align-items-center">
                        <div class="col-auto">
                          <div class="h5 mb-0 mr-3 font-weight-bold text-gray-800">$($z.PercentUsed)%</div>
                        </div>
                        <div class="col">
                          <div class="progress progress-sm mr-2">
                            <div class="progress-bar bg-info" role="progressbar" style="width: $($z.PercentUsed)%" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100"></div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
"@
    <#
    $TableBody+="<p>Particion         : $($z.Caption)</p>" ;    
    $TableBody+="<p>Capacidad Total   : $($z.Capacity_GB)  GB</p>" ;    
    $TableBody+="<p>Espacio Libre     : $($z.FreeSpace_GB) GB</p>" ;    
    $TableBody+="<p>Porcentaje Usado  : $($z.PercentUsed)  %</p>" ;    
    $TableBody+="<p>Porcentaje Libre  : $($z.PercentFree)  %</p>" ;   
    $TableBody+="<p>.";
    #>   
    $TableBody+=$task1
}



#$parametros=@{'Properties'=@{n='Nombre';e={$_.name}},@{n='Estado';e={$_.status};css={if($_.status -eq 'Running'){'green'}else{'red'}}}}
#$TableBody += $files | ConvertTo-EnhancedHTMLFragment @parametros -as Table -TableCssID "dataTable" -TableCssClass "table table-bordered" -MakeTableDynamic


$TableBody | Out-File -Encoding utf8 -filepath "C:\inetpub\wwwroot\discos.html" -Force