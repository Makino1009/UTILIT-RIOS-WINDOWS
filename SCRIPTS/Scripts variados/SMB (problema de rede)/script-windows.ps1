# Executar como administrador!
 
Write-Host "Iniciando configuração de serviços e SMB..." -ForegroundColor Cyan
 
# Ativar serviços LanmanWorkstation e LanmanServer
Set-Service -Name LanmanWorkstation -StartupType Automatic
Set-Service -Name LanmanServer -StartupType Automatic
Start-Service -Name LanmanWorkstation
Start-Service -Name LanmanServer
Write-Host "Serviços LanmanWorkstation e LanmanServer ativados." -ForegroundColor Green
 
# Ativar SMBv2 (SMB 2.0 e 3.0 já vêm ativados no Windows 10+ por padrão)
Set-SmbServerConfiguration -EnableSMB2Protocol $true -Force
Write-Host "SMBv2 ativado." -ForegroundColor Green
 
# Opcional: Ativar SMBv1 (não recomendado)
$ativarSMBv1 = Read-Host "Deseja ativar SMBv1 (inseguro)? (s/n)"
if ($ativarSMBv1 -eq "s") {
    Enable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol" -NoRestart
    Write-Host "SMBv1 ativado (atenção: inseguro!)." -ForegroundColor Yellow
} else {
    Write-Host "SMBv1 não será ativado." -ForegroundColor Cyan
}
 
# Corrigir configurações de assinatura SMB no registro
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" -Name "RequireSecuritySignature" -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" -Name "EnableSecuritySignature" -Value 1 -PropertyType DWord -Force
Write-Host "Configurações de assinatura SMB ajustadas." -ForegroundColor Green
 
# Recarregar políticas de grupo (se necessário)
gpupdate /force
 
Write-Host "`nConfiguração concluída. Reinicie o computador se necessário." -ForegroundColor Cyan