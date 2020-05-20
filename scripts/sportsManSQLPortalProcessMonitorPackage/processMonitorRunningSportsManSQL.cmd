@echo off 
::-----------------------------------------------------------------------------
::--
::--  Purpose
::--    Monitor the execution of a process.
::--    - If process not running start it
::--    - If process log suggests failure:
::--      - Attempt to gracefully close process
::--      - If process won't gracefully close, forceably terminate it.
::--
::--  In
::--    %1 - (required) program name
::--    %2 - (required) FilePathName to startup program which launches program name.
::--          Remember Windows searches current directory before examining PATH.
::--          Suggest using Windows "start" for GUI programs or CMD for command line ones.
::--    %3 - (optional) FilePathName to Log Analyzer for program.  Log Analyzer 
::--         determines subsequent action if any.  An errorlevel of: 
::--            1 - analyzer failed - do nothing
::--            0 - program execution normal - do nothing.
::--           -1 - program impared, try restarting.
::--           -2 - unable to determine next course of action - do nothing.
::--         Encode a value of "" if other parameters need be specified after
::--         this one and there is no Log Analyzer.
::--    %4 - (optional) Graceful shutdown timeout - an interval, specified in
::--         seconds, to wait for a process to gracefully shutdown, before
::--         forceing its shutdown. Default is 300sec=5min.
::--
::--  Out
::--    Writes log file messages to SYSOUT.
::--
::-----------------------------------------------------------------------------
setlocal EnableDelayedExpansion
    set PROGRAM_NAME=%~1
    set PROGRAM_START_FILEPATH=%~2
    set LOG_ANALYZER=%~3
    set SHUTDOWN_GRACEFUL_TIMEOUT_SEC=%~4

    if "%PROGRAM_NAME%" == "" (
        call :log "Error: program name not specified."
        endlocal
        exit /b 1
    )
    if not exist "%PROGRAM_START_FILEPATH%" (
        call :log "Error: Unable to locate start program='%PROGRAM_START_FILEPATH%'"
        endlocal
        exit /b 1
    )
    call :programToProcessID "%PROGRAM_NAME%" PROCESS_ID
    if not %errorlevel% == 0 (
        call :log "Info: program='%PROGRAM_START_FILEPATH%' not running.  Attempting to start"
        call :processStart "%PROGRAM_START_FILEPATH%"
        if !errorlevel! == 0 (
            call :log "Info: program='%PROGRAM_START_FILEPATH%' successful start."
            call :programToProcessID "%PROGRAM_NAME%" PROCESS_ID
        ) else (
            call :log "Error: program='%PROGRAM_START_FILEPATH%' could not start."
            endlocal
            exit /b 1
        )
    )