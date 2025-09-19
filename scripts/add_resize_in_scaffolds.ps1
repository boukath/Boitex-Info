$ErrorActionPreference = "Stop"
$files = @(
  "lib/features/sections/interventions_page.dart",
  "lib/features/sections/installations_page.dart",
  "lib/features/sections/repairs_sav_page.dart",
  "lib/features/sections/livraison_page.dart"
)

foreach ($f in $files) {
  if (-not (Test-Path $f)) { Write-Host "Skip (not found): $f"; continue }
  $c = Get-Content $f -Raw

  # Insert resizeToAvoidBottomInset: true after the first 'Scaffold(' if not present
  if ($c -notmatch "resizeToAvoidBottomInset\s*:") {
    $c = $c -replace "Scaffold\(", "Scaffold(resizeToAvoidBottomInset: true, "
    Set-Content -Path $f -Value $c -Encoding UTF8
    Write-Host "Patched resizeToAvoidBottomInset in: $f"
  } else {
    Write-Host "Already had resizeToAvoidBottomInset: $f"
  }
}

Write-Host "Done. Still wrap long Rows with ResponsiveWrapBar manually where needed."
