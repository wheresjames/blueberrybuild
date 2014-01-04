REM echo %1 %2

REM ----------------------------------------------------------------
REM For each project in the file
REM ----------------------------------------------------------------
FOR /f "tokens=1-8 delims= " %%a IN (%1) DO (

IF NOT %%a==# (

set LPATH=!DIR_LIB!\%%a
set LPATH=!LPATH:/=\!

IF EXIST !LPATH! (

echo  .  Ignoring %%a : %%c : !LPATH!

) ELSE (

echo *** Checking out %%a : %%c : !LPATH!

cd "!DIR_LIB!"

REM ----------------------------------------------------------------
REM git
REM ----------------------------------------------------------------
IF %%b==git (
git clone %%d %%a
IF NOT %%c==- (
cd !LPATH!
git checkout %%c
)
)

REM ----------------------------------------------------------------
REM hg
REM ----------------------------------------------------------------
IF %%b==hg (
hg clone %%d %%a
IF NOT %%c==- (
cd !LPATH!
hg checkout %%c
)
)

REM ----------------------------------------------------------------
REM svn
REM ----------------------------------------------------------------
IF %%b==svn (
cd !LPATH!
IF %%c==- (
IF %%e==anon (
svn co -q --username anonymous --password "" "%%d" %%a
) ELSE (
svn co -q "%%d" %%a
)
) ELSE (
svn co -q -r %%c "%%d" %%a
)
)

REM ----------------------------------------------------------------
REM cvs
REM ----------------------------------------------------------------
IF %%b==cvs (
IF %%c==- (
cvs -Q -z3 -d %%f%%d co -d %%a %%e
) ELSE (
cvs -Q -z3 -d "%%f%%d" co -r %%c -d %%a "%%e"
)
)

REM ----------------------------------------------------------------
REM targz
REM ----------------------------------------------------------------
IF %%b==targz (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.tar.gz
IF NOT EXIST !FILE! wget -O "!FILE!" "%%d"

IF %%c==- (
cd "%%a"
gzip -c -d !FILE! | tar xf -
) ELSE (
gzip -c -d !FILE! | tar xf -
rename "%%c" "%%a"
)

)

REM ----------------------------------------------------------------
REM tarbz2
REM ----------------------------------------------------------------
IF %%b==tarbz2 (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.tar.bz2
IF NOT EXIST !FILE! wget -O "!FILE!" "%%d"

IF %%c==- (
cd "%%a"
bunzip2 -c !FILE! | tar xf -
) ELSE (
bunzip2 -c !FILE! | tar xf -
rename "%%c" "%%a"
)

)

REM ----------------------------------------------------------------
REM zip
REM ----------------------------------------------------------------
IF %%b==zip (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.zip
IF NOT EXIST !FILE! wget -O "!FILE!" "%%d"

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
