$dominioAtual = (Get-WmiObject Win32_ComputerSystem).Domain

if ($dominioAtual -eq "aoc.local") {
    Write-Host "Você está no domínio aoc.local"
} else {
    Write-Host "Você não está no domínio. Você está em $dominioAtual"
}

Read-Host "Pressione Enter para sair..."
