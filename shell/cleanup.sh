#!/bin/bash

# 引数チェック
if [ $# -ne 1 ] && [ $# -ne 2 ]; then
  echo "使用方法: $0 <ディレクトリパス> [--yes]"
  exit 1
fi

TARGET_DIR="$1"

# スクリプトが置かれているディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 設定ファイルの場所
CONFIG_FILE="${SCRIPT_DIR}/cleanup.conf"

# 設定ファイルからログディレクトリを読み取る（デフォルト: /var/log）
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
else
  echo "エラー: cleanup.confが存在しません: $CONFIG_FILE"
  exit 1
fi
LOG_DIR=${LOG_DIR:-"$HOME/logs"}

# 指定ディレクトリが存在するか確認
if [ ! -d "$TARGET_DIR" ]; then
  echo "エラー: 指定されたディレクトリが存在しません: $TARGET_DIR"
  exit 1
fi

# 日付を YYYYMMDD_HH:mm の形式で取得
TIMESTAMP=$(date +"%Y%m%d_%H%M")

# ログファイルの指定
LOG_FILE="${LOG_DIR}/${TIMESTAMP}_file_cleanup.log"
touch $LOG_FILE

# 削除前のファイル数をカウント
FILE_COUNT_BEFORE=$(find "$TARGET_DIR" -type f | wc -l)

# 削除前のディレクトリ内容（5行分のみ）を取得
FILE_LIST_BEFORE=$(ls -al "$TARGET_DIR" | sed -n '4,8p')

# 削除前の全ファイル・フォルダ一覧を取得
FULL_LIST_BEFORE=$(ls -al "$TARGET_DIR")

# 削除前の情報をログに記録し、標準出力にも表示
{
  echo "=== $(date) ==="
  echo "削除対象ディレクトリ: $TARGET_DIR"
  echo "削除対象のファイル数: $FILE_COUNT_BEFORE"
  echo "削除前のディレクトリ内容（5行分のみ表示）:"
  echo "$FILE_LIST_BEFORE"
} | tee -a "$LOG_FILE"

# 削除前の全リストをログに記録
{
  echo "削除前の全ファイル・フォルダ一覧:"
  echo "$FULL_LIST_BEFORE"
} >> "$LOG_FILE"

# 引数に --yes が含まれているか確認
AUTO_CONFIRM=false
if [[ "$2" == "--yes" ]]; then
  AUTO_CONFIRM=true
fi

# 削除実行の確認プロンプト
if [ "$AUTO_CONFIRM" = false ]; then
  read -p "本当に削除を実行しますか？ (y/N): " CONFIRMATION
  if [[ "$CONFIRMATION" != "y" && "$CONFIRMATION" != "Y" ]]; then
    echo "削除処理をキャンセルしました。"
    exit 0
  fi
fi

# 指定ディレクトリ内のファイルを削除
rm -rf "$TARGET_DIR"/* "$TARGET_DIR"/.*

# ゴミ箱を空にする
TRASH_DIR="$HOME/.local/share/Trash/files"
if [ -d "$TRASH_DIR" ]; then
  echo "ゴミ箱のクリア: $TRASH_DIR" | tee -a "$LOG_FILE"
  rm -rf "$TRASH_DIR"/*
fi

# 削除後のファイル数をカウント
FILE_COUNT_AFTER=$(find "$TARGET_DIR" -type f | wc -l)

# 削除後の全ファイル・フォルダ一覧を取得
FULL_LIST_AFTER=$(ls -al "$TARGET_DIR")

# 削除後の情報をログに記録
{
  echo "削除後のファイル数: $FILE_COUNT_AFTER"
  echo "削除後の全ファイル・フォルダ一覧:"
  echo "$FULL_LIST_AFTER"
  echo "クリーンアップ完了"
} | tee -a "$LOG_FILE"

echo "クリーンアップ完了: $TARGET_DIR"