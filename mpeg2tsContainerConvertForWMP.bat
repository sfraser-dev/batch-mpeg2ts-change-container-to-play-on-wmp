@echo off
SET CONTAINER_EXTN=mpg
:: Recursively search for media containers, call function ffmpegConvert on each container
for /f "delims=" %%f in ('dir "*.%CONTAINER_EXTN%" /s/b') do @call:ffmpegConvert "%%f"
goto:eof

:: Function to convert media containers using FFMPEG
:ffmpegConvert
:: Resolving filenames
SET THE_ORIGINAL_NAME="%~f1"
SET THE_DRIVE_LETTER=%~d1
SET THE_PATH=%~p1
SET THE_FILE=%~n1
SET THE_EXTN=%~x1
SET THE_NEW_NAME="%THE_DRIVE_LETTER%%THE_PATH%%THE_FILE%.ffmpeg.%CONTAINER_EXTN%"
:: Use FFPROBE to get the bit_rate of the container (ie: the multiplexing rate)
for /f "delims=" %%i in ('ffprobe -i %THE_ORIGINAL_NAME% -show_format -v 0 ^| C:\Windows\System32\find.exe "bit_rate"') do SET THE_MUXRATE_STR=%%i
:: Remove "bit_rate=" from THE_MUXRATE_STR (ie: remove the first nine characters)
SET THE_MUXRATE=%THE_MUXRATE_STR:~9%
echo.muxRateStr=%THE_MUXRATE_STR%
echo.muxRate=%THE_MUXRATE%
:: Convert the container format using FFMPEG while keeping the same video, audio and multiplexing rates
ffmpeg -y -i %THE_ORIGINAL_NAME% -c copy -muxrate %THE_MUXRATE% -f mpegts %THE_NEW_NAME%
goto:eof