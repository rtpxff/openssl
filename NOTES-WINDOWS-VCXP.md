
Native builds using Visual C++
==============================

The native builds using Visual C++ have a `VC-*` prefix.


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