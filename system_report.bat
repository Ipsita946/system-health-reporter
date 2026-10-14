
@echo off
setlocal

set "REPORT=%~dp0system-report.txt"

echo Windows System Health Report > "%REPORT%"
echo =========================== >> "%REPORT%"
echo Generated: %date% %time% >> "%REPORT%"
echo Hostname: %COMPUTERNAME% >> "%REPORT%"
echo. >> "%REPORT%"

echo Operating System >> "%REPORT%"
echo ---------------- >> "%REPORT%"
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" >> "%REPORT%"
echo. >> "%REPORT%"

echo Disk Usage >> "%REPORT%"
echo ---------- >> "%REPORT%"
powershell -NoProfile -Command "$d=Get-CimInstance Win32_LogicalDisk -Filter ""DeviceID='C:'""; if($d){$u=$d.Size-$d.FreeSpace; 'Drive C: {0:N1} GB used / {1:N1} GB total ({2:N1}%% used)' -f ($u/1GB),($d.Size/1GB),(100*$u/$d.Size)} else {'Drive C: unavailable'}" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo Memory Usage >> "%REPORT%"
echo ------------ >> "%REPORT%"
powershell -NoProfile -Command "$o=Get-CimInstance Win32_OperatingSystem; $t=$o.TotalVisibleMemorySize*1KB; $f=$o.FreePhysicalMemory*1KB; 'Memory: {0:N1} GB used / {1:N1} GB total' -f (($t-$f)/1GB),($t/1GB)" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo Running Processes >> "%REPORT%"
echo ----------------- >> "%REPORT%"
tasklist /FO TABLE >> "%REPORT%" 2>&1

echo.
echo System health report created successfully!
echo Location: "%REPORT%"
echo.
pause