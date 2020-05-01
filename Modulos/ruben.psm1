function connection{
    
    .SYNOPSYS
    Descripción de la función
    .DESCRIPTION
    Esta es la descripción
    .EXAMPLE
    Primer ejemplo 1
    .EXAMPLE
    Segundo ejemplo 2
    
    
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
        param (
            [Parameter(Mandatory=$True,Position=1)]
            [string]$servidor,
            [Parameter(Mandatory=$True,Position=2)]
            [string]$usuario
        )
        Set-Item WSMan:\localhost\Client\TrustedHosts -Value *
        enter-pssession -ComputerName $servidor -Credential $usuario
    }
    function enviar_mail ($txt) {
        $rmail= "walas5995@gmail.com" 
        $email="incidenciasvsm@gmail.com"
        $asunto="Test"
        $servermail="smtp.gmail.com"
        $puerto="587"
        $password = Get-Content "c:\script\password.txt" | ConvertTo-SecureString 
        $cred = New-Object System.Management.Automation.PsCredential("incidenciasvsm@gmail.com",$password)
        Send-MailMessage -To $rmail -Subject $asunto -body $txt -from $email -SmtpServer $servermail -Port $puerto -Credential $cred -usessl   
    }