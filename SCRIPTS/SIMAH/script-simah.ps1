# Caminho da pasta alvo
$folderPath = "C:\Windows\SysWOW64"

Write-Host "Iniciando processo para assumir posse da pasta $folderPath..." -ForegroundColor Cyan

# TAKEOWN: assume a posse da pasta e arquivos
takeown /F $folderPath /A /R /D Y

Write-Host "Posse assumida com sucesso." -ForegroundColor Green

# ICACLS: concede permissões totais ao grupo Administradores
icacls $folderPath /grant Administradores:F /T

Write-Host "Permissões concedidas ao grupo Administradores." -ForegroundColor Green

Write-Host "Concluído! Você agora tem acesso total à pasta $folderPath." -ForegroundColor Yellow 

# Caminho da pasta alvo
$folderPath = "C:\Windows\System32"

Write-Host "Iniciando processo para assumir posse da pasta $folderPath..." -ForegroundColor Cyan

# TAKEOWN: assume a posse da pasta e arquivos
takeown /F $folderPath /A /R /D Y

Write-Host "Posse assumida com sucesso." -ForegroundColor Green

# ICACLS: concede permissões totais ao grupo Administradores
icacls $folderPath /grant Administradores:F /T

Write-Host "Permissões concedidas ao grupo Administradores." -ForegroundColor Green

Write-Host "Concluído! Você agora tem acesso total à pasta $folderPath." -ForegroundColor Yellow 


# Caminhos de destino
$system32 = "$env:windir\System32"
$syswow64 = "$env:windir\SysWOW64"

# Lista de arquivos
$arquivos = @(
    "MSWINSCK.DEP",
    "SCRRUN.DEP",
    "MSWlNSCK.oca",
    "SSTree.oca",
    "MSWINSCK.OCX",
    "SSTree.ocx",
    "lbOleDb.dll",
    "scrrun.dll",
    "SSubTmr6.dll"
)

# Enviar para System32
foreach ($arquivo in $arquivos) {
    $source = Join-Path -Path (Get-Location) -ChildPath $arquivo
    $destino1 = Join-Path -Path $system32 -ChildPath $arquivo
    $destino2 = Join-Path -Path $syswow64 -ChildPath $arquivo
    Copy-Item -Path $source -Destination $destino1 -Force
    Copy-Item -Path $source -Destination $destino2 -Force
}
Write-Host "Arquivos enviados com sucesso!"