$ErrorActionPreference = "Stop"

$files = @(
  "lib/features/sections/interventions_page.dart",
  "lib/features/sections/installations_page.dart"
)

foreach ($f in $files) {
  if (-not (Test-Path $f)) {
    Write-Host "Skip (not found): $f"
    continue
  }
  $content = Get-Content $f -Raw
  $pattern = 'final\s+isClient\s*=\s*widget\.user\.role\s*==\s*UserRole\.Client;'
  $replacement = 'final isClient = false; // Client role removed'
  $newContent = [regex]::Replace($content, $pattern, $replacement)
  if ($newContent -ne $content) {
    Set-Content -Path $f -Value $newContent -Encoding UTF8
    Write-Host "Patched: $f"
  } else {
    Write-Host "No change needed: $f"
  }
}

Write-Host "Done. Now run: flutter clean; flutter pub get; flutter run"
