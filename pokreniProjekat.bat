@echo off

set flexFajl=%~1
set bisonFajl=%~2
set imeFajla=%~n1

del lex.yy.c

del %imeFajla%.exe

del "C:\Program Files (x86)\GnuWin32\bin\%flexFajl%"

copy %flexFajl% "C:\Program Files (x86)\GnuWin32\bin"

call "C:\Program Files (x86)\GnuWin32\bin\flex.bat" %flexFajl%

timeout 3

del C:\GnuWin32\bin\%flexFajl%
del C:\GnuWin32\bin\%bisonFajl%
del C:\GnuWin32\bin\lex.yy.c

copy %flexFajl% C:\GnuWin32\bin
copy %bisonFajl% C:\GnuWin32\bin
copy lex.yy.c C:\GnuWin32\bin

cd "C:\GnuWin32\bin"

call bison.bat %bisonFajl%  

del C:\MinGW\bin\%imeFajla%.tab.c
del C:\MinGW\bin\%imeFajla%.tab.h
del C:\MinGW\bin\lex.yy.c

copy *.tab.h C:\MinGW\bin
copy *.tab.c C:\MinGW\bin
copy lex.yy.c C:\MinGW\bin

cd "C:\MinGW\bin"

call mingw.bat %imeFajla%

timeout 3

copy %imeFajla%.exe "C:\Users\vlaki\Desktop\Files\Faks\III godina\II semestar\Programski prevodioci\Projekat"

cd "C:\Users\vlaki\Desktop\Files\Faks\III godina\II semestar\Programski prevodioci\Projekat"

