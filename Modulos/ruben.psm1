<#
Módulo con cuatro funciones
1-Connection
2-Remote
3-ObtenerPwdMail
4-Enviar_mail
#>
function connection{
    
    <#

    .SYNOPSIS
    Funcion para habilitar el escritorio remoto en un servidor
    .DESCRIPTION
    Solo se permiten los parametros "deny" o "permit"
    .EXAMPLE
    conenction deny
    .EXAMPLE
    connection permit
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
    # ****************** Funciona - Iniciar Sesión remota ******************+
function remote{
    <#
    .SYNOPSIS
    Función para abrir una conexión "PSSession" remota
    .DESCRIPTION
    Se envia un email con el texto personalizado para el Asunto y la descripción
    .EXAMPLE
    remote "nombre_servidor" "nombre_usuario"
    #>
        param (
            [Parameter(Mandatory=$True,Position=1)]
            [string]$servidor,
            [Parameter(Mandatory=$True,Position=2)]
            [string]$usuario
        )
        Set-Item WSMan:\localhost\Client\TrustedHosts -Value *
        enter-pssession -ComputerName $servidor -Credential $usuario
G}
    #Funcion enviar
function ObtenerPwdMail () {
    <#
    .SYNOPSIS
    Función para obtener la contraseña del correo electrónico
    .DESCRIPTION
    Comprueba que exista tanto la carpeta como el archivo "TXT" que contiene la contraseña
    #>
    $carpetaPWD = Get-Item C:\scripts
    $archicoPWD = Get-ChildItem -Path "C:\scripts\password_correo.txt"
    if($archicoPWD){
        $password = Get-Content "c:\scripts\password_correo.txt" | ConvertTo-SecureString 
    
    }else{
        if($carpetaPWD){
            (Get-Credential).Password | ConvertFrom-SecureString | Set-Content C:\scripts\password_correo.txt
            $password = Get-Content "c:\scripts\password_correo.txt" | ConvertTo-SecureString 
    
        }else{
            mkdir C:\scripts
            (Get-Credential).Password | ConvertFrom-SecureString | Set-Content C:\scripts\password_correo.txt
            $password = Get-Content "c:\scripts\password_correo.txt" | ConvertTo-SecureString 
    
        }
    }
    Return $password  
}
function enviar_mail ($asunto,$descrip) {

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

    $password = ObtenerPwdMail

    $rmail= "walas5995@gmail.com" 
    $email="incidenciasvsm@gmail.com"
    $servermail="smtp.gmail.com"
    $puerto="587"
    $cred = New-Object System.Management.Automation.PsCredential("incidenciasvsm@gmail.com",$password)
    Send-MailMessage -To $rmail -Subject $asunto -body $descrip -from $email -SmtpServer $servermail -Port $puerto -Credential $cred -usessl       
    
   
    }
