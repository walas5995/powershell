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
<meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>SB Admin 2 - Tables</title>

  <!-- Custom fonts for this template -->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="css/sb-admin-2.min.css" rel="stylesheet">

  <!-- Custom styles for this page -->
  <link href="vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">
"@
$body = @"
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
$footer=@"
</div>
</div>
</div>
</div>
"@
#endregion
    import-module EnhancedHTML2 -Force 
    $resultado = $info | ConvertTo-HTML -Head $Header -
    $resultado | Out-File C:\inetpub\wwwroot\vscode\informe.html
}

$info = Get-Service | select name,status
crearhtml $info