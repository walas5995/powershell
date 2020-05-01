function hostname{
$env:COMPUTERNAME
}

#Prueba Pester para comprobar el script

Describe "Test Pester" {
    It "El nombre de equipo es correcto"{
        hostname | Should -Be "WS2019"
    }
}