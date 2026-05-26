function gcd {
    $_remote = "origin"

    if ((git remote) -contains "upstream") {
        $_remote = "upstream"
    }
    $_remote_head = git symbolic-ref --short "refs/remotes/$_remote/HEAD" 2>$null

    if (-not $_remote_head) {
        git remote set-head $_remote --auto | Out-Null
        $_remote_head = git symbolic-ref --short "refs/remotes/$_remote/HEAD" 2>$null
    }

    if ($_remote_head) {
        $_remote_default_branch = $_remote_head -replace "^$_remote/"
        git checkout $_remote_default_branch
    } else {
        Write-Error "Fail to get the remote default branch, please check for internet or whether $_remote exists."
    }
}
