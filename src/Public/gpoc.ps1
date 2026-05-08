function gpoc {
    $_current_branch = git branch --show-current --no-color
    git push origin $_current_branch
}
