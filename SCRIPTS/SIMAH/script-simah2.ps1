

# Caminhos de destino
$system32 = "$env:windir\System32"
$syswow64 = "$env:windir\SysWOW64"

# Lista de arquivos para substituir. Mude de acordo com a sua necessidade.
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

# Lista de arquivos para substituir (deixe a lista de cima e a de baixo sincronizadas). Mude de acordo com a sua necessidade.


cd C:\Windows\System32


Regsvr32 lbOleDb.dll
Regsvr32 MSWINSCK.DEP
Regsvr32 MSWlNSCK.oca
Regsvr32 MSWINSCK.OCX
Regsvr32 SCRRUN.DEP
Regsvr32 scrrun.dll
Regsvr32 SSTree.oca
Regsvr32 SSTree.ocx
Regsvr32 SSubTmr6.dll

cd..
cd C:\Windows\SysWOW64

Regsvr32 lbOleDb.dll
Regsvr32 MSWINSCK.DEP
Regsvr32 MSWlNSCK.oca
Regsvr32 MSWINSCK.OCX
Regsvr32 SCRRUN.DEP
Regsvr32 scrrun.dll
Regsvr32 SSTree.oca
Regsvr32 SSTree.ocx
Regsvr32 SSubTmr6.dll
