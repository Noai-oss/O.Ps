# Get-RemoteFileHash

Compute a remote file's hash directly from its download stream.

## Parameters

| Parameter | Description |
| --- | --- |
| `-Url` | Required URL. Accepts the first positional argument or pipeline input. |
| `-Algorithm` | `SHA1`, `SHA256`, `SHA384`, `SHA512`, or `MD5`. Defaults to `SHA256`. |

## Examples

```powershell
# SHA256 is the default algorithm.
Get-RemoteFileHash 'https://example.com/file.zip'

# Choose SHA1, SHA256, SHA384, SHA512, or MD5.
Get-RemoteFileHash -Url 'https://example.com/file.zip' -Algorithm SHA512

# Process multiple URLs from the pipeline.
'https://example.com/a.zip', 'https://example.com/b.zip' |
    Get-RemoteFileHash
```
