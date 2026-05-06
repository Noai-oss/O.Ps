#requires -Version 7.0
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$ModuleName = 'O.Ps'
$Root = $PSScriptRoot

$PublicDir = Join-Path $Root 'src/Public'
$ModulePath = Join-Path $Root "$ModuleName.psm1"
$ManifestPath = Join-Path $Root "$ModuleName.psd1"

function Get-NormalizedList {
    param(
        [AllowNull()]
        [object] $InputObject
    )

    @(
        $InputObject |
        Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } |
        ForEach-Object { [string]$_ } |
        Sort-Object -Unique
    )
}

function ConvertTo-QuotedString {
    param(
        [Parameter(Mandatory)]
        [string] $Value
    )

    "'$($Value -replace "'", "''")'"
}

function Test-SameList {
    param(
        [AllowNull()]
        [string[]] $A,

        [AllowNull()]
        [string[]] $B
    )

    ($A.Count -eq $B.Count) -and (($A -join "`0") -eq ($B -join "`0"))
}

Write-Host ">>> Building $ModuleName..." -ForegroundColor Cyan

if (-not (Test-Path -LiteralPath $PublicDir -PathType Container)) {
    throw "Missing public source directory: $PublicDir"
}

if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)) {
    throw "Missing module manifest: $ManifestPath"
}

$PublicFiles = @(
    Get-ChildItem -LiteralPath $PublicDir -Filter '*.ps1' -File |
    Sort-Object Name
)

$Functions = Get-NormalizedList -InputObject $PublicFiles.BaseName

$ExportList = @(
    $Functions |
    ForEach-Object { ConvertTo-QuotedString -Value $_ }
)

$ModuleContent = @(
    '# ==========================================',
    '# Auto-generated. Do not edit directly.',
    '# Source: src/Public/*.ps1',
    '# ==========================================',
    ''

    foreach ($File in $PublicFiles) {
        "# --- Region: $($File.Name) ---"
        Get-Content -LiteralPath $File.FullName -Raw
        "# --- EndRegion: $($File.Name) ---"
        ''
    }

    if ($ExportList.Count -gt 0) {
        "Export-ModuleMember -Function @($($ExportList -join ', '))"
    }
)

Set-Content `
    -LiteralPath $ModulePath `
    -Value ($ModuleContent -join [Environment]::NewLine) `
    -Encoding utf8NoBOM

Write-Host "OK: Wrote $ModulePath" -ForegroundColor Green

$Manifest = Import-PowerShellDataFile -LiteralPath $ManifestPath

$CurrentFunctions = if ($Manifest.ContainsKey('FunctionsToExport')) {
    Get-NormalizedList -InputObject $Manifest.FunctionsToExport
}
else {
    @()
}

if (-not (Test-SameList -A $CurrentFunctions -B $Functions)) {
    Update-ModuleManifest `
        -Path $ManifestPath `
        -FunctionsToExport $Functions

    Write-Host "OK: Updated FunctionsToExport in $ManifestPath" -ForegroundColor Green
}
else {
    Write-Host "INFO: FunctionsToExport unchanged" -ForegroundColor DarkGray
}

Write-Host "Done: Build completed. Run: Import-Module .\O.Ps -Force" -ForegroundColor Cyan
