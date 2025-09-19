#!/usr/bin/env bash
set -euo pipefail

targets=(
  "lib/features/sections/interventions_page.dart"
  "lib/features/sections/installations_page.dart"
  "lib/features/sections/repairs_sav_page.dart"
  "lib/features/sections/livraison_page.dart"
)

for f in "${targets[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "Skip (not found): $f"
    continue
  fi

  # Add import if missing
  if ! grep -q "import '../common/ui/overflow_fixes.dart';" "$f"; then
    awk '
      BEGIN{added=0}
      {
        print $0
        if ($0 ~ /^\s*import /) last=NR
      }
      END{
        # Not inserting here in awk; post-process with sed
      }
    ' "$f" > "$f.tmp"

    # Insert the import after last import line
    awk -v add="import '"'"'../common/ui/overflow_fixes.dart'"'"';" '
      { lines[NR]=$0 }
      END{
        last=0
        for (i=1;i<=NR;i++) if (lines[i] ~ /^\s*import /) last=i
        for (i=1;i<=NR;i++){
          print lines[i]
          if (i==last) print add
        }
      }
    ' "$f" > "$f.tmp2" && mv "$f.tmp2" "$f"
    rm -f "$f.tmp"
    echo "Added import in: $f"
  fi

  # Replace Scaffold( with OverflowSafeScaffold(
  if ! grep -q "OverflowSafeScaffold(" "$f"; then
    sed -E -i.bak 's/Scaffold\(/OverflowSafeScaffold(/g' "$f"
    echo "Wrapped Scaffold in: $f"
  else
    echo "Already wrapped: $f"
  fi
done

echo "Done. Rebuild the app."
