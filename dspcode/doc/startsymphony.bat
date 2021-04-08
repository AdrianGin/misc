@echo off

set PATH=D:\Program Files (x86)\Java\jre1.5.0_22\bin\
set DDT_HOME=D:\SymphonyStudio\dsp56720-devtools
set G563_EXEC_PREFIX=%DDT_HOME%\dist\gcc\lib\
set PATH=%DDT_HOME%\dist\gcc\bin\;%PATH%
set DSPLOC=%DDT_HOME%\dist\gcc

start D:\SymphonyStudio\eclipse\symphony-studio.exe

exit
