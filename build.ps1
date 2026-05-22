#requires -Version 7.0
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0
$ModuleName = 'O.Ps'
$Root = $PSScriptRoot

$PublicDir = Join-Path $Root 'src/Public'
$PrivateDir = Join-Path $Root 'src/Private'
$ModulePath = Join-Path $Root "$ModuleName.psm1"
$ManifestPath = Join-Path $Root "$ModuleName.psd1"

function Assert-SingleFunctionFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.IO.FileInfo]
        $File,

        [switch]
        $RequireNameMatch
    )

    $tokens = $null
    $parseErrors = $null

    $ast = [System.Management.Automation.Language.Parser]::ParseFile(
        $File.FullName,
        [ref]$tokens,
        [ref]$parseErrors
    )

    if ($parseErrors.Count -gt 0) {
        $messages = $parseErrors | ForEach-Object {
            "{0}:{1} {2}" -f $_.Extent.StartLineNumber, $_.Extent.StartColumnNumber, $_.Message
        }

        throw "Parse error in '$($File.FullName)':`n$($messages -join "`n")"
    }

    $functions = @(
        $ast.FindAll({
            param($node)
            $node -is [System.Management.Automation.Language.FunctionDefinitionAst]
        }, $true)
    )

    if ($functions.Count -ne 1) {
        $found = if ($functions.Count -eq 0) {
            '<none>'
        }
        else {
            ($functions | ForEach-Object { $_.Name }) -join ', '
        }

        throw "File '$($File.Name)' must contain exactly one function. Found: $found"
    }

    if ($RequireNameMatch) {
        $expected = $File.BaseName
        $actual = $functions[0].Name

        if ($actual -cne $expected) {
            throw "File '$($File.Name)' must define function '$expected', but defines '$actual'."
        }
    }

    return $functions[0]
}

function ConvertTo-PowerShellStringLiteral {
    param(
        [Parameter(Mandatory)]
        [string] $Value
    )

    "'{0}'" -f ($Value -replace "'", "''")
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

if (-not (Test-Path -LiteralPath $PrivateDir -PathType Container)) {
    throw "Missing public source directory: $PrivateDir"
}

if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)) {
    throw "Missing module manifest: $ManifestPath"
}

$privateFiles = @(
    Get-ChildItem -LiteralPath $PrivateDir -Filter '*.ps1' -File |
    Sort-Object Name
)

$PublicFiles = @(
    Get-ChildItem -LiteralPath $PublicDir -Filter '*.ps1' -File |
    Sort-Object Name
)

foreach ($file in $privateFiles) {
    Assert-SingleFunctionFile -File $file -RequireNameMatch | Out-Null
}

$ExportList = @(foreach ($file in $publicFiles) {
    $function = Assert-SingleFunctionFile -File $file -RequireNameMatch
    $function.Name
}) | Sort-Object


$ModuleContent = @(
    '# ==========================================',
    '# Auto-generated. Do not edit directly.',
    '# ==========================================',
    ''

    foreach ($File in $privateFiles) {
        "# --- Private Region: $($File.Name) ---"
        Get-Content -LiteralPath $File.FullName -Raw
        "# --- EndRegion: $($File.Name) ---"
        ''
    }

    foreach ($File in $PublicFiles) {
        "# --- Region: $($File.Name) ---"
        Get-Content -LiteralPath $File.FullName -Raw
        "# --- EndRegion: $($File.Name) ---"
        ''
    }

    if ($ExportList.Count -gt 0) {
        $quotedExportList = @(
            $ExportList | ForEach-Object {
                ConvertTo-PowerShellStringLiteral $_
            }
        )

        "Export-ModuleMember -Function @($($quotedExportList -join ', '))"
    }
    else {
        'Export-ModuleMember -Function @()'
    }
)

Set-Content `
    -LiteralPath $ModulePath `
    -Value ($ModuleContent -join [Environment]::NewLine) `
    -Encoding utf8NoBOM

Write-Host "OK: Wrote $ModulePath" -ForegroundColor Green

$Manifest = Import-PowerShellDataFile -LiteralPath $ManifestPath

$CurrentFunctions = if ($Manifest.ContainsKey('FunctionsToExport')) {
    $Manifest.FunctionsToExport
}
else {
    @()
}

if (-not (Test-SameList -A $CurrentFunctions -B $ExportList)) {
    Update-ModuleManifest `
        -Path $ManifestPath `
        -FunctionsToExport $Functions

    Write-Host "OK: Updated FunctionsToExport in $ManifestPath" -ForegroundColor Green
}
else {
    Write-Host "INFO: FunctionsToExport unchanged" -ForegroundColor DarkGray
}

Write-Host "Done: Build completed. Run: Import-Module .\O.Ps.psd1 -Force" -ForegroundColor Cyan
