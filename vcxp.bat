del vc
del vc.in

del *.vcxproj
del test\*.vcxproj
del fuzz\*.vcxproj
del apps\*.vcxproj
del providers\*.vcxproj
del util\*.vcxproj
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
perl Configure VC-WIN64B

copy vc makefile
copy vc.in makefile.in
nmake

pause
