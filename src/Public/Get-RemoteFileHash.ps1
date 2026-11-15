function Get-RemoteFileHash {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]$Url,

        [ValidateSet('SHA1', 'SHA256', 'SHA384', 'SHA512', 'MD5')]
        [string]$Algorithm = 'SHA256'
    )

    process {
        $stream = $null
        $webClient = [System.Net.WebClient]::new()
        try {
            $stream = $webClient.OpenRead($Url)
            Get-FileHash -InputStream $stream -Algorithm $Algorithm
        }
        finally {
            if ($null -ne $stream) { $stream.Dispose() }
            $webClient.Dispose()
        }
    }
}
