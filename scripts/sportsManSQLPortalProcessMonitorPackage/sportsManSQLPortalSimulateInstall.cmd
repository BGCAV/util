@echo off
::-----------------------------------------------------------------------------
::--
::--  Purpose
::--    Install\Remove a simulated Portal program to test automation.
::--
::--  Note
::--    Requires administrator privilges.
::--
::-----------------------------------------------------------------------------
setlocal EnableDelayedExpansion
    set "INSTALL_DIR=%ProgramFiles(x86)%\Peak Software Systems\SportSQL"
    if "%1" == "remove" (
        call :remove
        if not !errorlevel! == 0 (
            echo "uninstall failed">&2
            endlocal
            exit /b 1
        )
        exit /b 0
    )
    call :install
    if not %errorlevel% == 0 (
        echo "install failed">&2
        endlocal
        exit /b 1
    )
exit /b 0


:install:
setlocal EnableExtensions
    mkdir "%INSTALL_DIR%"
    if not %errorlevel% == 0 (
        echo "install failed during mkdir">&2
        endlocal
        exit /b 1
    )
    powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%INSTALL_DIR%\portal.exe.lnk');$s.TargetPath='%windir%\system32\notepad.exe';$s.Save()"
    if not %errorlevel% == 0 (
        echo "install failed during copy">&2
        endlocal
        exit /b 1
    )
    :: initialize portal logfile
    echo Portal Started>"%INSTALL_DIR%"\Portal.ERR
endlocal
exit /b 0


:remove:
setlocal EnableDelayedExpansion
    if not exist "%INSTALL_DIR%" (
        echo "Nothing to remove"
        exit /b 0
    )
    for /f "delims=" %%f in ('dir "%INSTALL_DIR%"') do ( 
        echo %%f | findstr /r /c:"^  *[0-2] File"
        if !errorlevel! == 0 (
            goto removeFileCntExpected
        )
    )
    echo "Unexpected number of files - aborting removal">&2
    exit /b 1
    :removeFileCntExpected:
    rmdir /S /Q "%INSTALL_DIR%">nul
    if not %errorlevel% == 0 (
        endlocal
        exit /b 1
    )
endlocal
exit /b 0