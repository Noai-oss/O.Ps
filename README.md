# O.Ps

Personal PowerShell helper module.

## Requirements

- PowerShell 7+
- Windows
- Git
- [Just](#develop) (Optional for develop)

## Build

```powershell
.\build.ps1
```

This generates `O.Ps.psm1` from `src/Public/*.ps1` and updates `O.Ps.psd1`.

## Install

Install or update from Github:

```powershell
.\install.ps1
# or
irm https://raw.githubusercontent.com/Noai-oss/O.Ps/main/install.ps1 | iex
```

Install from the current local checkout:

```powershell
.\install.ps1 -LocalPath .
```

Install for all users:

```powershell
.\install.ps1 -Scope AllUsers
```

Install for this shell session

```powershell
Import-Module ./O.Ps.psd1 -Force
```

## Develop

```powershell
# run build.ps1
just build # just b

# install and activate in current shell
just install # just i
```

## Usage

After installation, open a new PowerShell session and run the commands directly.
PowerShell will auto-load the module.

Available commands:

| Command | Description |
| --- | --- |
| `export` | Set an environment variable using `NAME=value`. |
| `gcd` | Check out the default branch of `upstream`, or `origin` if no upstream remote exists. |
| [`Get-RemoteFileHash`](docs/commands/Get-RemoteFileHash.md) | Compute a remote file's hash. |
| `gfo` | Fetch from `origin`. |
| `gfu` | Fetch from `upstream`. |
| `gloc` | Pull the current branch from `origin`. |
| `gpoc` | Push the current branch to `origin`. |
| `gpof` | Push the current branch to `origin` with `--force-with-lease`. |
| `guser` | Show or apply a predefined Git user identity. |
| `proxyOff` | Clear the HTTP and HTTPS proxy environment variables. |
| `proxyOn` | Set the HTTP and HTTPS proxy to `http://127.0.0.1:7897`. |
| `unset` | Remove an environment variable. |
| `va` | Activate a Python virtual environment; defaults to `.venv`. |
| `vda` | Deactivate the current Python virtual environment. |
