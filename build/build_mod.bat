
@echo off
if not "%1" == "max" start /MAX cmd /c %0 max & exit/b

cmd /c gulp --color --gulpfile "./gulp_build_mod.js" main
pause
