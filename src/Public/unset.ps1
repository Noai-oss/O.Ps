function unset {
    param (
        [string] $varName
    )
    Remove-Item -Path "env:$varName" -ErrorAction SilentlyContinue
}
