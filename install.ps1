param (
    [ValidateSet('CurrentUser', 'AllUsers')]
    [string]$Scope = 'CurrentUser',

    [string]$LocalPath
)

$ErrorActionPreference = 'Stop'

$moduleName = "O.Ps"
$repoUrl = "https://github.com/Noai-oss/O.Ps.git"

Write-Host "Preparing to install $moduleName module (scope: $Scope)..." -ForegroundColor Cyan

if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "$moduleName requires PowerShell 7 or later. Please upgrade your pwsh environment."
}

if (-not $IsWindows) {
    Write-Error "$moduleName is designed for Windows PowerShell 7. Please run this installation script in pwsh on Windows."
}

if ($Scope -eq 'CurrentUser') {
    $targetModulePath = Join-Path ([Environment]::GetFolderPath('MyDocuments')) "PowerShell\Modules"
} else {
    $targetModulePath = Join-Path $env:ProgramFiles "PowerShell\Modules"
}

$installDir = Join-Path $targetModulePath $moduleName
Write-Host "Target install path: $installDir" -ForegroundColor DarkGray

New-Item -Path $targetModulePath -ItemType Directory -Force | Out-Null
if (Test-Path -LiteralPath $installDir) {
    Remove-Item -LiteralPath $installDir -Recurse -Force
}
New-Item -Path $installDir -ItemType Directory -Force | Out-Null

if ($LocalPath) {
    $sourceDir = (Resolve-Path -LiteralPath $LocalPath).Path
    Write-Host "Installing from local path: $sourceDir" -ForegroundColor Yellow

    Copy-Item -LiteralPath $sourceDir\$moduleName.psd1 -Destination $installDir -Force
    Copy-Item -LiteralPath $sourceDir\$moduleName.psm1 -Destination $installDir -Force
} else {
    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) "O.Ps_install_$([Guid]::NewGuid())"
    Write-Host "Cloning repository..." -ForegroundColor Yellow
    git clone $repoUrl $tempDir
    if ($LASTEXITCODE -ne 0) {
        throw "git clone failed."
    }
    Move-Item -LiteralPath (Join-Path $tempDir "$moduleName.psd1") -Destination $installDir -Force
    Move-Item -LiteralPath (Join-Path $tempDir "$moduleName.psm1") -Destination $installDir -Force
    Remove-Item -LiteralPath $tempDir -Recurse -Force
    Write-Host "Removed the tempDir for cloned source code: $tempDir"
}

$manifestPath = Join-Path $installDir "$moduleName.psd1"
Test-ModuleManifest -Path $manifestPath | Out-Null

Write-Host "$moduleName installed successfully." -ForegroundColor Green
Write-Host "Tip: PowerShell auto-loading is enabled, so you can run $moduleName commands directly, such as proxyOn or gpoc." -ForegroundColor Cyan
