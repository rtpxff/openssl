
Author: Robert T. Palka (rtpxff)

Generator creating vcxproj for all sub projects. All are for my own purpose.

You use this at your own risk!
I cannot guarantee anything at all, up to total loss of your data. 

Quick start
-----------

 1. Install Perl

 2. Install NASM

 3. Make sure both Perl and NASM are on your %PATH%

 4. Use Visual Studio Developer Command Prompt and run:

    “C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat” x64

 5. From the root of the OpenSSL source directory enter
    - `perl Configure VC-WIN64B`    for generate VC projects for 64-bit OpenSSL

 6. `nmake`


Instead of 4. 5. 6. just run vcxp.bat.


vcxp_add.bat is moving others vcxprojs to main directory, making they correct.
