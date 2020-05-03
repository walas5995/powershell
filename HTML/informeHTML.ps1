            $info = Get-ComputerInfo

            write-Host $info | select CsName
            $resultado = $info | Select CsName,csdomain,OsArchitecture,WindowsProductName | ConvertTo-EnhancedHTMLFragment -As Table -PreContent "<h2>Dynamic Services</h2>" -MakeTableDynamic

            #$resultado = $info | select csname,csdomain,WindowsProductName,OsArchitecture | ConvertTo-EnhancedHTMLFragment -As Table -PreContent "<h2> Normal Services</h2>"
            write-Host $resultado
            ConvertTo-EnhancedHTML -HTMLFragments $resultado -CssUri C:\scripts\style.css | Out-File c:\scripts\informe.html