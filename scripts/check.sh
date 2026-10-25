#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd -- "$project_dir"

./scripts/build-pdfs.sh
mkdir -p build
(
  cd lean
  lake build
  lake env lean Check.lean
) | tee build/lean-check.log

python3 - <<'PY'
from pathlib import Path
import re

text = Path('build/lean-check.log').read_text()
allowed = {'propext', 'Classical.choice', 'Quot.sound'}
if 'sorryAx' in text:
    raise SystemExit('Axiom audit failed: a listed theorem depends on sorryAx.')
for body in re.findall(r'depends on axioms:\s*\[([^]]*)\]', text, re.S):
    axioms = {name.strip() for name in body.split(',') if name.strip()}
    unexpected = axioms - allowed
    if unexpected:
        raise SystemExit(f'Axiom audit failed: {sorted(unexpected)}')
count = text.count('depends on axioms:') + text.count('does not depend on any axioms')
print(f'Builds passed; {count} principal theorem axiom checks passed.')
PY
