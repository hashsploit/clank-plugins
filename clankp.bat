@echo off
setlocal

REM Change directory to the current script directory
set DIR=%~dp0
cd %DIR%

set SCRIPT=%~0

IF "%~1" == "debug" GOTO exec
IF "%~1" == "run" GOTO exec
IF "%~1" == "r" GOTO exec
IF "%~1" == "d" GOTO exec
goto menu

:check_installed
	where %~1 2>nul
	if %ERRORLEVEL% NEQ 0 (
		set /A "%~2 = 1"
	) else (
		set /A "%~2 = 0"
	)
exit /B 0

:require_installed
	call :check_installed %~1, status
	if %status% == 0 (
		echo %~1 ^(%~2^) is not installed, please install it!
		exit /B 100
	)
exit /B 0

:exec
	call :require_installed "lua", "Lua 5.3+"
	if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
	
	REM Remove 1st parameter from %*
	set _tail=%*
	call set _tail=%%_tail:*%1=%%
	
	REM Run runner
	lua lib\runner.lua %_tail%
exit /B 0





REM Menu
:menu
	echo ========================
	echo Clank Plugin Dev Utility
	echo ========================
	echo.
	echo  Commands:
	echo   * debug,run,d,r [plugin] .... Debug a specific plugin or all plugins
goto :eof

