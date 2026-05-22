function Get-GitCurrentBranch {
    Test-GitRepository

    $branch = git branch --show-current --no-color
    if ([string]::IsNullOrWhiteSpace($branch)) {
        throw 'Current Git HEAD is detached or branch name is empty.'
    }

    return $branch
}
