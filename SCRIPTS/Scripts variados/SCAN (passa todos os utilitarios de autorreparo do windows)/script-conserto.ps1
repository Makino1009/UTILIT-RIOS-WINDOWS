sfc /scannow 

DISM /Online /Cleanup-Image /RestoreHealth

sfc /scannow 

CHKDSK /F /R/X

# Adiciona a classe necessária
Add-Type -AssemblyName System.Windows.Forms

# Pressiona 's'
[System.Windows.Forms.SendKeys]::SendWait("s")

Start-Sleep -Milliseconds 500  # pequena pausa

# Pressiona 'y'
[System.Windows.Forms.SendKeys]::SendWait("y")
