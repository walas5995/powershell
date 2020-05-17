#$limit = (Get-Date).AddDays(-15)


#Archivos temporales - Windows 7 en adelante
$dir1 = $env:windir+"\Temp"
#Archivos temporales - Internet Explorer
$dir2 = $env:USERPROFILE + "\AppData\Local\Microsoft\Windows\Temporary Internet Files"
Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty version
#Archivos temporales - Chrome
$dir3 = $env:USERPROFILE + "\AppData\Local\Google\Chrome\User Data\Default\Cache"
#Arhivos temporales - Usuario
$dir4 = $env:TEMP

#Direcciones
$path=$dir1,$dir2,$dir3,$dir4


foreach($dir in $path) {
    try {
        #Get-ChildItem -Path $path -Recurse | Remove-Item -Force
    }
    catch {
        "Se ha producido un error"+$_ 
    }
}
