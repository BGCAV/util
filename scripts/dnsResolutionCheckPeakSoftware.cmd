@echo off
::-----------------------------------------------------------------------------
::--
::--  Purpose
::--    Perform DNS resolution request on Peak Software gateway URL.  Portal 
::--    process fails on startup because it's not able to resolve DNS request.
::--    This command ensures gateway URL resolves before starting the Portal.
::--    Successfull execution of this script primes local host's DNS cache
::--    so Portal should succeed.  Script will not yeild control until DNS
::--    successfully resolves.  It applies an exponential backoff retry 
::--    strategy that's limited by a maximum retry interval.
::--
::--  Assume
::--    It's dependent commands are accessible by either being installed to
::--    the same directory or available through PATH
::--
::--  Out
::--    Any messages issued by provided command to SYSOUT or SYSERR.
::--
::-----------------------------------------------------------------------------
setlocal
    retryCommandExponentialBackoff.cmd dnsResolutionCheck.cmd gateway.activityreg.com
endlocal
exit /b