
if "%PUPPET_RELEASE%" equ "open" goto :opensource
if "%PUPPET_RELEASE%" equ "enterprise" goto :enterprise
goto :done

:opensource

if not exist "C:\Windows\Temp\puppet.msi" (
  powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://nuget.nreca.org/puppet/puppet-agent-%PUPPET_VERSION%-x86.msi', 'C:\Windows\Temp\puppet.msi')" <NUL
)

msiexec /qn /i C:\Windows\Temp\puppet.msi PUPPET_AGENT_STARTUP_MODE=disabled PUPPET_MASTER_SERVER=puppetmaster.localdomain  /log C:\Windows\Temp\puppet.log

<nul set /p ".=;C:\Program Files (x86)\Puppet Labs\Puppet\bin" >> C:\Windows\Temp\PATH
set /p PATH=<C:\Windows\Temp\PATH
setx PATH "%PATH%" /m

:enterprise

if not exist "C:\Windows\Temp\puppet.msi" (
  powershell -Command "[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true} ;(New-Object System.Net.WebClient).DownloadFile('http://pm.puppetlabs.com/puppet-agent/%PE_VERSION%/%PE_AGENT_VERSION%/repos/windows/puppet-agent-%PE_AGENT_VERSION%-%PE_ARCH%.msi', 'C:\Windows\Temp\puppet.msi')" <NUL
)

msiexec /qn /i C:\Windows\Temp\puppet.msi PUPPET_AGENT_STARTUP_MODE=disabled PUPPET_MASTER_SERVER=puppetmaster.localdomain  /log C:\Windows\Temp\puppet.log

<nul set /p ".=;C:\Program Files (x86)\Puppet Labs\Puppet\bin" >> C:\Windows\Temp\PATH
set /p PATH=<C:\Windows\Temp\PATH
::C:\Windows\System32\setx.exe PATH "%PATH%" /m => THIS IS CAUSING ISSUES

:done

echo "done with provisioning tools"