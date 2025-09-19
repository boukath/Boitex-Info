$ErrorActionPreference = "Stop"

$targets = @(
  "lib/features/sections/interventions_page.dart",
  "lib/features/sections/installations_page.dart",
  "lib/features/sections/repairs_sav_page.dart",
  "lib/features/sections/livraison_page.dart"
)

foreach ($file in $targets) {
  if (-not (Test-Path $file)) {
    Write-Host "Skip (not found): $file"
    continue
  }

  $content = Get-Content $file -Raw

  # 1) Add import if missing
  if ($content -notmatch "import '../common/ui/overflow_fixes.dart';") {
    # Insert after the last import line
    $lines = $content -split "`r?`n"
    $lastImportIndex = -1
    for ($i = 0; $i -lt $lines.Length; $i++) {
      if ($lines[$i] -match '^\s*import\s+') { $lastImportIndex = $i }
    }
    if ($lastImportIndex -ge 0) {
      $lines = $lines[0..$lastImportIndex] + @("import '../common/ui/overflow_fixes.dart';") + $lines[($lastImportIndex+1)..($lines.Length-1)]
      $content = ($lines -join "`r`n")
      Write-Host "Added import in: $file"
    }
  }

  # 2) Replace Scaffold( with OverflowSafeScaffold(
  if ($content -notmatch "OverflowSafeScaffold\(") {
    $content = $content -replace "Scaffold\(", "OverflowSafeScaffold("
    Write-Host "Wrapped Scaffold in: $file"
  } else {
    Write-Host "Already wrapped: $file"
  }

  Set-Content -Path $file -Value $content -Encoding UTF8
}

Write-Host "Done. Rebuild the app."
