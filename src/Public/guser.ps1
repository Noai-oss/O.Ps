function _check_in_git {
    git rev-parse --is-inside-work-tree > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Not inside a git repository. Please navigate to a git repository and try again."
    }
}

function guser {
    param (
        [ValidateSet("Noai-oss", "ooooo")]
        [string]$UserName = "Noai-oss",

        [switch]$Write,
        [switch]$Global
    )

    if ($UserName -eq "Noai-oss") {
        $UserEmail = "jiuwoxiao@outlook.com"
    }
    elseif ($UserName -eq "ooooo") {
        $UserEmail = "3164076421@qq.com"
    }

    if ($Write) {
        _check_in_git
        if ($Global) {
            git config --global user.name $UserName
            git config --global user.email $UserEmail
        }
        else {
            git config user.name $UserName
            git config user.email $UserEmail
        }
    }
    else {
        if ($Global) {
            Write-Host ">>> Please run the following commands to set git user name and email globally:" -ForegroundColor Green
            Write-Host "git config --global user.name '$UserName'"
            Write-Host "git config --global user.email '$UserEmail'"
        }
        else {
            Write-Host ">>> Please run the following commands to set git user name and email locally:" -ForegroundColor Green
            Write-Host "git config user.name '$UserName'"
            Write-Host "git config user.email '$UserEmail'"
        }
    }
}
