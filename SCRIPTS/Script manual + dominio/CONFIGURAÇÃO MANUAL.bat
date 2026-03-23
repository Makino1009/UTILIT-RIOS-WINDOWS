@echo off
SET ThisScriptsDirectory=%~dp0

:MENU
CLS
ECHO Escolha uma opção:
ECHO 1. Executar configuração
ECHO 2. Entrar no domínio
ECHO 3. Testar se está no domínio
ECHO 4. Instalar programas
ECHO 5. Sair
SET /P choice="Digite o número da sua escolha: "

IF %choice%==1 GOTO Parte1
IF %choice%==2 GOTO Parte2
IF %choice%==3 GOTO Parte3
IF %choice%==4 GOTO Parte4
IF %choice%==5 GOTO FIM

ECHO Opção inválida. Escolha 1, 2, 3, 4 ou 5.
PAUSE
GOTO MENU

:Parte1
SET PowerShellScriptPath=%ThisScriptsDirectory%script-windows.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%PowerShellScriptPath%""' -Verb RunAs}"
GOTO MENU

:Parte2
SET PowerShellScriptPath=%ThisScriptsDirectory%entrar-dominio.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%PowerShellScriptPath%""' -Verb RunAs}"
GOTO MENU

:Parte3
SET PowerShellScriptPath=%ThisScriptsDirectory%teste.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%PowerShellScriptPath%""' -Verb RunAs}"
GOTO MENU

:Parte4
SET PowerShellScriptPath=%ThisScriptsDirectory%instalar.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%PowerShellScriptPath%""' -Verb RunAs}"
GOTO MENU

:FIM
PAUSE
EXIT
