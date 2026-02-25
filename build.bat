@echo off

setlocal enabledelayedexpansion


for /f %%a in ('git rev-parse --short HEAD 2^>NUL') do set commit_hash=%%a
for /f %%d in ('powershell -command "[DateTime]::UtcNow.ToString('yyyy-MM-dd')"') do set today=%%d
set version=dev-%today%-%commit_hash%

if "%1" == "test" (
    "C:\odin-official\odin.exe" test tests -collection:src=src -debug -define:ODIN_TEST_THREADS=1 -define:ODIN_TEST_TRACK_MEMORY=false -extra-linker-flags:"/STACK:4000000,2000000"
) else if "%1" == "single_test" (
    "C:\odin-official\odin.exe" test tests -collection:src=src -define:ODIN_TEST_NAMES=%2 -define:ODIN_TEST_TRACK_MEMORY=false -debug -extra-linker-flags:"/STACK:4000000,2000000"
) else if "%1" == "build_test" (
    "C:\odin-official\odin.exe" build tests -build-mode:test -collection:src=src -define:ODIN_TEST_THREADS=1 -define:ODIN_TEST_TRACK_MEMORY=false -extra-linker-flags:"/STACK:4000000,2000000" %2

    
) else if "%1" == "debug" (
    "C:\odin-official\odin.exe" build src\ -show-timings -microarch:native -out:ols.exe -o:minimal -no-bounds-check -extra-linker-flags:"/STACK:4000000,2000000" -define:VERSION=%version%-debug -debug -use-separate-modules -collection:src=src -collection:odin_parser="C:\odin\core\odin_official_parser_for_odin_fork"
) else (
    "C:\odin-official\odin.exe" build src\ -show-timings -microarch:native -out:ols.exe -o:speed   -no-bounds-check -extra-linker-flags:"/STACK:4000000,2000000" -define:VERSION=%version% -collection:src=src -collection:odin_parser="C:\odin\core\odin_official_parser_for_odin_fork"
)
