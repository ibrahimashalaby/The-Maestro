$ErrorActionPreference = 'Stop'
$port = 4174
$base = "http://127.0.0.1:$port/"
$serverScript = Join-Path $PSScriptRoot 'server.ps1'
. (Join-Path $PSScriptRoot 'load-env.ps1')
$serverReady = $false
$status = $null

try {
    Invoke-WebRequest -Uri $base -TimeoutSec 2 -UseBasicParsing | Out-Null
    $serverReady = $true
    $status = Invoke-RestMethod -Uri ($base + 'api/status') -TimeoutSec 2
} catch { }

function Read-SecretText([string]$Prompt) {
    $secure = Read-Host $Prompt -AsSecureString
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try { return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr); $secure.Dispose() }
}

$needsRestart = -not $serverReady -or -not $status -or -not $status.exaConfigured
if ($needsRestart) {
    if ([string]::IsNullOrWhiteSpace($env:EXA_API_KEY)) { $env:EXA_API_KEY = Read-SecretText 'Exa API key (entered securely; not saved to disk)' }
    if ([string]::IsNullOrWhiteSpace($env:EXA_API_KEY)) { throw 'An Exa API key is required for search.' }

    if ($serverReady) {
        $connection = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not $connection) { throw "Port $port is occupied by an unknown service. Stop it manually, then start Maestro again." }
        $owner = Get-CimInstance Win32_Process -Filter "ProcessId=$($connection.OwningProcess)" -ErrorAction SilentlyContinue
        $isMaestroServer = $owner -and (($owner.CommandLine -like "*$serverScript*") -or ($owner.CommandLine -like "*-File .\outputs\server.ps1*"))
        if (-not $isMaestroServer) { throw "Port $port is occupied by another service. Maestro will not stop a process it did not start." }
        Stop-Process -Id $connection.OwningProcess -Force
        for ($i = 0; $i -lt 20; $i++) {
            Start-Sleep -Milliseconds 200
            if (-not (Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue)) { break }
        }
    }

    $quotedServer = '"' + $serverScript + '"'
    Start-Process -FilePath (Join-Path $PSHOME 'powershell.exe') -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',$quotedServer,'-Port',"$port") -WindowStyle Hidden | Out-Null
    for ($i = 0; $i -lt 30; $i++) {
        Start-Sleep -Milliseconds 350
        try {
            Invoke-WebRequest -Uri $base -TimeoutSec 2 -UseBasicParsing | Out-Null
            $status = Invoke-RestMethod -Uri ($base + 'api/status') -TimeoutSec 2
            if ($status.exaConfigured) { $serverReady = $true; break }
        } catch { }
    }
}

if (-not $serverReady -or -not $status -or -not $status.exaConfigured) {
    throw "Maestro could not start with Exa ready. Check that port $port is available and the Exa API key is valid."
}

$edgeCandidates = @(
    (Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application\msedge.exe'),
    (Join-Path $env:ProgramFiles 'Microsoft\Edge\Application\msedge.exe')
) | Where-Object { $_ -and (Test-Path -LiteralPath $_) }
$edge = $edgeCandidates | Select-Object -First 1
if (-not $edge) {
    $command = Get-Command msedge.exe -ErrorAction SilentlyContinue
    if ($command) { $edge = $command.Source }
}
if ($edge) { Start-Process -FilePath $edge -ArgumentList "--app=$base" }
else { Start-Process $base; Write-Host 'Opened Maestro in your default browser. Install it as an app from that browser Apps menu.' }
if (-not $status.llmConfigured) { Write-Warning 'Exa search is ready. Add ANTHROPIC_API_KEY to .env to enable AI chat and generated solution plans.' }
