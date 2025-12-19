@echo off
setlocal

set XML=C:\Users\Public\Scripts\Wi-Fi-ACDx-Secure.xml
set PROFILE=ACDx-Secure
set URL=https://raw.githubusercontent.com/AhrenEnglish/ssid_batch_connect/main/Wi-Fi-ACDx-Secure.xml

echo Creating scripts directory...
mkdir "C:\Users\Public\Scripts" 2>nul

echo Downloading Wi-Fi profile...
curl -L -o "%XML%" -w "HTTP=%%{http_code}\n" "%URL%"
if errorlevel 1 (
  echo ERROR: Download failed.
  exit /b 1
)

if not exist "%XML%" (
  echo ERROR: Wi-Fi profile XML not found after download.
  exit /b 1
)

echo Installing Wi-Fi profile...
netsh wlan add profile filename="%XML%" user=all
if errorlevel 1 (
  echo ERROR: Failed to add Wi-Fi profile.
  del /f /q "%XML%" >nul 2>&1
  exit /b 1
)

echo Connecting to Wi-Fi...
netsh wlan connect name="%PROFILE%"
if errorlevel 1 (
  echo ERROR: Failed to initiate Wi-Fi connection.
  del /f /q "%XML%" >nul 2>&1
  exit /b 1
)

echo Waiting for connection...
timeout /t 5 >nul

echo Current Wi-Fi status:
netsh wlan show interfaces

echo Cleaning up downloaded XML...
del /f /q "%XML%" >nul 2>&1

echo Done.
exit /b 0
