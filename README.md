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
| `compare.html` | 案比較ページ + 提案ドキュメント入口 |
| `crm.html` | 顧客管理システム提案 |
| `pricing.html` | 料金プラン (初期286,000円 / 月額35,000円 / 一括5%OFF) |
| `roadmap.html` | 導入ロードマップ (Phase 1〜4) |
| `contract.html` | 業務委託契約書・守秘義務条項 雛形 |
| `docs/asset-inventory.html` | 既存資産棚卸しドキュメント |
| `assets/pdf/menu.pdf` | 出前メニュー（2026年3月版） |
| `assets/pdf/chirashi.pdf` | 宅配琳蘭 保存版チラシ |

## 運用メモ

- `gate.html` 認証は SHA-256 ハッシュ照合の **カジュアル barrier** で、検索エンジン除外（noindex）も併用しています
- 強固な認証ではありません。第三者にURL+パスワードが流出した場合は中身が見えます
- パスワード変更は `gate.html` および `assets/js/gate.js` の `EXPECTED` を更新（SHA-256 of 新パスワード）
