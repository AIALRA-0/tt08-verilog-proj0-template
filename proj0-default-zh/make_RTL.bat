@echo off
setlocal EnableDelayedExpansion

rem Step 1: Update Makefile
set MAKEFILE_PATH=Makefile
set TMP_MAKEFILE_PATH=%MAKEFILE_PATH%.tmp
set V_FILES=

rem Collect .v files except tb.v
for %%f in (*.v) do (
    if /i "%%~nxf" neq "tb.v" (
        set V_FILES=!V_FILES! %%f
    )
)

rem Check if any .v files were found
if "%V_FILES%"=="" (
    echo No .v files found to add to Makefile.
    goto CopyFiles
)

rem Process the Makefile and update the PROJECT_SOURCES line
set FOUND_PROJECT_SOURCES=false
(for /f "delims=" %%l in ('findstr /n "^" "%MAKEFILE_PATH%"') do (
    set "line=%%l"
    set "line=!line:*:=!"
    if "!FOUND_PROJECT_SOURCES!" == "false" (
        echo !line! | findstr /r /c:"^PROJECT_SOURCES[ ]*=[ ]*" >nul
        if errorlevel 1 (
            echo(!line!
        ) else (
            echo PROJECT_SOURCES = !V_FILES:~1!
            set FOUND_PROJECT_SOURCES=true
        )
    ) else (
        echo(!line!
    )
)) > "%TMP_MAKEFILE_PATH%"

rem Replace the original Makefile with the updated one
move /Y "%TMP_MAKEFILE_PATH%" "%MAKEFILE_PATH%"

echo Makefile updated successfully.

:CopyFiles
rem Step 2: Clean src folder and copy files to the appropriate directories
rem Clean src folder except project.v
for %%f in (..\src\*.v) do (
    if /i "%%~nxf" neq "project.v" (
        del /F /Q "%%f"
    )
)

rem Check if there are any .v files in the current directory (excluding tb.v)
set found_v_files=false
for %%f in (*.v) do (
    if /i "%%~nxf" neq "tb.v" (
        rem Copy .v files to the src folder in the parent directory except tb.v
        copy /Y "%%f" "..\src\%%f"
        set found_v_files=true
    )
)

rem Copy specific files to the test folder in the parent directory
set files_to_copy=tb.v test.py Makefile config.json
for %%f in (%files_to_copy%) do (
    if exist "%%f" (
        copy /Y "%%f" "..\test\%%f"
        set found_v_files=true
    )
)

if "%found_v_files%"=="true" (
    echo Files copied successfully.
) else (
    echo No .v files found in the current directory or nothing to copy.
)

rem Step 3: Change directory to the test folder and run make command in WSL
cd ..
cd test
wsl -e /bin/bash -c "make -B; exec bash"

pause

endlocal
