$pwd = Get-Content "c:\scripts\password_crear_bd.txt" | ConvertTo-SecureString
$cred = New-Object System.Management.Automation.PSCredential("sa",$pwd)
$bd_existe = Get-SqlDatabase -ServerInstance ".\sqlexpress" -Credential $cred | where {$_.name -eq "BD_Test"}

if ($bd_existe){
Write-Host("Existe la BD 'BD_Test'")
}else{
Write-Host("No existe y la creamos")
#Creamos BD en el servidor
Invoke-Sqlcmd -ServerInstance ".\sqlexpress" -Query "CREATE DATABASE BD_Test"
}


#Ejecutar Consulta
Invoke-Sqlcmd -ServerInstance ".\sqlexpress" -Query "select * from BD_Test.dbo.personal"

#backup de la base de datos
$carpeta = Get-ChildItem -Path "c:\" | where {$_.name -eq "backup"}

if($carpeta){
Write-Host("la carpeta ya existe")
Backup-SqlDatabase -BackupFile "c:\backup\BD_Test_backup.bak" -ServerInstance ".\sqlexpress" -Database "BD_Test" -Credential $cred
Write-Host("Realizamos una copia")
}else{
Write-Host("La carpeta no existe")
mkdir c:\backup
Write-Host("Creamos la carpeta")
Backup-SqlDatabase -BackupFile "c:\backup\BD_Test_backup.bak" -ServerInstance ".\sqlexpress" -Database "BD_Test" -Credential $cred
Write-Host("Realizamos una copia")
}

#borrar una linea
Invoke-Sqlcmd -ServerInstance ".\sqlexpress" -Query "delete from BD_Test.dbo.personal where id='2'"

#restore BD 
Restore-SqlDatabase -BackupFile "c:\backup\BD_Test_backup.bak" -ServerInstance ".\sqlexpress" -Database "BD_Test" -Credential $cred
