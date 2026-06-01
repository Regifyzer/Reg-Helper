@echo off
setlocal enabledelayedexpansion

:: Create main log directory
if not exist "C:\ProgramData\RegHelper" mkdir "C:\ProgramData\RegHelper"

:: Create logs folder
if not exist "C:\ProgramData\RegHelper\Logs" mkdir "C:\ProgramData\RegHelper\Logs"

:: Create date variable
for /f %%a in ('powershell get-date -format yyyy-MM-dd') do set today=%%a

:: Set logfile path
set logfile=C:\ProgramData\RegHelper\Logs\log_%today%.txt


title REG HELPER
color 0A
goto menu

:menu
cls
echo.
echo.
echo.
echo.
echo. 		=========================
echo. 		      REG HELPER
echo. 		=========================
echo.
echo 	 	1. Network Tools
echo 	 	2. System Repair
echo 	  	3. Cleanup Tools
echo 	 	4. System Info
echo 	 	5. Exit
echo.


set /p choice=Choice:
echo [%time%] User selected option %choice% >> %logfile%

if "%choice%"=="1" goto Network
if "%choice%"=="2" goto Repair
if "%choice%"=="3" goto Cleanup
if "%choice%"=="4" goto Info
if "%choice%"=="5" goto Exit

:: Hidden options
if /i "%choice%"=="clearlog" goto ClearLog

goto menu

:Network
cls
echo. 		=========================
echo. 		      NETWORK TOOLS
echo. 		=========================
echo.
echo 		 1. Flush DNS
echo 		 2. Release/Renew IP
echo 		 3. Test Internet
echo 		 4. Back
echo.

set /p nchoice=Choose:
echo [%time%] User selected option %choice% in Network Tools Menu >> %logfile%

if "%nchoice%"=="1" goto flushdns
if "%nchoice%"=="2" goto relrenip
if "%nchoice%"=="3" goto testnet
if "%nchoice%"=="4" goto menu

goto network


:flushdns
cls
echo Flushing DNS...
echo [%time%] DNS flush started >> %logfile%

ipconfig /flushdns >nul

echo [%time%] DNS flush completed >> %logfile%
echo DNS cache flushed.
pause
goto Network

:relrenip
cls
echo [%time%] IP release started >> %logfile%

ipconfig /release >nul

echo [%time%] IP released >> %logfile%

echo IP released.
echo [%time%] IP renew started >> %logfile%

ipconfig /renew >nul

echo [%time%] IP renewed >> %logfile%

pause
goto Network

:testnet
cls
echo Testing External Connection...

echo [%time%] Internet test started >> %logfile%

ping 8.8.8.8 -n 4 >nul

if errorlevel 1 (
    echo No internet connection.
    echo [%time%] Internet FAILED >> %logfile%
) else (
    echo Internet is connected.
    echo [%time%] Internet OK >> %logfile%
)

pause >nul
goto Network

:Repair
cls
echo.        =========================
echo.             SYSTEM REPAIR
echo.        =========================
echo.
echo          1. System File Checker (SFC)
echo          2. DISM Health Restore
echo          3. Check Disk
echo          4. Restart Print Spooler
echo          5. Network Stack Reset
echo          6. Restart Windows Explorer
echo          7. Refresh Group Policy
echo          8. Time Synchronization
echo          9. Back
echo.

set /p rchoice=Choose:

echo [%time%] User selected option %rchoice% in System Repair Menu >> "%logfile%"

if "%rchoice%"=="1" goto sfcscan
if "%rchoice%"=="2" goto dismrepair
if "%rchoice%"=="3" goto chkdskrepair
if "%rchoice%"=="4" goto spooler
if "%rchoice%"=="5" goto networkreset
if "%rchoice%"=="6" goto restartexplorer
if "%rchoice%"=="7" goto gpupdateforce
if "%rchoice%"=="8" goto timesync
if "%rchoice%"=="9" goto menu

goto Repair


:sfcscan
cls
echo Running System File Checker...
echo [%time%] SFC Scan started >> "%logfile%"

sfc /scannow

echo [%time%] SFC Scan completed >> "%logfile%"
pause
goto Repair


:dismrepair
cls
echo Running DISM Health Restore...
echo [%time%] DISM Repair started >> "%logfile%"

DISM /Online /Cleanup-Image /RestoreHealth

echo [%time%] DISM Repair completed >> "%logfile%"
pause
goto Repair


:chkdskrepair
cls
echo Running Check Disk...
echo [%time%] CHKDSK started >> "%logfile%"

chkdsk C:

echo [%time%] CHKDSK completed >> "%logfile%"
pause
goto Repair


:spooler
cls
echo Restarting Print Spooler...
echo [%time%] Print Spooler restart started >> "%logfile%"

net stop spooler
net start spooler

echo [%time%] Print Spooler restarted >> "%logfile%"
echo Print Spooler restarted successfully.
pause
goto Repair


:networkreset
cls
echo Resetting Network Stack...
echo [%time%] Network Reset started >> "%logfile%"

netsh winsock reset
netsh int ip reset
ipconfig /flushdns

echo [%time%] Network Reset completed >> "%logfile%"
echo.
echo Network stack reset complete.
echo A reboot is recommended.
pause
goto Repair


:restartexplorer
cls
echo Restarting Windows Explorer...
echo [%time%] Explorer restart started >> "%logfile%"

taskkill /f /im explorer.exe
timeout /t 2 >nul
start explorer.exe

echo [%time%] Explorer restarted >> "%logfile%"
pause
goto Repair


:gpupdateforce
cls
echo Refreshing Group Policy...
echo [%time%] GPUpdate started >> "%logfile%"

gpupdate /force

echo [%time%] GPUpdate completed >> "%logfile%"
pause
goto Repair


:timesync
cls
echo Synchronizing system time...
echo [%time%] Time Sync started >> "%logfile%"

w32tm /resync

echo [%time%] Time Sync completed >> "%logfile%"
pause
goto Repair

:Cleanup
cls
echo.        =========================
echo.             CLEANUP TOOLS
echo.        =========================
echo.
echo          1. Clear Temp Files
echo          2. Empty Recycle Bin
echo          3. Clear Prefetch Files
echo          4. Clear Windows Update Cache
echo          5. Disk Cleanup
echo          6. Back
echo.

set /p cchoice=Choose:

echo [%time%] User selected option %cchoice% in Cleanup Menu >> "%logfile%"

if "%cchoice%"=="1" goto cleartemp
if "%cchoice%"=="2" goto recyclebin
if "%cchoice%"=="3" goto prefetch
if "%cchoice%"=="4" goto windowsupdatecache
if "%cchoice%"=="5" goto diskcleanup
if "%cchoice%"=="6" goto menu

goto Cleanup


:cleartemp
cls
echo Cleaning temporary files...
echo [%time%] Temp cleanup started >> "%logfile%"

del /f /s /q "%temp%\*" >nul 2>&1
for /d %%i in ("%temp%\*") do rd /s /q "%%i" >nul 2>&1

echo [%time%] Temp cleanup completed >> "%logfile%"
echo Temporary files removed.
pause
goto Cleanup


:recyclebin
cls
echo Emptying Recycle Bin...
echo [%time%] Recycle Bin cleanup started >> "%logfile%"

powershell -command "Clear-RecycleBin -Force" >nul 2>&1

echo [%time%] Recycle Bin cleanup completed >> "%logfile%"
echo Recycle Bin emptied.
pause
goto Cleanup


:prefetch
cls
echo Clearing Prefetch files...
echo [%time%] Prefetch cleanup started >> "%logfile%"

del /f /s /q "C:\Windows\Prefetch\*" >nul 2>&1

echo [%time%] Prefetch cleanup completed >> "%logfile%"
echo Prefetch files cleared.
pause
goto Cleanup


:windowsupdatecache
cls
echo Clearing Windows Update cache...
echo [%time%] Windows Update cache cleanup started >> "%logfile%"

net stop wuauserv >nul
net stop bits >nul

del /f /s /q "C:\Windows\SoftwareDistribution\Download\*" >nul 2>&1

net start bits >nul
net start wuauserv >nul

echo [%time%] Windows Update cache cleanup completed >> "%logfile%"
echo Windows Update cache cleared.
pause
goto Cleanup


:diskcleanup
cls
echo Launching Disk Cleanup...
echo [%time%] Disk Cleanup launched >> "%logfile%"

cleanmgr

pause
goto Cleanup

:info
cls
echo ====================================== >> %logfile%
echo [%time%] User ran systeminfo >> %logfile%
echo ====================================== >> %logfile%
systeminfo
pause >nul
goto menu

:ClearLog
cls
echo.
echo =========================
echo      CLEAR LOG FILE
echo =========================
echo.

echo Are you sure? This will erase all log entries.
echo.
set /p confirm=Type YES to continue:

if /i not "%confirm%"=="YES" goto menu

echo. > "%logfile%"

echo [%time%] Log file manually cleared >> "%logfile%"

echo.
echo Log file has been cleared.
pause
goto menu

:exit
echo ====================================== >> %logfile%
echo [%time%] User exited the program >> %logfile%
echo ====================================== >> %logfile%
exit