$dominio = "SADA"
#Lista de todos los controladores de dominio
nltest /dclist:$dominio | Format-List
#Controlador de dominio que funciona como PDC
nltest /dcname:$dominio
#Obternet nombre e IP del servidor que tiene el ROL indicado
nltest /dsgetdc:$dominio /PDC
#/PDC /DS /DSP /GC /KDC /TIMESERV /GTIMESERV /WS /NETBIOS /DNS /IP /FORCE /WRITABLE /AVOIDSELF /LDAPONLY /BACKG /DS_6 /DS_8 /DS_9 /DS_10
#Información del controlador de dominio consultado
Get-ADDomainController -Server ws2019
#Obtener nombre del servidor que tiene el Rol especificado
#Valores admitidos:PrimaryDC, GlobalCatalog, KDC, TimeService, ReliableTimeService, ADWS"
Get-ADDomainController -discover -Service "PrimaryDC" | select -ExpandProperty name
Get-ADDomainController -discover -Service "GlobalCatalog" | select -ExpandProperty name
Get-ADDomainController -discover -Service "KDC" | select -ExpandProperty name
Get-ADDomainController -discover -Service "TimeService" | select -ExpandProperty name
Get-ADDomainController -discover -Service "ADWS" | select -ExpandProperty name
Get-ADDomainController -discover -Service "ReliableTimeService" | select -ExpandProperty name
