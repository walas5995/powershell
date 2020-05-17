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
