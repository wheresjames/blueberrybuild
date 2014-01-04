REM echo %1 %2

REM ----------------------------------------------------------------
REM For each project in the file
REM ----------------------------------------------------------------
FOR /f "tokens=1-8 delims= " %%a IN (%1) DO (

IF NOT %%a==# (

set LPATH=!DIR_LIB!\%%a
set LPATH=!LPATH:/=\!

IF EXIST !LPATH! (

echo *** Updating %%a : %%b : !LPATH!

REM ----------------------------------------------------------------
REM git
REM ----------------------------------------------------------------
IF %%b==git (
cd !LPATH!
git pull
)

REM ----------------------------------------------------------------
REM hg
REM ----------------------------------------------------------------
IF %%b==hg (
cd !LPATH!
hg pull
)

REM ----------------------------------------------------------------
REM svn
REM ----------------------------------------------------------------
IF %%b==svn (
cd !LPATH!
svn update
)

REM ----------------------------------------------------------------
REM cvs
REM ----------------------------------------------------------------
IF %%b==cvs (
cd !LPATH!
cvs update
)

REM ----------------------------------------------------------------
REM targz
REM ----------------------------------------------------------------
IF %%b==targz (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.tar.gz
IF NOT EXIST !FILE! wget -O "!FILE!" "%%d"

IF EXIST !FILE! (

rmdir /s /q "%%a"

IF %%c==- (
cd "%%a"
gzip -c -d !FILE! | tar xf -
) ELSE (
gzip -c -d !FILE! | tar xf -
rename "%%c" "%%a"
)
)
)

REM ----------------------------------------------------------------
REM tarbz2
REM ----------------------------------------------------------------
IF %%b==tarbz2 (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.tar.bz2
IF NOT EXIST !FILE! wget -O "!FILE!" "%%d"

IF EXIST !FILE! (

rmdir /s /q "%%a"

IF %%c==- (
cd "%%a"
bunzip2 -c !FILE! | tar xf -
) ELSE (
bunzip2 -c !FILE! | tar xf -
rename "%%c" "%%a"
)
)
)

REM ----------------------------------------------------------------
REM zip
REM ----------------------------------------------------------------
IF %%b==zip (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.zip
IF NOT EXIST !FILE! wget -O "!FILE!" "%%d"

IF EXIST !FILE! (

rmdir /s /q "%%a"

IF %%c==- (
cd "%%a"
unzip -q !FILE!
) ELSE (
unzip -q !FILE!
rename "%%c" "%%a"
)
)
)


)
)
)
