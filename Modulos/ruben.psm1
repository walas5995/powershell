<#
Módulo de PowerShell
Creado por "Rubén Valeiro"

Indice de funciones:

1-Connection
2-Remote
3-ObtenerPwdMail
4-ObtenerPwdBD
5-Enviar_mail
6-CarpetaBBD
7-BackupBD
#>

#Función habilitar el escritorio remoto
function connection{
    
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
    [ValidateSet('deny','permit')]
    [Parameter(Mandatory=$True,HelpMessage="¿Quieres permitir el acceso remoto a este equipo? 'deny' o 'permit'",Position=1)]
    [string]$status
    )
    
    if ($status -eq "deny"){
    #Activar o Desactivar el Firewalle de Windows
    set-netfirewallprofile -Profile Private -Enabled true
    #Habilitar Terminal Server en el registro de Windows
    Set-Itemproperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name 'fDenyTSConnections' -value '1'
    Write-host "****** Firewall - Activado *** Terminal Server - Desactivado ******"
    }else{
        if($status -eq "permit"){
        set-netfirewallprofile -Profile Private -Enabled false
        Set-Itemproperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name 'fDenyTSConnections' -value '0'
        Write-host "****** Firewall - Desactivado *** Terminal Server - Activado ******"
        }else{
        Write-host "****** No se realizó ningun cambio ******"
        Write-host "******* Utilice 'deny' o 'permit' *******"
        }
        }
}
#Función para crear una conexión remota de powershell
function remote{
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
            [Parameter(Mandatory=$True,Position=1)]
            [string]$servidor,
            [Parameter(Mandatory=$True,Position=2)]
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
    if($archicoPWD){
        $password = Get-Content "c:\scripts\password_correo.txt" | ConvertTo-SecureString 
    
    }else{
        if($carpetaPWD){
            (Get-Credential).Password | ConvertFrom-SecureString | Out-File C:\scripts\password_correo.txt
            $password = Get-Content "c:\scripts\password_correo.txt" | ConvertTo-SecureString 
    
        }else{
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
    if($archicoPWD){
        $password = Get-Content "c:\scripts\password_BD.txt" | ConvertTo-SecureString 
    
    }else{
        if($carpetaPWD){
            (Get-Credential).Password | ConvertFrom-SecureString | Out-File C:\scripts\password_BD.txt
            $password = Get-Content "c:\scripts\password_BD.txt" | ConvertTo-SecureString 
    
        }else{
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
        [Parameter(Mandatory=$True,Position=1)]
        [string]$asunto,
        [Parameter(Mandatory=$True,Position=2)]
        [string]$descrip
    )
    $password = ObtenerPwdMail

    $rmail= "walas5995@gmail.com" 
    $email="incidenciasvsm@gmail.com"
    $servermail="smtp.gmail.com"
    $puerto="587"
    $cred = New-Object System.Management.Automation.PsCredential("incidenciasvsm@gmail.com",$password)
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
        if($carpetaPWD){
        #la carpeta existe !!!
        }else{
            mkdir C:\backupBD
        }
}
#Función que guarda una copia de seguridad de la BD que le indiquemos
function backupBD(){
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
            [Parameter(Mandatory=$True,Position=1)]
            [string]$instanceDB,
            [Parameter(Mandatory=$True,Position=2)]
            [string]$nameDB
        )
        $pwd = ObtenerPwdBD
        carpetaBBD
        $cred = New-Object System.Management.Automation.PSCredential("sa",$pwd)
        #Ejecutar Consulta
        #Invoke-Sqlcmd -ServerInstance ".\sqlexpress" -Query "select * from BD_Test.dbo.personal"
        
        #backup de la base de datos
        #InstanceDB (default) --> ".\sqlexpress"
        $carpeta = "c:\backupBD"
        $fecha = Get-Date -UFormat "%Y%m%d"
        $archivo= "c:\backupBD\"+$nameDB+"_"+$fecha+".bak"

        Backup-SqlDatabase -BackupFile $archivo -ServerInstance $instanceDB -Database $nameDB -Credential $cred


}
   
    
