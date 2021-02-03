@echo off

@REM ---------------------------LOCAL-SETTINGS----------------------------------

@REM Change according to your local config.
SET sourcefilename=Path\file.ext
SET targetfilename=Path\file.ext

@REM ---------------------------------MAIN--------------------------------------

CALL :compare_files %sourcefilename% %targetfilename%
GOTO end

@REM ---------------------------------------------------------------------------

:compare_files
SETLOCAL
SET sourcefilename=%~1
SET targetfilename=%~2
CALL :is_newer %sourcefilename% %targetfilename% isnewer
IF %isnewer%==1 (GOTO newer) ELSE GOTO older
:newer
ECHO "%sourcefilename% => newer"
GOTO end_check
:older
ECHO "%sourcefilename% => older"
:end_check
ENDLOCAL
EXIT /B

:is_newer
SETLOCAL
SET sourcefilename=%~1
SET targetfilename=%~2
CALL :get_file_datetime %sourcefilename% sourcefiledatetime
CALL :get_file_datetime %targetfilename% targetfiledatetime
IF "%targetfiledatetime%" GTR "%sourcefiledatetime%" (SET isnewer=0) ELSE (SET isnewer=1)
ENDLOCAL & SET %~3=%isnewer% 
EXIT /B

@REM Works with the "DD/MM/YYYY HH:MM" format
:get_file_datetime
SETLOCAL
SET filename=%~1
IF NOT EXIST %filename% GOTO end_error
FOR %%f IN (%filename%) DO SET fileLastModifiedDate=%%~tf
SET fileTimestampYear=%fileLastModifiedDate:~6,4%
SET fileTimestampMonth=%fileLastModifiedDate:~3,2%
SET fileTimestampDay=%fileLastModifiedDate:~0,2%
SET fileTimestampHour=%fileLastModifiedDate:~11,2%
SET fileTimestampMinute=%fileLastModifiedDate:~14,2%
SET fileTimestamp=%fileTimestampYear%/%fileTimestampMonth%/%fileTimestampDay% %fileTimestampHour%:%fileTimestampMinute%
ENDLOCAL & SET %~2=%fileTimestamp%
EXIT /B

:end_error
ECHO "Error: file not found"

:end
PAUSE
EXIT
@REM ----------------------------------EOF--------------------------------------
