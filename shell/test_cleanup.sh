#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

setUp() {
  # テスト用のディレクトリを作成
  mkdir -p test_dir
  echo "test file" > test_dir/test_file.txt

  mv $SCRIPT_DIR/cleanup.conf $SCRIPT_DIR/cleanup.conf.backup
  echo 'LOG_DIR="test_dir"' > $SCRIPT_DIR/cleanup.conf
}

tearDown() {
  テスト用のディレクトリを削除
  rm -rf test_dir
  mv $SCRIPT_DIR/cleanup.conf.backup $SCRIPT_DIR/cleanup.conf
}

testArgumentCheck() {
  output=$(sh $SCRIPT_DIR/cleanup.sh)
  assertEquals "Expected : Actual ==" "使用方法: $SCRIPT_DIR/cleanup.sh <ディレクトリパス> [--yes]" "$output"
}

# testConfFileExists() {
#   mv $SCRIPT_DIR/cleanup.conf $SCRIPT_DIR/cleanup.conf.tmp
#   output=$(sh $SCRIPT_DIR/cleanup.sh test_dir --yes)
#   assertContains "Expected : Actual ==" "エラー: cleanup.confが存在しません: ${SCRIPT_DIR}/cleanup.conf" "$output"
#   mv $SCRIPT_DIR/cleanup.conf.tmp $SCRIPT_DIR/cleanup.conf
# }

# testDirectoryNotExists() {
#   output=$(sh $SCRIPT_DIR/cleanup.sh test_dir --yes)
#   assertEquals "エラー: 指定されたディレクトリが存在しません: non_existing_dir" "$output"
# }

# testFileCountBefore() {
#   output=$(sh $SCRIPT_DIR/cleanup.sh test_dir --yes)
#   assertContains "$output" "削除対象のファイル数: 1"
# }

# testCleanup() {
#   ./cleanup.sh test_dir <<< "y"
#   assertFalse "[ -d test_dir ]"
# }

# shunit2の実行
. shunit2