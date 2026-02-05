@echo off

set /A WIDTH=192
set /A HEIGHT=192

ffmpeg -i %1 ^
	-vf "scale=%WIDTH%:%HEIGHT%,format=gray,eq=contrast=1000,fps=fps=30" ^
	"%~n1.gif" ^
	-y

python3 encode.py "%~n1.gif"
