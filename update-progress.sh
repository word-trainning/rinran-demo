#!/usr/bin/env bash
# 受注者 (hp-factory) 専用: progress.json を更新して GitHub に push する補助スクリプト
#
# 使い方:
#   1. ブラウザで vendor-checklist.html?edit=1 を開いてチェック操作
#   2. 「📥 進捗を progress.json でダウンロード」ボタンを押す → ~/Downloads/progress.json が落ちる
#   3. このスクリプトを実行:
#        ./update-progress.sh
#      (引数なしの場合は ~/Downloads/progress.json を取り込む)
#      (引数ありの場合: ./update-progress.sh /path/to/downloaded/progress.json)
#   4. progress.json を上書き → commit → push まで自動で行う
#
# 失敗時は手動で:
#   cp ~/Downloads/progress.json progress.json
#   git add progress.json && git commit -m "chore: progress 更新" && git push origin main

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

SRC="${1:-$HOME/Downloads/progress.json}"
DEST="$SCRIPT_DIR/progress.json"

if [[ ! -f "$SRC" ]]; then
  echo "❌ ソースが見つかりません: $SRC"
  echo "   ブラウザでダウンロードしたファイルのパスを引数で指定してください。"
  echo "   例: ./update-progress.sh ~/Downloads/progress.json"
  exit 1
fi

# JSON 妥当性チェック
if ! python3 -c "import json,sys; json.load(open('$SRC'))" 2>/dev/null; then
  echo "❌ JSON として読めません: $SRC"
  exit 1
fi

# 進捗カウントを取得 (commit メッセージ用)
DONE=$(python3 -c "
import json
data = json.load(open('$SRC'))
checks = data.get('checks', {})
done = sum(1 for v in checks.values() if v)
print(done)
")

# 上書き
cp "$SRC" "$DEST"
echo "✅ progress.json を上書きしました ($DONE 項目チェック済み)"

# 差分が無ければ終了
if git diff --quiet -- "$DEST"; then
  echo "ℹ  変更なし。push をスキップします。"
  exit 0
fi

# git add → commit → push
git add "$DEST"
git commit -m "chore: 受注者進捗を更新 ($DONE 項目チェック済み)"
echo ""
echo "▶ push します…"
if git push origin main; then
  echo "✅ GitHub に push 完了"
  echo "   関係者は https://word-trainning.github.io/rinran-demo/vendor-checklist.html で最新状態を閲覧できます"
else
  echo ""
  echo "⚠ push に失敗しました。手元のコミットは作成済みです。"
  echo "   ご自身で以下を実行してください:"
  echo "     git push origin main"
fi
