@echo off
REM Criar usuário local
net user usuariopadrao Senha@123 /add

REM Adicionar ao grupo Administradores (opcional)
net localgroup Administradores acuidade /add

REM Configurar login automático no Registro
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d usuariopadrao /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d Senha@123 /f

echo Usuário 'usuariopadrao' criado e login automático configurado.
pause
