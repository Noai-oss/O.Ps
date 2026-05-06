function va {
    param(
        [string]$venvname=".venv"
    )
    (& $venvname\Scripts\Activate.ps1) 
}
