for %%a in      (test\*.vcxproj) do ren "%%~a"      "test_%%~na%%~xa"
for %%a in      (fuzz\*.vcxproj) do ren "%%~a"      "fuzz_%%~na%%~xa"
for %%a in      (apps\*.vcxproj) do ren "%%~a"      "apps_%%~na%%~xa"
for %%a in (providers\*.vcxproj) do ren "%%~a" "providers_%%~na%%~xa"
for %%a in      (util\*.vcxproj) do ren "%%~a"      "util_%%~na%%~xa"

@move      test\*.vcxproj .
@move      fuzz\*.vcxproj .
@move      apps\*.vcxproj .
@move providers\*.vcxproj .
@move      util\*.vcxproj .

pause

pause
