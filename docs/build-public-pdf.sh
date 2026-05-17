#!/bin/bash
# 契約書PDF(公開版・振込口座情報なし)ビルドスクリプト
# 使い方: bash docs/build-public-pdf.sh
#
# - 入力: docs/contract-public.md (振込口座情報なし、振込先は payment.html 参照)
# - 出力: assets/pdf/contract.pdf (GitHub Pages 配信用)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

INPUT="$PROJECT_DIR/docs/contract-public.md"
OUTPUT="$PROJECT_DIR/assets/pdf/contract.pdf"

if [ ! -f "$INPUT" ]; then
  echo "ERROR: 入力ファイルが見つかりません: $INPUT"
  exit 1
fi

echo "→ $INPUT を PDF に変換中..."

pandoc "$INPUT" \
  -o "$OUTPUT" \
  --pdf-engine=xelatex \
  -V documentclass=article \
  -V mainfont="Noto Serif CJK JP" \
  -V CJKmainfont="Noto Serif CJK JP" \
  -V sansfont="Noto Sans CJK JP" \
  -V monofont="Noto Sans Mono CJK JP" \
  -V geometry:a4paper,margin=20mm \
  -V linkcolor=black \
  -V urlcolor=blue \
  -V colorlinks=true \
  --toc \
  --toc-depth=2 \
  --highlight-style=tango

if [ -f "$OUTPUT" ]; then
  SIZE=$(du -h "$OUTPUT" | cut -f1)
  echo "✅ 完成: $OUTPUT ($SIZE)"
  echo "→ 確認: xdg-open $OUTPUT"
  echo "→ GitHub Pages 配信URL: https://word-trainning.github.io/rinran-demo/assets/pdf/contract.pdf"
else
  echo "❌ PDF 生成に失敗しました"
  exit 1
fi
