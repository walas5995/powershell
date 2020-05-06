import-module EnhancedHTML2 -Force  
$TableBody,$StrBody=""
$Files = Get-Service | Select-Object name,Status -First 5
$Header = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">  
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<link href="http://localhost/vscode/vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet" type="text/css">
<title>SB Admin 2 - Tables</title>

<!-- Custom fonts for this template -->
<link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
<link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">
<!-- Custom styles for this template -->
<link href="css/sb-admin-2.min.css" rel="stylesheet">
</head>

"@
$precontenido = @"

<body id="page-top">
<div class='container-fluid'>
<h1 class='h3 mb-2 text-gray-800'>Informe</h1>
<p class='mb-4'>Este es un informe generado desde un script de Powershell</p>
<div class='card shadow mb-4'>
<div class='card-header py-3'>
<h6 class='m-0 font-weight-bold text-primary'>Servicios de Windows</h6>
</div>
<div class='card-body'>
<div class='table-responsive'>
"@
$TableBody+=$Header
$TableBody+=$precontenido

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
$parametros=@{'Properties'=@{n='Nombre';e={$_.name}},@{n='Estado';e={$_.status};css={if($_.status -eq 'Running'){'green'}else{'red'}}}}
$TableBody += $files | ConvertTo-EnhancedHTMLFragment @parametros -as Table -TableCssID "dataTable" -TableCssClass "table table-bordered" -MakeTableDynamic

$postcontenido=@"
</div>
</div>
</div>
</div>
</body>
</html>
"@
$TableBody+=$postcontenido

$TableBody | Out-File -filepath "C:\inetpub\wwwroot\vscode\informe_I.html" -Force