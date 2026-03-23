# Instala WinRAR
Write-Host "Instalando WinRAR..."
winget install --id RARLab.WinRAR -e --accept-package-agreements --accept-source-agreements
Write-Host "WinRAR instalado."

# Instala AnyDesk
Write-Host "Instalando AnyDesk..."
winget install --id AnyDeskSoftwareGmbH.AnyDesk -e --accept-package-agreements --accept-source-agreements
Write-Host "AnyDesk instalado."

# Instala Microsoft Teams
Write-Host "Instalando Microsoft Teams..."
winget install --id Microsoft.Teams -e --accept-package-agreements --accept-source-agreements
Write-Host "Microsoft Teams instalado."

# Aguarda uma entrada do usuário antes de fechar
Read-Host -Prompt "Pressione Enter para sair"
