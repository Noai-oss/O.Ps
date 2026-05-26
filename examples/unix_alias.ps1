# alias gs="git status"

# function Invoke-GitStatus  { git status $args }
# Set-Alias -Name gs -Value Invoke-GitStatus

# Safe Alias Binder
# These aliases are ported from https://github.com/SigureMo/dotfiles/blob/353b7458cc5a185cbf11e2913523984bcfab5f88/zsh/aliases.zsh and rewritten for pwsh.

function Invoke-GitStatus       { git status $args }
function Invoke-GitAddAll       { git add -A . $args }
function Invoke-GitCommit       { git commit $args }
function Invoke-GitBranch       { git branch $args }
function Invoke-GitDiff         { git diff $args }
function Invoke-GitCheckout     { git checkout $args }
function Invoke-GitPush         { git push $args }
function Invoke-GitPullFF       { git pull --ff-only $args }
function Invoke-GitTag          { git tag $args }
function Invoke-GitMerge        { git merge $args }
function Invoke-GitSwitch       { git switch $args }
function Invoke-GitCherryPick   { git cherry-pick $args }
function Invoke-GitBisectGood   { git bisect good $args }
function Invoke-GitBisectBad    { git bisect bad $args }
function Invoke-GitPruneOrigin  { git remote prune origin $args }

function Invoke-GitLogGraph {
    git log --graph --pretty=format:'%C(bold red)%h%Creset -%C(bold yellow)%d%Creset %s %C(bold green)(%cr) %C(bold blue)<%an>%Creset %C(yellow)%ad%Creset' --abbrev-commit --date=short $args
}

function Invoke-GitLogGraphReverse {
    git log --reverse --pretty=format:'%C(bold red)%h%Creset -%C(bold yellow)%d%Creset %s %C(bold green)(%cr) %C(bold blue)<%an>%Creset %C(yellow)%ad%Creset' --abbrev-commit --date=short $args
}

function Invoke-GitSyncUpstream {
    $_current_branch = git branch --show-current --no-color 2>$null
    if ($_current_branch) {
        git fetch upstream $_current_branch
        git merge upstream/$_current_branch
        git push
    }
}

function Invoke-GitEmptyCommit {
    git commit -m 'empty commit, re-trigger all ci' --allow-empty $args
}

function Invoke-GitPrCreate {
    gh pr create --web $args
}

function Invoke-GitPushForceLease {
    git push --force-with-lease $args
}


$GitShortcutsMap = [ordered]@{
    "gs"     = "Invoke-GitStatus"
    "ga"     = "Invoke-GitAddAll"
    "gc"     = "Invoke-GitCommit"
    "gb"     = "Invoke-GitBranch"
    "gd"     = "Invoke-GitDiff"
    "gco"    = "Invoke-GitCheckout"
    "gp"     = "Invoke-GitPush"
    "gl"     = "Invoke-GitPullFF"
    "gt"     = "Invoke-GitTag"
    "gm"     = "Invoke-GitMerge"
    "gg"     = "Invoke-GitLogGraph"
    "ggr"    = "Invoke-GitLogGraphReverse"
    "gcp"    = "Invoke-GitCherryPick"
    "gbg"    = "Invoke-GitBisectGood"
    "gbb"    = "Invoke-GitBisectBad"
    "gsn"    = "Invoke-GitSyncUpstream"
    "gsw"    = "Invoke-GitSwitch"
    "gck"    = "Invoke-GitCheckout"
    "gempty" = "Invoke-GitEmptyCommit"
    "gpr"    = "Invoke-GitPrCreate"
    "gpf"    = "Invoke-GitPushForceLease"
    "grc"    = "Invoke-GitPruneOrigin"
}

foreach ($_alias in $GitShortcutsMap.Keys) {
    $_target_function = $GitShortcutsMap[$_alias]

    $_existing_cmd = Get-Command -Name $_alias -CommandType All -ErrorAction SilentlyContinue

    if ($_existing_cmd -and $_existing_cmd.CommandType -ne 'Alias') {
        Write-Warning "Alias '$_alias' is conflicted by other app '$_existing_cmd' ($($_existing_cmd.CommandType))."
    } else{
        Set-Alias -Name $_alias -Value $_target_function -Force
    }
}
