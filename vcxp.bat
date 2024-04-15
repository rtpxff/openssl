@del vc
@del vc.in

@del *.vcxproj
@del test\*.vcxproj
@del fuzz\*.vcxproj
@del apps\*.vcxproj
@del providers\*.vcxproj
@del util\*.vcxproj
@call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
@perl Configure VC-WIN64B

@copy vc makefile
@copy vc.in makefile.in
@nmake

for %a in      (test\*.vcxproj) do ren "%~a"      "test_%~na%~xa"
for %a in      (fuzz\*.vcxproj) do ren "%~a"      "fuzz_%~na%~xa"
for %a in      (apps\*.vcxproj) do ren "%~a"      "apps_%~na%~xa"
for %a in (providers\*.vcxproj) do ren "%~a" "providers_%~na%~xa"
for %a in      (util\*.vcxproj) do ren "%~a"      "util_%~na%~xa"

@move      test\*.vcxproj .
@move      fuzz\*.vcxproj .
@move      apps\*.vcxproj .
@move providers\*.vcxproj .
@move      util\*.vcxproj .

pause
