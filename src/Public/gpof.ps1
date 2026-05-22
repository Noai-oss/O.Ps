function gpof {
    $_current_branch = Get-GitCurrentBranch
    git push origin $_current_branch --force-with-lease
}
