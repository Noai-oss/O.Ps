set windows-shell := ["pwsh.exe", "-NoLogo", "-Command"]
alias b := build
alias i := install
default: install

build:
    ./build.ps1
install: build
    ./install.ps1 -LocalPath .
    Import-Module ./O.Ps.psd1 -Force
