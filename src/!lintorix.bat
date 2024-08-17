@echo off
setlocal enabledelayedexpansion

REM ===============================
REM Lintorix - Python File and Folder Checker
REM --------------------------------
REM This script analyzes Python files using Pylint, Flake8, and mypy.
REM 
REM Author: Jonas Zeihe
REM GitHub: https://github.com/JonasZeihe
REM Email: jonaszeihe@gmail.com
REM
REM Contact: Feel free to reach out for collaboration or questions!
REM
REM ===============================
REM 
REM FUNCTIONALITY:
REM 1. Double-Click Mode:
REM    - When the script is double-clicked, it analyzes all Python files (.py) in the current folder.
REM    - The results are saved in a single file named TIMESTAMP_FOLDERNAME_lintresults.txt.
REM    - Example: 20240817214535_MyFolder_lintresults.txt
REM 
REM 2. Drag-and-Drop Mode:
REM    - Drag one or more Python files onto the script.
REM    - Each file will be analyzed individually.
REM    - The results for each file are saved in separate files named FILENAME_TIMESTAMP_lintresults.txt.
REM    - Example: script.py_20240817214535_lintresults.txt
REM 
REM ===============================
REM
REM MIT LICENSE:
REM ------------------------------
REM Permission is hereby granted, free of charge, to any person obtaining a copy
REM of this software and associated documentation files (the "Software"), to deal
REM in the Software without restriction, including without limitation the rights
REM to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
REM copies of the Software, and to permit persons to whom the Software is
REM furnished to do so, subject to the following conditions:
REM
REM The above copyright notice and this permission notice shall be included in all
REM copies or substantial portions of the Software.
REM
REM THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
REM IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
REM FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
REM AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
REM LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
REM OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
REM SOFTWARE.
REM
REM ===============================
REM 
REM README:
REM ------------------------------
REM Lintorix is a batch script designed to streamline the static analysis of Python code using Pylint, Flake8, and mypy.
REM 
REM Purpose:
REM Lintorix is designed to support AI-aided coding, particularly in refactoring
REM processes involving complex files and larger Python projects. By generating 
REM detailed lint reports, it helps developers maintain code quality and identify
REM potential issues early, enabling more efficient and reliable AI-driven code 
REM refactoring.
REM 
REM Features:
REM 1. Double-Click Mode:
REM    - Analyze all Python files in the current directory.
REM    - Results are saved in a single file with a timestamp and folder name.
REM 
REM 2. Drag-and-Drop Mode:
REM    - Analyze individual Python files by dragging them onto the script.
REM    - Results are saved in separate files for each Python file.
REM 
REM Prerequisites:
REM - Python must be installed with Pylint, Flake8, and mypy available.
REM - Install these packages via pip if they are not already installed.
REM
REM Example pip command:
REM pip install pylint flake8 mypy
REM 
REM ===============================
REM TECHNICAL DESCRIPTION:
REM ------------------------------
REM This script provides two main functionalities:
REM 1. **Double-Click Mode:**
REM    - When you double-click the script, it will analyze all `.py` files in the current directory.
REM    - The results will be stored in a file named `TIMESTAMP_FOLDERNAME_lintresults.txt`.
REM    - The `TIMESTAMP` follows the format `YYYYMMDDHHMMSS`.
REM    - The `FOLDERNAME` is the name of the current directory.
REM 
REM 2. **Drag-and-Drop Mode:**
REM    - You can drag one or multiple `.py` files onto the script.
REM    - Each file will be analyzed separately, and results will be stored in files named `FILENAME_TIMESTAMP_lintresults.txt`.
REM    - The `FILENAME` includes the full name of the Python file, including the `.py` extension.
REM    - The `TIMESTAMP` follows the format `YYYYMMDDHHMMSS`.
REM 
REM ===============================
REM BEGIN SCRIPT
REM ===============================

REM Get current timestamp in the format YYYYMMDDHHMMSS
for /f "tokens=1-4 delims=.-/ " %%a in ('date /t') do set "DATE=%%c%%b%%a"
for /f "tokens=1-3 delims=:. " %%a in ('echo %time%') do (
    set "HOUR=%%a"
    set "MINUTE=%%b"
    set "SECOND=%%c"
)
set "TIME=!HOUR!!MINUTE!!SECOND!"
set "TIMESTAMP=%DATE%%TIME%"

REM Get the current folder name
for %%F in ("%cd%") do set "FOLDERNAME=%%~nxF"

REM Check if files are passed as parameters
if "%~1"=="" (
    echo No files specified. Processing all Python files in the current directory.
    set MODE=folder
    set "OUTPUT_FILE=%TIMESTAMP%_%FOLDERNAME%_lintresults.txt"
) else (
    set MODE=file
)

if "%MODE%"=="file" (
    REM Loop through all passed files
    for %%f in (%*) do (
        if exist "%%~f" (
            set "INPUT_FILE=%%~f"
            set "FILENAME=%%~nxf"
            set "OUTPUT_FILE=%%~nxf_%TIMESTAMP%_lintresults.txt"
            echo Processing %%~f...
            call :AnalyzeFile "%%~f" "!OUTPUT_FILE!"
        ) else (
            echo The file %%~f does not exist.
            pause
            exit /b
        )
    )
) else (
    REM Clear the output file if it exists
    if exist "!OUTPUT_FILE!" del "!OUTPUT_FILE!"

    echo Processing all Python files in the current directory...
    for %%f in (*.py) do (
        call :AnalyzeFile "%%~f" "!OUTPUT_FILE!"
    )
)

echo Review completed. Results saved in the output files.
pause
exit /b

:AnalyzeFile
REM Add the timestamp to the output file
echo Analysis performed on: %TIMESTAMP% >> "%~2"

REM Add the raw code to the output file
echo -------------------------------------------------- >> "%~2"
echo Source code of %~1: >> "%~2"
echo -------------------------------------------------- >> "%~2"
type "%~1" >> "%~2"
echo -------------------------------------------------- >> "%~2"

REM Check with Pylint
echo Checking with Pylint... >> "%~2"
pylint "%~1" >> "%~2" 2>&1

REM Check with Flake8
echo Checking with Flake8... >> "%~2"
flake8 "%~1" >> "%~2" 2>&1

REM Check with mypy
echo Checking with mypy... >> "%~2"
mypy "%~1" >> "%~2" 2>&1

REM Add a separator
echo -------------------------------------------------- >> "%~2"
exit /b
