#!/usr/bin/env bash
# 受注者 (hp-factory) 専用: progress.json を更新して GitHub に push する補助スクリプト
#
# 使い方 (どこから実行してもOK):
#   ./update-progress.sh
#     → ~/Downloads/progress.json を取り込んで commit & push
#
#   ./update-progress.sh /path/to/file.json
#     → 指定したファイルを取り込んで commit & push
#
# 楽にしたい場合は ~/.bashrc に以下を追加して `rinran-push` で実行可能:
#   alias rinran-push='cd ~/hp-factory-demo/clients/rinran && ./update-progress.sh'

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

SRC="${1:-$HOME/Downloads/progress.json}"
DEST="$SCRIPT_DIR/progress.json"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  受注者進捗を GitHub に反映します"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 1. ファイル存在確認
if [[ ! -f "$SRC" ]]; then
  echo "❌ ダウンロードしたファイルが見つかりません"
  echo ""
  echo "   探した場所: $SRC"
  echo ""
  echo "   対処方法:"
  echo "     ・ブラウザで「📥 進捗を保存」ボタンを押しましたか？"
  echo "     ・別の場所にダウンロードした場合は引数で指定してください:"
  echo "         ./update-progress.sh ~/Downloads/progress\\ (1).json"
  exit 1
fi
echo "📂 ダウンロードファイル: $SRC"

# 2. JSON 妥当性チェック
if ! python3 -c "import json,sys; json.load(open('$SRC'))" 2>/dev/null; then
  echo "❌ JSON として読めません: $SRC"
  echo "   ファイルが破損している可能性があります。再度ダウンロードしてください。"
  exit 1
fi

# 3. 進捗カウントを取得 (commit メッセージ用)
DONE=$(python3 -c "
import json
data = json.load(open('$SRC'))
checks = data.get('checks', {})
done = sum(1 for v in checks.values() if v)
print(done)
")
echo "📊 チェック済み項目数: $DONE"

# 4. 上書き
cp "$SRC" "$DEST"
echo "✅ progress.json を上書きしました"

# 5. 差分が無ければ終了
if git diff --quiet -- "$DEST"; then
  echo ""
  echo "ℹ  GitHub 側の状態と差分なし。push をスキップします。"
  echo "   (前回からチェック状態が変わっていません)"
  exit 0
fi

# 6. git commit
echo ""
echo "💾 コミット作成中…"
git add "$DEST"
git commit -m "chore: 受注者進捗を更新 ($DONE 項目チェック済み)" -q
echo "   完了"

# 7. push
echo ""
echo "🚀 GitHub に push 中…"
if git push origin main 2>&1 | sed 's/^/   /'; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  ✅ 完了！店主にも最新進捗が共有されました"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "   反映先 URL:"
  echo "   https://word-trainning.github.io/rinran-demo/vendor-checklist.html"
  echo ""
  echo "   (GitHub Pages の反映に 30秒〜1分かかります)"
else
  echo ""
  echo "⚠ push に失敗しました。コミットはローカルに残っています。"
  echo ""
  echo "   対処方法:"
  echo "     ・ネットワーク接続を確認して、もう一度実行: ./update-progress.sh"
  echo "     ・または手動で push: git push origin main"
  exit 1
fi
