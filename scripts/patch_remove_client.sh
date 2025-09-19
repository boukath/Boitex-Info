#!/usr/bin/env bash
set -euo pipefail

for f in \
  lib/features/sections/interventions_page.dart \
  lib/features/sections/installations_page.dart
do
  if [[ -f "$f" ]]; then
    sed -E -i.bak 's/final[[:space:]]+isClient[[:space:]]*=[[:space:]]*widget\.user\.role[[:space:]]*==[[:space:]]*UserRole\.Client;/final isClient = false; \/\/ Client role removed/g' "$f"
    echo "Patched: $f"
  else
    echo "Skip (not found): $f"
  fi
done

echo "Done. Now run: flutter clean; flutter pub get; flutter run"
