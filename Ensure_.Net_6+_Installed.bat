@echo off
setlocal enabledelayedexpansion

set "DOTNET_INSTALLED=false"
set "DOTNET_KEYS=HKLM\SOFTWARE\dotnet\Setup\InstalledVersions\x86\sharedfx\Microsoft.WindowsDesktop.App HKLM\SOFTWARE\WOW6432Node\dotnet\Setup\InstalledVersions\x86\sharedfx\Microsoft.WindowsDesktop.App"

REM Check if installed at each DOTNET_KEYS
for %%K in (%DOTNET_KEYS%) do (
    reg query "%%K" >nul 2>&1
    if not errorlevel 1 (
        REM Key exist, list values (versions)
        for /f "skip=2 tokens=1,2,*" %%A in ('reg query "%%K" /v "*"') do (
            set "LINE=%%A %%B %%C"
            echo LINE = !LINE!
            set "VERSION=%%A"
            echo VERSION = !VERSION!
            REM Extract major version number
            for /f "tokens=1 delims=." %%N in ("!VERSION!") do (
                echo N = %%N
                if %%N geq 6 (
                    set "DOTNET_INSTALLED=true"
                    goto :DotNetCheckDone
                )
            )
        )
    )
)

:DotNetCheckDone
if "!DOTNET_INSTALLED!"=="true" (
    echo .NET Desktop Runtime version 6+ already installed.
    echo You can close this window.
    pause >nul & exit /b
) else (
    echo .NET Desktop Runtime version 6+ is not installed.
    set "OS_ARCHITECTURE="
    if defined ProgramFiles(x86) (set "OS_ARCHITECTURE=x64") else (set "OS_ARCHITECTURE=x86")
    cd /d "%~dp0"
    if "%OS_ARCHITECTURE%"=="x64" (
        echo Windows x64 detected.
        curl https://download.visualstudio.microsoft.com/download/pr/907765b0-2bf8-494e-93aa-5ef9553c5d68/a9308dc010617e6716c0e6abd53b05ce/windowsdesktop-runtime-8.0.8-win-x64.exe --output windowsdesktop-runtime-8.0.8-win-x64.exe
        windowsdesktop-runtime-8.0.8-win-x64.exe /install /quiet /norestart
    ) else (
        echo Windows x86 detected.
        curl https://download.visualstudio.microsoft.com/download/pr/bd1c2e28-44dd-47bb-a55c-aedd1f3e8cc4/0a15fac821e64cf7b8ec6d99e54e0997/windowsdesktop-runtime-8.0.8-win-x86.exe --output windowsdesktop-runtime-8.0.8-win-x86.exe
        windowsdesktop-runtime-8.0.8-win-x86.exe /install /quiet /norestart
    )
    echo .NET Desktop Runtime version 8 is now installed.
    echo You can close this window.
    pause >nul & exit /b
)

endlocal
