@echo off
::-----------------------------------------------------------------------------
::--
::--  Purpose
::--    Test processMonitorRunning.cmd
::-----------------------------------------------------------------------------
setlocal
    ::call :Test_StartNotePad
    call :Test_ReStartNotePad
endlocal
exit /b

:Test_StartNotePad:
setlocal
    call processMonitorRunning.cmd "notepad.exe" "notepadStart.cmd"
endlocal
exit /b

:Test_ReStartNotePad:
setlocal
    call processMonitorRunning.cmd "notepad.exe" "notepadStart.cmd" "notepadLogAnalyzerStart.cmd"
endlocal
exit /b