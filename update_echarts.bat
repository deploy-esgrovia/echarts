@echo off
setlocal

REM Nastav název větve, na které máš svoje změny
set MY_BRANCH=upstream_branch
set UPSTREAM_BRANCH=master

echo Fetching upstream...
git fetch upstream

echo Přepínám na větev %MY_BRANCH%
git checkout %MY_BRANCH%
IF ERRORLEVEL 1 (
    echo Větev %MY_BRANCH% neexistuje. Nejdřív ji vytvoř příkazem:
    echo git checkout -b %MY_BRANCH% origin/master
    goto end
)

echo Merguji upstream/%UPSTREAM_BRANCH% do %MY_BRANCH%...
git merge upstream/%UPSTREAM_BRANCH% --no-edit
IF ERRORLEVEL 1 (
    echo Došlo ke konfliktům při mergi!
    echo Otevři soubory, které mají konflikty a oprav je.
    echo    Příkaz: git status
    echo    Pak proveď:
    echo      git add ^<soubory^>
    echo      git commit
    goto end
)

echo Instalace závislostí...
call npm install

echo Build projektu...
call npm run build

echo Hotovo! Větev %MY_BRANCH% je synchronizovaná s upstreamem.

:end
endlocal
pause
