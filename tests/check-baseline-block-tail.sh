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

def offset(path):
    """Bottom of the label minus top of the formula, on the first line only."""
    im = Image.open(path).convert("L")
    w, h = im.size
    px = im.load()

    # The figure spans most of the width; everything above it is the first line
    limit = h
    for y in range(h):
        if sum(1 for x in range(w) if px[x, y] < 200) > 0.4 * w:
            limit = y - 3
            break

    cols = [x for x in range(w) if any(px[x, y] < 128 for y in range(limit))]
    if not cols:
        raise SystemExit("FAIL  %s : aucune encre sur la premiere ligne" % path)
    runs, s0, p0 = [], cols[0], cols[0]
    for x in cols[1:]:
        if x - p0 > 10:
            runs.append((s0, p0))
            s0 = x
        p0 = x
    runs.append((s0, p0))
    if len(runs) < 2:
        raise SystemExit("FAIL  %s : une seule colonne d'encre" % path)
    label, content = runs[0], runs[1]
    # How far below the top of the formula the label starts. Top-aligned, the
    # label starts level with it (about 0); baseline-aligned, it starts well
    # below, since a display fraction rises above the baseline it sits on.
    label_top = min(y for y in range(limit)
                    if any(px[x, y] < 128 for x in range(label[0], label[1] + 1)))
    content_top = min(y for y in range(limit)
                      if any(px[x, y] < 128 for x in range(content[0], content[1] + 1)))
    return label_top - content_top

with_block = offset(sys.argv[1] + "/p-1.png")
without = offset(sys.argv[1] + "/p-2.png")
if abs(with_block - without) <= 3:
    print("ok    label sur la meme ligne de base avec et sans bloc (%+d vs %+d px)"
          % (with_block, without))
else:
    print("FAIL  label remonte de %d px par le bloc qui suit (%+d vs %+d)"
          % (abs(with_block - without), with_block, without))
    raise SystemExit(1)
PY
