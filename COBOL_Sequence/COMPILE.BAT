@echo off
REM Compilation script for The Sequence COBOL program
REM Requires a COBOL compiler (GnuCOBOL, Micro Focus, etc.)

REM For GnuCOBOL (open source)
if exist "C:\Program Files\GnuCOBOL\bin\cobc.exe" (
    "C:\Program Files\GnuCOBOL\bin\cobc.exe" -x SEQUENCE.COB -o SEQUENCE.EXE
    goto :end
)

REM For other COBOL compilers
cobc -x SEQUENCE.COB -o SEQUENCE.EXE 2>nul
if %errorlevel% equ 0 goto :end

REM If no compiler found
echo Error: No COBOL compiler found.
echo Please install GnuCOBOL or another COBOL compiler.
echo GnuCOBOL can be downloaded from: https://sourceforge.net/projects/gnucobol/
pause
goto :eof

:end
echo Compilation successful. Run SEQUENCE.EXE to start The Sequence.
pause