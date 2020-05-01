function enviar_mail ($txt) {
    $rmail= "walas5995@gmail.com" 
    $email="incidenciasvsm@gmail.com"
    $asunto="Test"
    $servermail="smtp.gmail.com"
    $puerto="587"
    $password = Get-Content ".\password.txt" | ConvertTo-SecureString 
    $cred = New-Object System.Management.Automation.PsCredential("incidenciasvsm@gmail.com",$password)
    Send-MailMessage -To $rmail -Subject $asunto -body $txt -from $email -SmtpServer $servermail -Port $puerto -Credential $cred -usessl   
}
