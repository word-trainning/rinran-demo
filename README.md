# 出前中華りんらん リニューアル提案デモ

関係者向けのデザイン提案デモサイトです。

## アクセス方法

公開 URL: `https://word-trainning.github.io/rinran-demo/`

トップは `gate.html` のパスワードページに自動誘導されます。関係者にお渡ししたパスワードを入力してください。

## 構成

| ファイル | 内容 |
| --- | --- |
| `gate.html` | パスワードゲート（最初に表示される） |
| `index.html` | A案 トップ（高級洗練） |
| `index-osaka.html` | B案 トップ（大阪元気 × 仕出し洗練） |
| `corporate.html` / `corporate-osaka.html` | 法人仕出しページ |
| `delivery.html` / `delivery-osaka.html` | 個別配達ページ |
| `quote.html` / `quote-osaka.html` | お見積もりフォーム |
| `compare.html` | （旧）案比較ページ → 現在は `pricing.html` への自動リダイレクト stub |
| `pricing.html` | 料金プラン（提案の主軸ページ）。下部に導入ロードマップ・契約書・CRM・受注者TODO・既存資産棚卸しの分岐リンク |
| `crm.html` | 顧客管理システム提案 |
| `pricing.html` | 料金プラン (初期286,000円 / 一括5%OFF / 月額プランは別途相談) |
| `roadmap.html` | 導入ロードマップ (Phase 1〜4) |
| `contract.html` | 業務委託契約書・守秘義務条項 雛形 |
| `docs/asset-inventory.html` | 既存資産棚卸しドキュメント |
| `assets/pdf/menu.pdf` | 出前メニュー（2026年3月版） |
| `assets/pdf/chirashi.pdf` | 宅配琳蘭 保存版チラシ |
| `vendor-checklist.html` | 受注者 (hp-factory) 作業チェックリスト。閲覧モード/編集モード切替あり |
| `progress.json` | 受注者進捗の SoT。vendor-checklist.html が起動時に fetch して反映 |
| `update-progress.sh` | progress.json 更新 → commit → push のワンライナー補助スクリプト |
| `internal-only.html` | 受注者の内部管理ページ（.gitignore で GitHub 非公開、ローカル限定） |

## 運用メモ

- `gate.html` 認証は SHA-256 ハッシュ照合の **カジュアル barrier** で、検索エンジン除外（noindex）も併用しています
- 強固な認証ではありません。第三者にURL+パスワードが流出した場合は中身が見えます
- パスワード変更は `gate.html` および `assets/js/gate.js` の `EXPECTED` を更新（SHA-256 of 新パスワード）

## 受注者進捗の更新方法

### かんたん 3 ステップ

1. ブラウザで `vendor-checklist.html?edit=1` を開いてチェックを更新
2. 「📥 進捗を保存 (ダウンロード)」ボタンを押す
3. 画面に出てくる **「次のコマンド」をコピー → ターミナルに貼り付けて Enter**
   - 自動で `progress.json` 更新 → commit → push まで完了
   - 「✅ 完了！」と出れば成功

### 初回だけセットアップ (任意・楽になる)

`~/.bashrc` に以下を追記すると、次回からは `rinran-push` と打つだけで完了します：

```bash
echo "alias rinran-push='cd ~/hp-factory-demo/clients/rinran && ./update-progress.sh'" >> ~/.bashrc && source ~/.bashrc
```

### 店主側の閲覧 URL

`https://word-trainning.github.io/rinran-demo/vendor-checklist.html`（パスワード入力後）

GitHub Pages の反映に push 後 30 秒〜1 分かかります。
