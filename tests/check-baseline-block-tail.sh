#!/usr/bin/env bash
# An item that opens with a formula and continues with a block must keep its
# label on the baseline of that first line. The fixture renders the same item
# with and without the trailing block; the label must land in the same place
# relative to the formula in both.
set -euo pipefail
cd "$(dirname "$0")/.."

if ! python3 -c "import PIL" 2>/dev/null; then
  echo "skip  baseline-block-tail (python3 Pillow absent)"
  exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
typst compile tests/test-baseline-block-tail.typ "$tmp/p-{p}.png" --root . --ppi 200

python3 - "$tmp" <<'PY'
import sys
from PIL import Image

def label_top(path):
    """Top of the item label, in page coordinates.

    Both pages open with the same first line, so the label has to land at the
    same height on each. Top-aligned in a row whose first line is tall (a
    display fraction), it rides up; baseline-aligned it does not.
    """
    im = Image.open(path).convert("L")
    w, h = im.size
    px = im.load()
    rows = [y for y in range(h) if any(px[x, y] < 128 for x in range(0, w, 2))]
    if not rows:
        raise SystemExit("FAIL  %s : page vide" % path)
    # first horizontal band of ink = the item's first line
    end = rows[0]
    for y in rows[1:]:
        if y - end > 6:
            break
        end = y
    cols = [x for x in range(w) if any(px[x, y] < 128 for y in range(rows[0], end + 1))]
    # first column run is the label
    last = cols[0]
    label_cols = [cols[0]]
    for x in cols[1:]:
        if x - last > 10:
            break
        label_cols.append(x)
        last = x
    return min(y for y in range(rows[0], end + 1)
               if any(px[x, y] < 128 for x in label_cols))

with_block = label_top(sys.argv[1] + "/p-1.png")
without = label_top(sys.argv[1] + "/p-2.png")
if abs(with_block - without) <= 2:
    print("ok    le label est a la meme hauteur avec et sans le bloc (y=%d vs %d)"
          % (with_block, without))
else:
    print("FAIL  le bloc qui suit fait remonter le label de %d px (y=%d vs %d)"
          % (without - with_block, with_block, without))
    raise SystemExit(1)
PY
