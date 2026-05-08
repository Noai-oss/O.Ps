# ==========================================
# Auto-generated. Do not edit directly.
# Source: src/Public/*.ps1
# ==========================================

# --- Region: export.ps1 ---
function export {
    param(
        [string]$env_args
    )
    Write-Host $env_args
    $parts = $env_args.Split('=', 2)

    if ($parts.Length -eq 2){
        $_key = $parts[0]
        $_value = $parts[1]
        Set-Item -Path "env:$_key" -Value $_value
    }else{
        Write-Error "export with unexpected input, need 'export xxx=yyyy' format."
    }
}

# --- EndRegion: export.ps1 ---

# --- Region: gfo.ps1 ---
function gfo { git fetch origin }

# --- EndRegion: gfo.ps1 ---

# --- Region: gfu.ps1 ---
function gfu { git fetch upstream }

# --- EndRegion: gfu.ps1 ---

# --- Region: gloc.ps1 ---
function gloc {
    $_current_branch = git branch --show-current --no-color
    git pull origin $_current_branch
}

# --- EndRegion: gloc.ps1 ---

# --- Region: gpoc.ps1 ---
function gpoc {
    $_current_branch = git branch --show-current --no-color
    git push origin $_current_branch
}

# --- EndRegion: gpoc.ps1 ---

# --- Region: gpof.ps1 ---
function gpof {
    $_current_branch = git branch --show-current --no-color
    git push origin $_current_branch --force-with-lease
}

# --- EndRegion: gpof.ps1 ---

# --- Region: guser.ps1 ---
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

# --- EndRegion: guser.ps1 ---

# --- Region: proxyOff.ps1 ---
function proxyOff {
    unset HTTP_PROXY
    unset HTTPS_PROXY
}

# --- EndRegion: proxyOff.ps1 ---

# --- Region: proxyOn.ps1 ---
function proxyOn {
    export HTTP_PROXY="http://127.0.0.1:7897"
    export HTTPS_PROXY="http://127.0.0.1:7897"
}

# --- EndRegion: proxyOn.ps1 ---

# --- Region: unset.ps1 ---
function unset {
    param (
        [string] $varName
    )
    Remove-Item -Path "env:$varName" -ErrorAction SilentlyContinue
}

# --- EndRegion: unset.ps1 ---

# --- Region: va.ps1 ---
function va {
    param(
        [string]$venvname=".venv"
    )
    (& $venvname\Scripts\Activate.ps1) 
}

# --- EndRegion: va.ps1 ---

# --- Region: vda.ps1 ---
function vda { deactivate }

# --- EndRegion: vda.ps1 ---

Export-ModuleMember -Function @('export', 'gfo', 'gfu', 'gloc', 'gpoc', 'gpof', 'guser', 'proxyOff', 'proxyOn', 'unset', 'va', 'vda')
