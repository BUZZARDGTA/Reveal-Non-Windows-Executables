::------------------------------------------------------------------------------
:: NAME
::     Reveal_Non_Windows_Executables.bat - Reveal Non Windows Executables
::
:: DESCRIPTION
::     Display running executables that are not present in %SystemDrive% folder.
::
:: KNOWN BUGS
::      The "non windows" executables that are present
::      in %SystemDrive% folder wont reveal.
::
::      Results can get duplicated if they have different parent processes.
::
:: AUTHOR
::     IB_U_Z_Z_A_R_Dl
::
:: CREDITS
::     @Grub4K - Creator of the padding CLI algorithm.
::
::     A project created in the "server.bat" Discord: https://discord.gg/GSVrHag
::------------------------------------------------------------------------------
@echo off
setlocal EnableDelayedExpansion
echo:

>nul 2>&1 dism || (
    echo  To obtain the best results, you should run this script as administrator...
    echo:
    start /b mshta vbscript:Execute^("msgbox ""To obtain the best results, you should run this script as administrator..."",69680,""%~nx0"":close"^)
)

for /f "skip=2tokens=2*delims=," %%A in ('2^>nul wmic process get Description^,ExecutablePath /format:csv') do (
    set "executable_path=%%~B"
    set "executable_path=!executable_path:~0,-1!"
    if defined executable_path (
        if /i not "!executable_path!"=="!memory!" (
            if /i not "!executable_path:~0,11!"=="%SystemRoot%\" (
                set "Display_Padding=%%~nxA"
                if "!Display_Padding:~0,20!"=="!Display_Padding!" (
                    set "Display_Padding=!Display_Padding!                    "
                    set "Display_Padding=!Display_Padding:~0,20!"
                )
                echo PROCESS: !Display_Padding!  ^|  PATH: !executable_path!
                set "memory=!executable_path!"
            )
        )
    )
)

echo:
pause
exit /b
