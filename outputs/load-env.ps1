# Load only Maestro's known settings from the workspace root .env file.
$envFile = Join-Path (Split-Path -Parent $PSScriptRoot) '.env'
if (Test-Path -LiteralPath $envFile) {
    foreach ($line in Get-Content -LiteralPath $envFile) {
        if ($line -match '^\s*(EXA_API_KEY|ANTHROPIC_API_KEY|ANTHROPIC_MODEL|LLM_PROVIDER|MAESTRO_PUBLIC_MODE|MAESTRO_ALLOWED_ORIGIN|MAESTRO_BIND_LOCALHOST|APP_ACCESS_PASSWORD|APP_SESSION_SECRET)\s*=\s*(.*?)\s*$') {
            $name = $Matches[1]
            $value = $Matches[2].Trim().Trim('"').Trim("'")
            # An explicit empty assignment clears inherited credentials that may be stale.
            [Environment]::SetEnvironmentVariable($name, $value, 'Process')
        }
    }
}
