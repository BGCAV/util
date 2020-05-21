@echo off
::-----------------------------------------------------------------------------
::--
::--  Purpose
::--    Reviews recent SportsManSQL's Portal log entries to determine if 
::--    the process is running normally or could benefit from restarting.
::--
::--  In
::--    %1 - (required) Log Pathfile name written to by the Portal process.
::--    %2 - (required) Relavent Interval expressed in seconds.  The maximum
::--         elapsed interval between the generation of a log file entry and
::--         and the current time.  Log entries within this interval are
::--         considered when determining the recommended action.
::--    Running without specifying any arguments runs unit tests.
::--
::--  Out
::--    %errorlevel% - Recommended actions are defined and performed by
::--       "processMonitorRunning.cmd". At the time of this module's last commit
::--       the errorlevel returned by this component had to return the following:
::--          1 - analyzer failed - do nothing
::--          0 - program execution normal - do nothing.
::--         -1 - program impared, try restarting.
::--         -2 - unable to determine next course of action - do nothing.
::--    SYSOUT - log messages.  Perhaps they should also be
::--       consumed as feedback.
::--
::-----------------------------------------------------------------------------
setlocal
    call :testExpect0Capture logAnalyzerSportsManSQL.cmd "sportsManSQLAnalyzer.cmd.Test.Files\LogNewIndicatesOK"
    if not %errorlevel% == 0 (
        endlocal
        exit /b 1
    )
    call :testExpect0Capture logAnalyzerSportsManSQL.cmd "sportsManSQLAnalyzer.cmd.Test.Files\LogNotRelevant"
    if not %errorlevel% == 0 (
        endlocal
        exit /b 1
    )
    set "RELAVENT_OK=sportsManSQLAnalyzer.cmd.Test.Files\__tempRelavent_OK"
    call :logTimeSimulateNow LOG_TIME
    call :logDateSimulateNow LOG_DATE
    echo %LOG_DATE% %LOG_TIME% Relavent log ok>"%RELAVENT_OK%"
    call :testExpect-2Capture logAnalyzerSportsManSQL.cmd "%RELAVENT_OK%"
    if not %errorlevel% == 0 (
        endlocal
        exit /b 1
    )
    del "%RELAVENT_OK%">nul
    set RELAVENT_OK=

    set "RELAVENT_RESTART=sportsManSQLAnalyzer.cmd.Test.Files\__tempRelavent_RESTART"
    call :logTimeSimulateNow LOG_TIME
    call :logDateSimulateNow LOG_DATE
    echo %LOG_DATE% %LOG_TIME% Error 1429 The remote Host address is invalid (0.0.0.0) module init line #285>"%RELAVENT_RESTART%"
    call :testExpect-1Capture  logAnalyzerSportsManSQL.cmd "%RELAVENT_RESTART%"
    if not %errorlevel% == 0 (
        endlocal
        exit /b 1
    )
    del "%RELAVENT_RESTART%">nul
    set RELAVENT_RESTART=
endlocal
exit /b 0


:logDateSimulateNow:
setlocal
    set LOG_DATE_RTN=%~1
(
endlocal
set %LOG_DATE_RTN%=%DATE:~4%
)
exit /b 0


:logTimeSimulateNow:
setlocal
    set LOG_TIME_RTN=%~1

    for /F "delims=" %%t in ('time /t') do set LOG_TIME=%%t
    set LOG_TIME=%LOG_TIME:~0,5%%TIME:~5,3%%LOG_TIME:~5%
(
endlocal
set %LOG_TIME_RTN%=%LOG_TIME%
)
exit /b 0


:testExpect0Capture:
    :: no setlocal - need side effects to return appropriate values
    call %*
    if not %errorlevel% == 0 (
        echo Test failure during: call %*>&2
        exit /b 1
    )
exit /b 0


:testExpectErrorCapture:
    :: no setlocal - need side effects to return appropriate values
    call %*
    if %errorlevel% == 0 (
        echo Test failure during: call %*>&2
        exit /b 1
    )
exit /b 0

:testExpect-1Capture:
   :: no setlocal - need side effects to return appropriate values
   :: restart needed
    call %*
    if not %errorlevel% == -1 (
        echo Test failure during: call %*>&2
        exit /b 1
    )
exit /b 0


:testExpect-2Capture:
   :: no setlocal - need side effects to return appropriate values
   :: a relevant log entry but not a definite retry
    call %*
    if not %errorlevel% == -2 (
        echo Test failure during: call %*>&2
        exit /b 1
    )
exit /b 0


:assert
setlocal

    if %* (
        endlocal
        exit /b 0  
    ) 
    echo Assert failed: %*
endlocal
exit /b 1