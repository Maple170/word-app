# 英単語帳アプリ

Flutter で開発した iOS 向け英単語学習アプリです。

---

## スクリーンショット

| 単語帳 | フラッシュカード | 学習進捗 |
|--------|----------------|---------|
| 単語の一覧・追加・編集・削除 | カードをめくって暗記 | 暗記率と学習履歴を確認 |

---

## 機能

- **単語帳管理** — 英単語・日本語訳・例文を登録。スワイプで編集・削除。★で暗記済みマーク
- **フラッシュカード** — タップでカードをめくる学習モード。「覚えた！」「もう一度」で仕分け
- **学習進捗** — 暗記率グラフ・総単語数・よく学習した単語 TOP5 を表示
- **検索・フィルター** — 単語名で検索、暗記済み／未暗記で絞り込み

---

## 技術スタック

| 項目 | 内容 |
|------|------|
| フレームワーク | Flutter 3.x |
| 言語 | Dart |
| 状態管理 | Provider |
| データ保存 | Hive（端末内ローカル保存） |
| 対応OS | iOS 13.0 以上 |

---

## 使用パッケージ

- [hive_flutter](https://pub.dev/packages/hive_flutter) — ローカルデータベース
- [provider](https://pub.dev/packages/provider) — 状態管理
- [flip_card](https://pub.dev/packages/flip_card) — フラッシュカードのアニメーション
- [flutter_slidable](https://pub.dev/packages/flutter_slidable) — スワイプアクション

---

## セットアップ

```bash
# リポジトリをクローン
git clone https://github.com/Maple170/word-app.git
cd word-app

# 依存関係をインストール
flutter pub get

# iOSシミュレーターで起動
flutter run
```

実機で動かす場合は Xcode でコード署名（Apple ID）を設定してください。

---

## 開発背景

英単語学習ツールを自分で使いたいという動機から開発しました。
シンプルな UI と直感的な操作を意識し、毎日の学習習慣が続けやすい設計にしています。
