@echo off
::-----------------------------------------------------------------------------
::--
::--  Purpose:
::--    Insure network viability by querying well known IP & DNS.  If cannot 
::--    resolve, perform exponentional backoff until either resolved or max backoff
::--    achieved.  If still cannot resolve, continue to retry after max backoff
::--    interval elapses.
::--
::--  Out:
::--    Writes log file messages to SYSOUT.
::
::-----------------------------------------------------------------------------
setlocal
::-- use google dns server as well known IP
set WELL_KNOWN_PING=8.8.8.8
::-- trying to connect to Peak Software Gateway
set URL_TO_RESOLVE=gateway.activityreg.com
set RETRY_BACKOFF_MAX_MINUTES=30
call :Retry "%WELL_KNOWN_PING%" "%URL_TO_RESOLVE%" "%RETRY_BACKOFF_MAX_MINUTES%"
endlocal
exit /b

:Retry:
setlocal
    set PING_IP=%~1
    set URL_TO_RESOLVE=%~2
    set /A RETRY_BACKOFF_MAX_SEC=%~3*60
    set RETRY_BACKOFF=1
    :RetryLoop:
    if %RETRY_BACKOFF% GTR %RETRY_BACKOFF_MAX_SEC% (
        set RETRY_BACKOFF=%RETRY_BACKOFF_MAX_SEC%
    )
    timeout /NOBREAK /T %RETRY_BACKOFF%
    ping -n 3 %PING_IP% >nul
    if %ERRORLEVEL% == 0 (
        set PING_STATUS=successful
    ) else (
        set PING_STATUS=failed
    )
    call :log "ping to IP='%PING_IP%' status='%PING_STATUS%'"
    ping -n 3 %URL_TO_RESOLVE% >nul
    if %ERRORLEVEL% == 0 (
        set PING_STATUS=successful
    ) else (
        set PING_STATUS=failed
    )
    call :log "ping to URL='%URL_TO_RESOLVE%' status='%PING_STATUS%'"
    if not "%PING_STATUS%" == "successful" (
        set /A RETRY_BACKOFF=%RETRY_BACKOFF%*2
        goto RetryLoop
    )
endlocal
exit /b 0

:log:
setlocal
    For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
    For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
    echo %mydate%_%mytime%: msg=%1%2%3%4%5%6%7%8%9
endlocal
exit /b