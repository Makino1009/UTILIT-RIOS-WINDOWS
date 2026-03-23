# Função para limpar o lixo do sistema
function LimparLixo {
    
    #  Busca se o usuário tem direito administrativo pra rodar o script (só pra garantir)
        if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            Write-Host "Execute o script como administrador."
            return
        }

        # Checa se o ponto de restauração está ativado
        try {
            Enable-ComputerRestore -Drive "$env:SystemDrive"
        } catch {
            Write-Host "ocorreu um erro enquanto verificávamos o sistema de restauração: $_"
        }

        # Check if the SystemRestorePointCreationFrequency value exists
        $exists = Get-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name "SystemRestorePointCreationFrequency" -ErrorAction SilentlyContinue
        if($null -eq $exists) {
            write-host 'Changing system to allow multiple restore points per day'
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name "SystemRestorePointCreationFrequency" -Value "0" -Type DWord -Force -ErrorAction Stop | Out-Null
        }

        # Tenta carregar o módulo Get-ComputerRestorePoint
        try {
            Import-Module Microsoft.PowerShell.Management -ErrorAction Stop
        } catch {
            Write-Host "Ocorreu um erro no módulo do  Microsoft.PowerShell.Management em: $_"
            return
        }

        # Get all the restore points for the current day
        try {
            $existingRestorePoints = Get-ComputerRestorePoint | Where-Object { $_.CreationTime.Date -eq (Get-Date).Date }
        } catch {
            Write-Host "Ocorreu um erro em verificar os pontos de restauração: $_"
            return
        }

        # Checa se houve outro ponto de restauração criado hoje
        if ($existingRestorePoints.Count -eq 0) {
            $description = "System Restore Point created by Winutil"

            Checkpoint-Computer -Description $description -RestorePointType "MODIFY_SETTINGS"
            Write-Host -ForegroundColor Green "Ponto de restauração criado"
        } 


        # Configura o tempo de desligamento da tela (Display timeout)
        powercfg /change monitor-timeout-ac 30
        powercfg /change monitor-timeout-dc 30

        # Configura o tempo de suspensão do sistema (Sleep timeout)
        powercfg /change standby-timeout-ac 240
        powercfg /change standby-timeout-dc 240

    Write-Host "Removendo o bloatware..."
    Get-AppxPackage -Name "Microsoft.WindowsAlarms" | Remove-AppxPackage
    Get-AppxPackage -Name "SpotifyAB.SpotifyMusic" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.549981C3F5F10" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.SkypeApp" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.WindowsFeedbackHub" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.WindowsSoundRecorder" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.Microsoft3DViewer" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.XboxGamingOverlay" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.YourPhone" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.ZuneVideo" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.Getstarted" | Remove-AppxPackage
    Get-AppxPackage -Name "WindowsCamera" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.Todos" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.ScreenSketch" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.People" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.GetHelp" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.GamingApp" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.BingWeather" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.BingNews" | Remove-AppxPackage
    Get-AppxPackage -Name "microsoft.WindowsMaps" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.ZuneMusic" | Remove-AppxPackage
    Get-AppxPackage -Name "Spotify.Spotify" | Remove-AppxPackage
    Get-AppxPackage -Name "Skype" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.OneNote" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.Xbox" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.MixedReality.Portal" | Remove-AppxPackage
    Get-AppxPackage -Name "Microsoft.MSPaint" | Remove-AppxPackage
    Get-AppxPackage *xboxapp* | Remove-AppxPackage
    Write-Host "Bloatware removido."

    

    Write-Host "Limpando a pasta temporária..."
    # Obtém o caminho da pasta temporária
    $tempPath = [System.IO.Path]::GetTempPath()

    # Obtém todos os arquivos na pasta temporária
    $tempFiles = Get-ChildItem -Path $tempPath

    # Deleta todos os arquivos
    foreach ($file in $tempFiles) {
        try {
            Remove-Item -Path $file.FullName -Force -Recurse
            Write-Host "Arquivo removido: $($file.FullName)"
        } catch {
            Write-Host "Erro ao remover arquivo: $($file.FullName). $_"
        }
    }

    Write-Host "Pasta temporária limpa."
}

# Função para configurar o DNS
function ConfigurarDNS {
    Get-WmiObject -Class Win32_IP4RouteTable | 
where { $_.destination -eq '0.0.0.0' -and $_.mask -eq '0.0.0.0'} | 
Sort-Object metric1 | select interfaceindex | 
Set-DnsClientServerAddress -ServerAddresses ('8.8.8.8', '8.8.4.4', '1.1.1.1', '1.0.0.1')
Write-Host "DNS configurado com múltiplos servidores."

}

# Função para parar e desabilitar serviços
function PararDesabilitarServicos {
    $servicos = @("SysMain", "EFS", "WerSvc", "DiagTrack") # Adicione outros serviços aqui conforme necessário

    foreach ($serviceName in $servicos) {
        # Verifica se o serviço está em execução
        $service = Get-Service -Name $serviceName
        if ($service.Status -eq 'Running') {
            # Para o serviço
            Stop-Service -Name $serviceName -Force
            Write-Host "O serviço $serviceName foi parado com sucesso."
        } else {
            Write-Host "O serviço $serviceName já está parado."
        }

        # Define o serviço para inicialização manual
        Set-Service -Name $serviceName -StartupType Manual
        Write-Host "O serviço $serviceName foi configurado para inicialização manual."
    }

    # Desativar o CompatTelRunner via Agendador de Tarefas
    schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
    schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
    schtasks /Change /TN "\Microsoft\Windows\Application Experience\StartupAppTask" /Disable

    Write-Host "Tarefas de telemetria (coleta de dados da Microsoft) desativadas."
}

sfc /scannow 
DISM /Online /Cleanup-Image /RestoreHealth
sfc /scannow 

# Função para instalar aplicativos
function InstalarAplicativos {
    param (
        [string[]]$aplicativos
    )

    foreach ($appId in $aplicativos) {
        Write-Host "Instalando $appId..."
        winget install --id $appId -e --accept-package-agreements --accept-source-agreements
        Write-Host "$appId instalado com sucesso."
    }
}

# Lista de aplicativos para instalar
$aplicativosParaInstalar = @(
    "RARLab.WinRAR",
    "AnyDesk.AnyDesk",
    "Microsoft.Teams",
    "Adobe.Acrobat.Reader.64-bit",
    "Google.Chrome.Dev",
    "Microsoft.Office"
)

function AtualizarWindows {
    Write-Host "Instalando módulos necessários..."
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Install-Module PSWindowsUpdate -Force
    }

    Write-Host "Atualizando todos os pacotes previamente instalados usando winget..."
    winget upgrade --all

    Write-Host "Importando módulo PSWindowsUpdate..."
    Import-Module PSWindowsUpdate

    Write-Host "Definindo política de execução..."
    Set-ExecutionPolicy RemoteSigned -Scope Process -Force

    Write-Host "Verificando e instalando todas as atualizações importantes e opcionais..."
    Get-WindowsUpdate -AcceptAll -Install

    Write-Host "Verificando e instalando todas as atualizações opcionais..."
    Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install -Category "Optional"

    Write-Host "Todas as atualizações foram instaladas com sucesso."
}



# Chamando as funções
LimparLixo
ConfigurarDNS
PararDesabilitarServicos

# Atualizar Windows
AtualizarWindows

# Instalar aplicativos
InstalarAplicativos -aplicativos $aplicativosParaInstalar



Write-Host "Todas as tarefas foram concluídas."
