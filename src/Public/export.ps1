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
