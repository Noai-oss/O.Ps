set windows-shell := ["pwsh.exe", "-NoLogo", "-Command"]
alias b := build
alias i := install

build:
    ./build.ps1
install:
    ./install.ps1 -LocalPath .
