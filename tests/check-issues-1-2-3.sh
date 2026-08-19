#!/usr/bin/env bash
# Checks the three reported behaviours on the rendered pages.
set -euo pipefail
cd "$(dirname "$0")/.."

if ! python3 -c "import PIL" 2>/dev/null; then
  echo "skip  issues-1-2-3 (python3 Pillow absent)"
  exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
typst compile tests/test-issues-1-2-3.typ "$tmp/p-{p}.png" --root . --ppi 150
pdf="$tmp/t.pdf"
typst compile tests/test-issues-1-2-3.typ "$pdf" --root .

status=0
say() {
  if [ "$1" = ok ]; then echo "ok    $2"; else echo "FAIL  $2"; status=1; fi
}

text_of() { pdftotext -f "$1" -l "$1" "$pdf" - | tr -s ' \n' ' '; }

# 2 — the addition survives and the item is not repeated
p1=$(text_of 1)
case "$p1" in
  *"What is 2 + 2?"*) ;;
  *) say fail "issue #2 : l'addition est cassee ($p1)"; ;;
esac
if [ "$(echo "$p1" | grep -o 'a)' | wc -l)" = "1" ]; then
  say ok "issue #2 : un seul item, l'addition intacte"
else
  say fail "issue #2 : item repete ($p1)"
fi

# 2 — the array spells the list out
p2=$(text_of 2)
case "$p2" in
  *"a) One"*"b) Two"*"c) Three"*) say ok "issue #2 : la forme tableau donne trois items" ;;
  *) say fail "issue #2 : forme tableau ($p2)" ;;
esac

# 3 — label follows the document numbering, and its next level when nested
p3=$(text_of 3)
case "$p3" in
  *"1) First"*"2) Second"*) say ok "issue #3 : la numerotation du document est suivie" ;;
  *) say fail "issue #3 : numerotation ($p3)" ;;
esac
p4=$(text_of 4)
case "$p4" in
  *"1) Outer"*"a) inner one"*"b) inner two"*) say ok "issue #3 : niveau suivant en imbrique" ;;
  *) say fail "issue #3 : imbrique ($p4)" ;;
esac

# 1 — dotted answer lines are drawn
python3 - "$tmp" <<'PY'
from PIL import Image
import sys
im = Image.open(sys.argv[1] + "/p-5.png").convert("L")
w, h = im.size
px = im.load()
# a dotted rule is a row with many small ink runs spread across the width
best = 0
for y in range(h):
    xs = [x for x in range(w) if px[x, y] < 128]
    if len(xs) < 20:
        continue
    runs = 1
    for a, b in zip(xs, xs[1:]):
        if b - a > 1:
            runs += 1
    if xs[-1] - xs[0] > 0.3 * w:
        best = max(best, runs)
if best >= 20:
    print("ok    issue #1 : lignes pointillees tracees (%d points sur la ligne)" % best)
else:
    print("FAIL  issue #1 : pas de ligne pointillee trouvee (max %d)" % best)
    raise SystemExit(1)
PY
[ $? -eq 0 ] || status=1
exit $status
