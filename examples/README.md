# Caffeを用いた画像分類
サンプルデータは用意していません．

各画像データのパスとラベルを記したtrain.txtとval.txtは書き方の参考までにアップしています．

## 0. 各種ファイルについて
caffe/examples/imagenetのファイルを基にしています.

## 1. 環境について
画像データとソースコードは，以下のように配置しました．

平均画像を使用する方法については，紙面の都合上割愛したため，記していません．

> caffe/  
>>  ├── downloadData/  
>>>      ├── CT/ #画像データ  
>>>      ├── train.txt  
>>>      └── val.txt  
>>  └── examples/  
>>>      └── jamit/ #サンプル一式  

## 2. データベースの作成
create_lmdb.shのパスの設定，画像ディレクトリの指定，データベース名の指定を自分の環境に合わせて書き換え，caffe直下で以下のコマンドを実行する．

`./examples/jamit/create_lmdb.sh`


## 3. ネットワーク定義ファイルの準備
* train_val.prototxtがネットワーク定義ファイル．
* 定義ファイルの"data_param"の"source"の箇所を，作成したデータベース名に変更する．
* layer name "fc8"の"num_output"は2とする．
* batch sizeや畳み込み層のフィルタサイズなども，ネットワーク定義ファイルで指定する．

## 4. Solverの準備
* solver.prototxtで定義する
* ネットワーク定義ファイルパスを指定し，各種パラメータを設定する．

## 5. モデルの学習
caffe trainコマンドを利用してモデルの学習を実行する．

モデルを保存するmodelsディレクトリを作成していない場合は，作成しておく．

`mkdir examples/jamit/models`

caffe直下で以下のコマンドを実行する．

    caffe train --solver=./examples/jamit/solver.prototxt 
                --gpu=0

学習やテストのグラフを作成したい場合には，ログファイルを作業ディレクトリにコピーし，plot_training_log.pyを用いて作成する．

    cd examples/jamit/
    cp /tmp/caffe.INFO  ./
    python plot_training_log.py 6 save.png caffe.INFO

引数に指定した6は"Train loss  vs. Iters"のグラフタイプを作成するオプションである．

その他のタイプは`python plot_training_log.py`で確認できる．

## 6. 画像分類テストの実行
クラスラベルとカテゴリ名を記したテキストファイル(category.txt)とテスト画像(test.png)を準備し，classify.pyを用いて分類テストを実行する．

    python classify.py --model_def=deploy.prototxt 
                       --pretrained_model=./models/jamit_train_iter_5000.caffemodel 
                       test.png out.npy  category.txt

## 7. 転移学習について
転移学習をする場合には，学習済みモデルのレイヤー名と重複しないように，最後の全結合層”fc8”を別の名前に変更する必要がある．転移学習用に一部変更したファイルの例は以下の通りである．

* solver_vTL.prototxt (参照する定義ファイル，モデル名を変更)
* train_val_vTL.prototxt (fc8をfc8tlに変更)
* deploy_vTL.prototxt (fc8をfc8tlに変更)

また，実行は以下の通りである．

    caffe train --solver=./examples/jamit/solver_vTL.prototxt 
                --weights=./models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel 
                --gpu=0

## 8. 平均画像の作成と使用

誌面では，ページ数の都合上，平均画像の作成と使用については割愛させていただいた．

平均画像を使用する場合は，以下の処理を適宜追加すればよい．

(1) make_mean_image.shを用いて，平均画像(binaryproto形式)を作成する(caffe/直下)

`./examples/jamit/make_mean_image.sh `

(2) convert_binaryproto_to_npy.pyを用いて，binaryproto形式をnpy形式に変更する(examples/jamit/直下)

`python convert_binaryproto_to_npy.py jamit_mean.binaryproto jamit_mean.npy`

(3) ネットワーク定義ファイルtrain_val.prototxtの平均画像へのファイルパスのコメントを外す

(4) 学習実行後，分類テストで使用するclassify.pyの平均画像の読み込み命令のコメントを外し，実行時に平均画像を指定する．(examples/jamit/直下)

    python classify.py --model_def=deploy.prototxt 
                       --mean_file=jamit_mean.npy 
                       --pretrained_model=./models/jamit_train_iter_5000.caffemodel 
                       test.png out.npy  category.txt
