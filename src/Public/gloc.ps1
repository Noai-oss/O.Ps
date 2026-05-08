function gloc {
    $_current_branch = git branch --show-current --no-color
    git pull origin $_current_branch
}
