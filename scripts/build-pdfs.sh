#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd -- "$project_dir"

mkdir -p build/latex output/pdf

build_document() {
  local source_file="$1"
  local output_name="$2"
  local pass
  for pass in 1 2 3; do
    if ! pdflatex -interaction=nonstopmode -halt-on-error \
      -output-directory=build/latex -jobname="$output_name" \
      "$source_file" > "build/latex/$output_name-build.log" 2>&1; then
      cat "build/latex/$output_name-build.log"
      return 1
    fi
  done
  if grep -Eq 'LaTeX Warning: (Reference|Citation).*undefined|There were undefined references|There were undefined citations|Overfull \\[hv]box' \
      "build/latex/$output_name.log"; then
    cat "build/latex/$output_name.log"
    return 1
  fi
  cp "build/latex/$output_name.pdf" "output/pdf/$output_name.pdf"
  printf 'Built output/pdf/%s.pdf\n' "$output_name"
}

build_document main.tex paper
build_document conceptual-map/main.tex conceptual-map
