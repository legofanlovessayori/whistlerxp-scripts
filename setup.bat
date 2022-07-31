@echo off
goto :welcome
::introduction screen 
:welcome
cls
title Welcome to WhistlerXP for AMD64-based systems 
echo WhistlerXP Setup
echo ==================
echo.
echo Welcome to Setup!
echo This assistant will guide you though the installation of WhistlerXP.
echo.
echo Press [1] to install WhistlerXP onto your computer.
echo Press [2] to update an already installed copy of WhistlerXP.
echo Press [3] for System Recovery.
echo Press [4] to restart your Computer without installing WhistlerXP.
:: choice options, can be freely edited / added (make sure you add variables first)
choice /C 1234
if errorlevel 1 goto clean
if errorlevel 2 goto update
if errorlevel 3 goto recovery
if errorlevel 4 goto restart

:clean
cls
title WhistlerXP for AMD64-based systems Setup
echo WhistlerXP Setup
echo ==================
echo.
echo This section of Setup will install WhistlerXP onto your computer.
echo WARNING: Your disk0 will be wiped, please make sure you have a backup.
choice /m "Do you want to continue the installation?"
if errorlevel 1 goto eula
if errorlevel 2 goto cancel

:eula
::eula screen (can be replaced with a disclamer if its a beta / internal release or the vanilla xp eula)
cls
echo WhistlerXP Setup
echo ==================
echo.
echo Terms and Conditions
::type C:\eula.txt (uncomment for release builds)
type C:\betaeula.txt
choice /m Do you accept the Terms and Conditions?
if errorlevel 1 goto check
if errorlevel 2 goto cancel


:check
::actual installation (nothing realy changed here)
cls
echo WhistlerXP Setup
echo ==================
echo.
echo Setup will now install WhistlerXP onto your computer.
echo Your computer will restart after the next section is completed.
timeout /t 2 /nobreak
cls
echo WhistlerXP Setup
echo ==================
echo.
echo Setup is partitioning your disk0.
diskpart /s X:\scripts\diskpart.txt
cls
echo WhistlerXP Setup
echo ==================
echo.
echo Setup is now applying the image to your disk.
X:\programs\imagex64.exe apply D:\sources\install.wim 1 C:\
cls
echo WhistlerXP Setup
echo ==================
echo.
echo Setup is now creating boot files.
bootsect /nt52 C: /force /mbr
cls
echo WhistlerXP Setup
echo ==================
echo.
echo WhistlerXP has been installed on your computer.
echo Your computer will restart in 10 seconds.
timeout /t 10 /nobreak
wpeutil reboot

:upgrade
::upgrade mode, isn't realy different from the other one just that it skips format and boot files
cls
title WhistlerXP for AMD64-based systems Update
echo WhistlerXP Setup
echo ==================
echo.
echo This section of Setup will update your current WhistlerXP installation.
echo If this update has issues after installing, choose "Go back to previous version" under "System Recovery".
choice /m "Do you want to continue the installation?"
if errorlevel 1 goto upgradeeula
if errorlevel 2 goto cancel

:upgradeeula
::had to copy this since i needed a new variable for the first error level
cls
echo WhistlerXP Setup
echo ==================
echo.
echo Terms and Conditions
::type C:\eula.txt (uncomment for release builds)
type C:\betaeula.txt
choice /m Do you accept the Terms and Conditions?
if errorlevel 1 goto upgradecheck
if errorlevel 2 goto cancel

:upgradecheck
cls
echo WhistlerXP Setup
echo ==================
echo.
echo Setup will now upgrade WhistlerXP.
echo Your computer will restart after the next section is completed.
timeout /t 2 /nobreak
cls
echo WhistlerXP Setup
echo ==================
echo.
echo Setup is backing up your previous installation.
mkdir C:\whxp.old
copy C:\Windows C:\whxp.old\Windows
copy C:\Windows C:\whxp.old\Windows /v
copy "C:\Program Files" "C:\whxp.old\Program Files"
copy "C:\Program Files" "C:\whxp.old\Program Files" /v
copy "C:\Program Files (x86)" "C:\whxp.old\Program Files (x86)"
copy "C:\Program Files (x86)" "C:\whxp.old\Program Files (x86)" /v
::comment out the lines above for x86 builds
cls
echo WhistlerXP Setup
echo ==================
echo.
echo Setup is now applying the image to your disk.
X:\programs\imagex64.exe apply D:\sources\install.wim 1 C:\
cls
echo WhistlerXP Setup
echo ==================
echo.
echo WhistlerXP has been updated.
echo Your computer will restart in 10 seconds.
timeout /t 10 /nobreak
wpeutil reboot

::error messages (it is possible to add more of them, theres currently one for canceling the installation and another one for when goback doesn't find a previous install)
:cancel
cls
echo WhistlerXP
echo ==================
echo.
echo Setup has been cancelled by the user.
echo If this error repeats, report this to the developers.
echo Error Code: 0x1
timeout /t 2 /nobreak
goto reboot

:gobackerror
cls
echo WhistlerXP
echo ==================
echo.
echo Backup is either invalid or does not exist. Setup cannot continue.
echo If this error repeats, report this to the developers.
echo Error Code: 0x2
timeout /t 2 /nobreak
goto recovery

:reboot
::variable name explains it tbh
cls
echo WhistlerXP Setup
echo ==================
echo.
echo WhistlerXP has not been installed on this computer.
echo Restarting now can cause the computer to be unbootable.
choice /m "Are you sure that you want to reboot the computer?"
if errorlevel 1 wpeutil reboot
if errorlevel 2 goto welcome

:recovery
title WhistlerXP Recovery Options
cls
echo WhistlerXP 
echo ==================
echo.
echo Welcome to Recovery!
echo This section of setup allows you to repair your WhistlerXP installation with ease.
echo Press [1] to Go back to a previous version.
echo Press [2] for Command Prompt.
echo Press [3] for repairing system files.
echo Press [4] to restart your computer.
choice /c 1234
if errorlevel 1 goto goback
if errorlevel 2 start X:\Windows\System32\cmd.exe
if errorlevel 3 goto repair
if errorlevel 4 goto reboot

:goback
::logic for the rollback option, might be handy
cls
echo WhistlerXP 
echo ==================
echo.
echo This will restore your previous copy of WhistlerXP.
choice /m "Are you sure that you want to rollback?"
if errorlevel 1 goto gobackcheck
if errorlevel 2 goto recovery

:gobackcheck
cls
echo WhistlerXP 
echo ==================
echo.
echo Setup is checking for a previous version of WhistlerXP.
dir /w C:\whxp.old
choice /m "Does whxp.old show up as valid?"
if errorlevel 1 goto gobackcheck2
if errorlevel 2 goto gobackerror

:gobackcheck2
cls
echo WhistlerXP 
echo ==================
echo.
echo Setup will now restore your previous installation.
copy C:\whxp.old\Windows C:\Windows
copy C:\whxp.old\Windows C:\Windows /v
copy "C:\whxp.old\Program Files" "C:\Program Files"
copy "C:\whxp.old\Program Files" "C:\Program Files" /v
copy "C:\whxp.old\Program Files (x86)" "C:\Program Files (x86)"
copy "C:\whxp.old\Program Files (x86)" "C:\Program Files (x86)" /v
::comment out the lines above for x86 builds
cls
echo WhistlerXP 
echo ==================
echo.
echo Setup has restored your previous installation.
echo The computer will restart in 10 seconds.
timeout /t 10 /nobreak
wpeutil reboot

:repair
cls
echo WhistlerXP 
echo ==================
echo.
echo Setup is now repairing system files.
X:\programs\imagex64.exe apply D:\sources\install.wim 1 C:\
cls
echo WhistlerXP 
echo ==================
echo.
echo Setup has successfully repaired your system.
echo The computer will restart in 10 seconds.
timeout /t 10 /nobreak
wpeutil reboot