# file-cleanup-tools-for-mac

特定ディレクトリのデータを全部消して、そのままゴミ箱も空にするツール。

## 機能

- 指定したディレクトリ内の全ファイルを削除
- ゴミ箱を空にする
- 操作の確認ダイアログ表示

## インストール

1. リポジトリをクローンします:
    ```sh
    git clone https://github.com/ユーザー名/file-cleanup-tools-for-mac.git
    ```
2. 実行権限を付与:
    ```sh
    cd shell/file-cleanup-tools-for-mac
    chmod +x cleanup.sh
    ```

## 使い方

1. 消したいディレクトリを引数にしてスクリプトを実行します:
    ``` bash
    sudo ./cleanup.sh /path/to/directory
    ```
2. 確認ダイアログに従って操作を完了します。

## 貢献

1. リポジトリをフォークします
2. 新しいブランチを作成します (`git checkout -b feature/新機能`)
3. 変更をコミットします (`git commit -am 'Add some 新機能'`)
4. ブランチにプッシュします (`git push origin feature/新機能`)
5. プルリクエストを作成します

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細については、[LICENSE](http://_vscodecontentref_/0)ファイルを参照してください。