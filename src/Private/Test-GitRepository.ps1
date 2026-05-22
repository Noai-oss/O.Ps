function Test-GitRepository {
    git rev-parse --is-inside-work-tree > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Not inside a git repository. Please navigate to a git repository and try again."
    }
}
