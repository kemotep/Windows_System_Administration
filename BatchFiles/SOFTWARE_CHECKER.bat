@echo off
goto comment
################################################################################

        SOFTWARE_CHECKER.bat | 2.0
	kemotep | Apache 2.0
	kemotep@fastmail.com | https://gitlab.com/kemotep/ 

This is an example batch file for checking if some software is installed on a given computer.
The escaped entry provides color text for Windows 10 consoles.
You can check for local software installs and processes.
A freshly imaged computer that has run the task sequences should Pass with all Green Messages. 
Red Messages are Failures
Note the escape characters. Windows 10 has wonky support for color printing in the Console.
Hold your breath for the new Terminal.
################################################################################
:comment
SETLOCAL EnableExtensions
echo Verifying software is installed...
if exist "Path\to\program\0" (
	echo [92mProgram 0 is installed![0m
	) else (
	echo [91mProgram 0 is NOT installed![0m
	)
if exist "Path\to\program\1" (
	echo [92mProgram 1 is installed![0m
	) else (
	echo [91mProgram 1 is NOT installed![0m
	)
if exist "Path\to\program\2" (
	echo [92mProgram 2 is installed![0m
	) else (
	echo [91mProgram 2 is NOT installed![0m
	) 
if exist "Path\to\program\3" (
	echo [91mProgram 3 is NOT removed![0m
	) else (
	echo [92mProgram 3 is removed![0m
	)
if exist "Path\to\program\4" ( 
	echo [92mProgram 4 is installed![0m
	) else (
	echo [91mProgram 4  is NOT installed![0m
	)
set EXE=SOME_PROCESS.exe
FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %EXE%"') DO IF %%x == %EXE% ( 
	echo [92mSOME_PROCESS is running![0m
	) else (
	echo [91mSOME_PROCESS is NOT running![0m
	)
pause
