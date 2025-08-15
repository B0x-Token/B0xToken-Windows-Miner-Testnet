@echo off
chcp 65001

echo Checking for .NET 6.0 runtime...

:: Check if .NET 6.0 is installed
dotnet --list-runtimes | findstr "Microsoft.NETCore.App 6." >nul 2>&1
if %errorlevel% EQU 0 (
    echo .NET 6.0 runtime found.
    goto continueProgram
)

echo .NET 6.0 runtime not found. Installing...
echo This will download and install .NET 6.0 Runtime automatically.
echo Please wait...

:: Create temp directory for download
if not exist "%TEMP%\dotnet_installer" mkdir "%TEMP%\dotnet_installer"
cd /d "%TEMP%\dotnet_installer"

:: Download .NET 6.0 Runtime installer (x64)
echo Downloading .NET 6.0 Runtime installer...
powershell -Command "try { Invoke-WebRequest -Uri 'https://download.microsoft.com/download/6/0/f/60fc8c9b-e5b0-43b5-a0c2-36d1be8ebb7d/windowsdesktop-runtime-6.0.33-win-x64.exe' -OutFile 'dotnet6-runtime-installer.exe' -UseBasicParsing } catch { Write-Host 'Download failed. Please check your internet connection.' ; exit 1 }"

if not exist "dotnet6-runtime-installer.exe" (
    echo Failed to download .NET 6.0 installer.
    echo Please download and install .NET 6.0 Runtime manually from:
    echo https://dotnet.microsoft.com/download/dotnet/6.0
    pause
    exit /b 1
)

echo Installing .NET 6.0 Runtime...
echo Please follow the installation prompts.
start /wait dotnet6-runtime-installer.exe

:: Clean up
cd /d "%~dp0"
rmdir /s /q "%TEMP%\dotnet_installer" >nul 2>&1

:: Verify installation
echo Verifying .NET 6.0 installation...
dotnet --list-runtimes | findstr "Microsoft.NETCore.App 6." >nul 2>&1
if %errorlevel% NEQ 0 (
    echo .NET 6.0 installation verification failed.
    echo Please ensure .NET 6.0 Runtime is properly installed.
    pause
    exit /b 1
)

echo .NET 6.0 Runtime successfully installed!

:continueProgram
echo "I am sleeping for 3 seconds before launch."
timeout /t 3 /nobreak >nul

:startProgram
:: Redirect output to screen and a file using a for loop
B0xToken.exe 

:: Check the actual program exit code
if %errorlevel% EQU 22 (
    echo Exit code 22 detected - restarting...
    timeout /t 5
    goto startProgram
)

pause
timeout /t 2
pause
timeout /t 3
pause