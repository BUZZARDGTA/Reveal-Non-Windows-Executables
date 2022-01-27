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
    echo To obtain the best results, you should run this script as administrator...
    echo:
    start /b mshta vbscript:Execute^("msgbox ""To obtain the best results, you should run this script as administrator..."",69680,""%~nx0"":close"^)
)

set executable_counter=0
for /f "delims=" %%A in ('2^>nul wmic process get Description^,ExecutablePath /value') do (
    set "x=%%~A"
    if defined x (
        if "!x:~0,12!"=="Description=" (
            set "description=!x:~12,-1!"
        ) else if "!x:~0,15!"=="ExecutablePath=" (
            set "executablepath=!x:~15,-1!"
        )
        if defined description (
            if defined executablepath (
                if not defined memory_!executablepath! (
                        if /i not "!executablepath:~0,11!"=="%SystemRoot%\" (
                            if /i not "!executablepath:~0,15!"=="\\?\%SystemRoot%\" (
                                set /a executable_counter+=1
                                set "memory_!executablepath!=1"
                                set "display_padding=!description!"
                                if "!display_padding:~0,20!"=="!display_padding!" (
                                    set "display_padding=!display_padding!                    "
                                    set "display_padding=!display_padding:~0,20!"
                                )
                                set "line_!executable_counter!=!display_padding! | !executablepath!"
                            )
                        )
                    )
                )
            )
        )
    )
)
for /l %%A in (1,1,!executable_counter!) do (
    if %%A lss 10 (
        set "display_padding=  "
    ) else if %%A lss 100 (
        set "display_padding= "
    ) else if %%A lss 1000 (
        set display_padding=
    )
    echo !display_padding!%%A ^| !line_%%A!
)

echo:
pause
exit /b
