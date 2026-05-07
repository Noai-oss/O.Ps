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
            Write-Host ">>> Please run the following commands to set git user name and email globally:"
            Write-Host "git config --global user.name '$UserName'"
            Write-Host "git config --global user.email '$UserEmail'"
        }
        else {
            Write-Host ">>> Please run the following commands to set git user name and email locally:"
            Write-Host "git config user.name '$UserName'"
            Write-Host "git config user.email '$UserEmail'"
        }
    }
}
