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
function gloc { git pull origin master }

# --- EndRegion: gloc.ps1 ---

# --- Region: gpoc.ps1 ---
function gpoc { git push origin master }

# --- EndRegion: gpoc.ps1 ---

# --- Region: gpof.ps1 ---
function gpof { git push origin master --force-with-lease }

# --- EndRegion: gpof.ps1 ---

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

Export-ModuleMember -Function @('export', 'gfo', 'gfu', 'gloc', 'gpoc', 'gpof', 'proxyOff', 'proxyOn', 'unset', 'va', 'vda')
