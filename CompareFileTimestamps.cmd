@echo off

@REM ---------------------------LOCAL-SETTINGS----------------------------------

@REM Change according to your local config.
SET sourceFilename=Path\file.ext
SET targetFilename=Path\file.ext

@REM ---------------------------------MAIN--------------------------------------

@REM 1=sourceFilename 2=targetFilename
CALL :compare_files %sourceFilename% %targetFilename%
GOTO end

@REM ---------------------------------------------------------------------------

:compare_files
SETLOCAL
SET sourceFilename=%~1
SET targetFilename=%~2
CALL :is_up_to_date %sourceFilename% %targetFilename% isUpToDate
IF %isUpToDate%==0 (GOTO do_update) ELSE GOTO do_nothing
:do_update
ECHO "%sourceFilename% => newer"
MSG * "%sourceFilename% => newer"
GOTO end_check
:do_nothing
ECHO "%sourceFilename% => up-to-date"
:end_check
ENDLOCAL
EXIT /B

:is_up_to_date
SETLOCAL
SET sourceFilename=%~1
SET targetFilename=%~2
CALL :get_file_datetime %sourceFilename% sourceFileDateTime
CALL :get_file_datetime %targetFilename% targetFileDateTime
IF "%targetFileDateTime%" GTR "%sourceFileDateTime%" (SET isUpToDate=0) ELSE (SET isUpToDate=1)
ENDLOCAL & SET %~3=%isUpToDate%
EXIT /B

:get_file_datetime
SETLOCAL
SET filePath=%~1
IF NOT EXIST %filePath% GOTO end_error
@REM Get file's last modified date in agnostic local date format
FOR %%# in ("%filePath%") do SET fileDir=%%~dp#
FOR %%# in ("%filePath%") do SET fileName=%%~nx#
pushd %fileDir%
FOR /f "skip=2 tokens=1,2" %%a in ('robocopy  "." "%TEMP%" /LEV:1 /fat /l /ts /ns /nc /np /njh /njs /If "%fileName%"') do (
	SET fileLastModifiedDate=%%a %%b
)
popd
@REM Replaces slashes by hyphens to respect the ISO date format
SET fileTimestampYear=%fileLastModifiedDate:~0,4%
SET fileTimestampMonth=%fileLastModifiedDate:~5,2%
SET fileTimestampDay=%fileLastModifiedDate:~8,2%
SET fileTimestampHour=%fileLastModifiedDate:~11,2%
SET fileTimestampMinute=%fileLastModifiedDate:~14,2%
SET fileTimestampSecond=%fileLastModifiedDate:~17,2%
SET fileTimestamp=%fileTimestampYear%-%fileTimestampMonth%-%fileTimestampDay% %fileTimestampHour%:%fileTimestampMinute%:%fileTimestampSecond%
ENDLOCAL & SET %~2=%fileTimestamp%
EXIT /B

:end_error
ECHO "Error file not found!"

:end
EXIT
@REM ------------------------------------EOF------------------------------------
