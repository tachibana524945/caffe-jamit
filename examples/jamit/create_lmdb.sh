#!/usr/bin/env sh
# 画像データからlmdb形式の画像データベースを作成
# 各種パス・データベース名の設定が必要
# $CAFFE_ROOT/examples/imagenet/create_imagenet.shを改変
#
# 注:
# caffeの基本ライブラリへのパスが設定されていることが前提です。
# imagenetでは画像サイズを256x256で扱う必要があるため，

set -e

# パスの設定
EXAMPLE=examples/jamit		# データベースを保存するディレクトリ	
TOOLS=build/tools		# caffeの各種コマンドのディレクトリ

# 学習・テスト用の画像のディレクトリ
# 各画像リスト(train.txt, val.txt)がフォルダ配下に必要(l61,l71で指定)
DATA_ROOT=$HOME/caffe/downloadData/CT/

# 学習・テスト用のデータベース名
TRAIN_DATA_NAME=jamit_train_lmdb
VAL_DATA_NAME=jamit_val_lmdb

# Set RESIZE=true to resize the images to 256x256. Leave as false if images have
# already been resized using another tool.
RESIZE=false
if $RESIZE; then
  RESIZE_HEIGHT=256
  RESIZE_WIDTH=256
else
  RESIZE_HEIGHT=0
  RESIZE_WIDTH=0
fi

# 画像のディレクトリが存在するか確認
if [ ! -d "$DATA_ROOT" ]; then
  echo "Error: DATA_ROOT is not a path to a directory: $DATA_ROOT"
  echo "Set the DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the training adn validation data is stored."
  exit 1
fi

# データベースが既にある場合は既存のものを削除
if [ -d $EXAMPLE/$TRAIN_DATA_NAME ]; then 
    rm -rf $EXAMPLE/$TRAIN_DATA_NAME
fi 

if [ -d $EXAMPLE/$VAL_DATA_NAME ]; then 
    rm -rf $EXAMPLE/$VAL_DATA_NAME
fi


# データベースを作成
echo "Creating train lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle \
    $DATA_ROOT \
    $DATA_ROOT/train.txt \
    $EXAMPLE/$TRAIN_DATA_NAME

echo "Creating val lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle \
    $DATA_ROOT \
    $DATA_ROOT/val.txt \
    $EXAMPLE/$VAL_DATA_NAME

echo "Done."
