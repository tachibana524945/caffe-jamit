#!/usr/bin/env sh
# 学習用データから平均画像を生成
# $CAFFE_ROOT/examples/imagenet/make_imagenet_mean.shを改変
# 

EXAMPLE=examples/jamit	#学習データへのパス
DATA=examples/jamit	#平均画像へのパス
TOOLS=build/tools	#各種バイナリファイルへのパス

# 出力ファイルの拡張子はbinaryproto
$TOOLS/compute_image_mean $EXAMPLE/jamit_train_lmdb \
  $DATA/jamit_mean.binaryproto

# 終了メッセージ
echo "Done."

