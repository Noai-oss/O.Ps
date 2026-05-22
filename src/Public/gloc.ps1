function gloc {
    $_current_branch = Get-GitCurrentBranch
    git pull origin $_current_branch
}
