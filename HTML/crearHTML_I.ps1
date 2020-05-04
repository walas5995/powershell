#Clear table body to run in over and over in ISE
$TableBody,$StrBody=""

#Grab the files to check and organize them by lastwritetime
$Files = Get-Service
<#
Get-ChildItem "$env:USERPROFILE\desktop\temp" |
Select-Object name,@{name="Size(MB)";expression={ "{0:N0}" -f ($_.Length / 1mb) }} |
Sort-Object 'name'
#>
#Generate custom colored tables based on the last write time of the file
$Files | ForEach-Object {
 
                    
[string]$Var=$_.status

if ($Var -eq "Stopped") {
            $TableBody+="<tr><td>$($_.name)</td><td style =`"border-style:solid;border-color: red`">$($_.status)</td></tr>"
        }else{
            $TableBody+="<tr><td>$($_.name)</td><td style =`"border-style:solid;border-color: orange`">$($_.status)</td></tr>"
        }                            
}

#Place the table into pre-formatted HTML Table
$Body =@"
<div class="container-fluid">
<h1 class="h3 mb-2 text-gray-800">Informe</h1>
<p class="mb-4">Este es un informe generado desde un script de Powershell</p>
<div class="card shadow mb-4">
<div class="card-header py-3">
<h6 class="m-0 font-weight-bold text-primary">Servicios de Windows</h6>
</div>
<div class="card-body">
<div class="table-responsive">
<table  class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
<tr><th>Nombre Servicio</th><th>Estado</th></tr>
<tfoot>
$TableBody
</tfoot>
</table>
</div>
</div>
</div>
</div>
"@

#Creat the CSS style for the entire report
$Head =@"
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
 
"@
# <link href="vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">
#$Head = "<link href='vendor/datatables/dataTables.bootstrap4.min.css' rel='stylesheet'><Style> body {Background-color: lightblue; } table {background-color: white; margin: 5px; float: left; top: 0px; display: inline-block; padding:5px; border: 1px solid black} tr:nth-child(odd) {background-color: lightgray} </style>"

#Cram the body and the Head into completed HTML code
#$HTML = ConvertTo-Html -Body $Body -Head $Head
$HTML = ConvertTo-EnhancedHTML -HTMLFragments $Body -PreContent $Head -CssStyleSheet "" -jQueryDataTableURI "vendor/datatables/dataTables.bootstrap4.min.js" -jQueryURI "vendor/datatables/jquery.dataTables.js"

#Create an HTML file in a temp directory
$HTML | Out-File -filepath "C:\inetpub\wwwroot\vscode\informe_I.html" -Force