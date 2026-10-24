#!/usr/bin/env bash
# Runs `flutter pub get`, `flutter analyze` and `flutter test` in the shared
# package and in every lesson project, then prints a summary.
#
#   scripts/check.sh            # everything
#   scripts/check.sh 07 34      # only lessons/07-* and lessons/34-*
#
# Exits non-zero if any project fails.
set -uo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

projects=()
failed=()
if [ "$#" -eq 0 ]; then
  projects+=(packages/lesson_kit)
  for dir in lessons/*/; do projects+=("${dir%/}"); done
else
  for n in "$@"; do
    found=0
    for dir in lessons/"$n"-*/; do
      [ -d "$dir" ] && projects+=("${dir%/}") && found=1
    done
    if [ "$found" -eq 0 ]; then
      printf 'WARNING: No lesson folder matches lessons/%s-*\n' "$n" >&2
      failed+=("lessons/$n-* (no such lesson)")
    fi
  done
fi

total=0
for project in "${projects[@]}"; do
  printf '== %s\n' "$project"
  if ! (cd "$project" && flutter pub get >/dev/null); then
    failed+=("$project (pub get)")
    continue
  fi
  if ! (cd "$project" && flutter analyze --no-pub >/dev/null); then
    (cd "$project" && flutter analyze --no-pub) || true
    failed+=("$project (analyze)")
  fi
  if ! out="$(cd "$project" && flutter test --no-pub -r expanded 2>&1)"; then
    printf '%s\n' "$out" | tail -n 30
    failed+=("$project (test)")
  fi
  count="$(printf '%s\n' "$out" | sed -n 's/.*+\([0-9][0-9]*\).*All tests passed.*/\1/p' | tail -n 1)"
  printf '   %s tests\n' "${count:-?}"
  total=$((total + ${count:-0}))
done

printf '\n%d projects, %d tests passed\n' "${#projects[@]}" "$total"
if [ "${#failed[@]}" -gt 0 ]; then
  printf 'FAILED:\n'
  printf '  %s\n' "${failed[@]}"
  exit 1
fi
