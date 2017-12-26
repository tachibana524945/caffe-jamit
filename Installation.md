# Ubuntu 16.04上にCaffeをインストール
Ubuntu 16.04がインストールされたGPU搭載のPC上にCaffeをインストールしたときの手順です．

Caffeのページを参考にしています．
Install全般: http://caffe.berkeleyvision.org/installation.html

## 1. 依存ライブラリのインストール

Caffeの以下のページを参考にしています．
Ubuntu Installation: http://caffe.berkeleyvision.org/install_apt.html
Ubuntu 16.04 or 15.10 Installation Guide: https://github.com/BVLC/caffe/wiki/Ubuntu-16.04-or-15.10-Installation-Guide

### 1.1 CUDAおよびcuDNNのインストール
Ubuntu 16.04の場合, CUDAは8.0以上が必要であるためNVIDIAからCUDA8.0をダウンロードし，インストールする．

最新バージョン: https://developer.nvidia.com/cuda-downloads

過去のバージョン: https://developer.nvidia.com/cuda-toolkit-archive

````
$ sudo ./cuda_8.0.61_375.26_linux.run
````
Ubuntu 14.04の場合でも，NVIDIA Pascal GPUの場合はCUDA 8.0以上が必要とのことです．

http://www.nvidia.co.jp/object/caffe-installation-jp.html

インストールを終えたら，ホームディレクトリの.bashrcファイルを編集し，パスの設定をする．

````
$ echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc   # パスを追記
$ echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
$ source ~/.bashrc                                            # 変更を反映
````

次に，cuDNN v6.0をダウンロードし，インストールする．なお，cuDNNのダウンロードは”NVIDIA Developer Program”に登録する必要がある．
(cuDNNはオプションであるが，CUDAに関係することからここで記載している．)

https://developer.nvidia.com/cudnn

````
$ tar -zxf cudnn-8.0-linux-x64-v6.0.tgz #圧縮ファイルの解凍
$ sudo cp cuda/include/cudnn.h /usr/local/cuda/include/ #cudnn.hファイルをcudaのディレクトリにコピー
$ sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64/　#ライブラリファイルをcudaのディレクトリにコピー
$ sudo chmod a+r /usr/local/cuda/include/cudnn.h # すべてのユーザに読み込み権限ついてない場合は権限を付けておく
````

### 1.2 opencvやhdf5などのライブラリのインストール
````
sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
sudo apt-get install --no-install-recommends libboost-all-dev
sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev
````
### 1.3 BLASのインストール
BLASは，ATLASまたはOpenBLASのどちらかを選択一つをインストールする．

````
sudo apt-get install libatlas-base-dev   # ATLASの場合(こちらをやりました)
sudo apt-get install libopenblas-dev     # OpenBLASの場合(こちらはやってません)
````

## 2. オプションライブラリのインストール
CaffeのインターフェースでPythonを使用できるようにPythonの各ライブラリをインストールする．
Pythonのバージョンは2.7もしくは3.3以上が必要なため，以下のコマンドでバージョンを確認する．

````
$ python -V
````

Pythonインストールされていない場合は，`sudo apt-get install python`でインストールしてください．Python3以上の場合はコマンドが違いますので注意してください．

CaffeのPythonインターフェース(pycaffe)をインストールする際，必要なパッケージをインストールするがその際に必要なパッケージをインストールしておく．

````
$ sudo apt-get install python-pip 
$ sudo apt-get install python-dev
$ sudo apt-get install python-numpy python-scipy
````

## 3. Caffeのインストール
### 3.1 GitHub上からZipファイルをダウンロードする．

https://github.com/BVLC/caffe

ダウンロードしたら，インストールしたい場所でZipを解凍する．

````
$ mv caffe-master.zip ~/  # ホームディレクトリにファイルを移動
$ unzip caffe-master.zip  # ホームディレクトリで解凍
$ mv caffe-master caffe   # ディレクトリ名をcaffeに変更
````
### 3.2 Makefile.configの設定
caffeのトップディレクトリにある，Makefile.config.exampleをコピーして，Makefile.configを用意し必要に応じて設定を行う．

````
$ cd caffe                # caffeのディレクトリへ移動
$ cp Makefile.config.example Makefile.config  # Makefile.configを用意
````

ここでは，Makefile.configにおいて変更した箇所および確認した箇所を紹介する．

* cuDNNの設定(5行目)
  
  cuDNNを使用できるように，コメントを外す．
  
  `USE_CUDNN := 1`

* CPU/GPUモードの設定(8行目)
  
  GPUモードで使用するため，CPU_ONLYがコメントになっているか確認する．
  
  `# CPU_ONLY := 1`

* CUDAパスの設定(28行目)
  
  CUDAのパスが適切か確認し，適切でなければ変更する．
  
  `CUDA_DIR := /usr/local/cuda` 

* BLASライブラリの設定(51行目)
  
  BLASライブラリがATLAS利用になっているか確認する．OpenBLASを使用する場合にはatlasをopenに変更する．
  
  `BLAS := atlas` 

* デバッグモードの設定(111行目)

  デバッグモードを有効にしたい場合やC++のソースコードを変更したい場合はコメントを外す．
  
  `#DEBUG := 1` 
  

* HDF5パスの設定(95-96行目)

  Ubuntu 16.04ではHDF5ライブラリのパスを設定する必要がある．
  
  ````
  INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial
  LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/hdf5/serial
  ````
  
### 3.3 caffeのビルドとテスト
Makefile.configの設定が終了したらビルドし，正しくビルドできたか確認するためにテストを行う．
なお，CPUのコア数に応じて-jオプションを用いて使用するスレッド数を指定すると，ビルドおよびテスト時間を短縮できる．

````
$ make all -j8
$ make test –j 8
$ make runtest
````

## 4. Pythonインターフェースの設定
Pythonインターフェースを使用する場合，python/requirements.txtに記載されている必要なパッケージをインストールする．
その後，pycaffeをビルドする．

````
$ cd python
$ for req in $(cat requirements.txt); do pip install $req; done
$ cd ../
$ make pycaffe
````

## 5. 各種パスの設定
インストールされた各モジュールにパスを通すために，ホームディレクトリの.bashrcファイルに基本的なコマンドがインストールされたディレクトリへのパス, およびcaffeのpythonディレクトリへのパスを追記する．

````
# Caffe path
$ echo 'CAFFE_ROOT=/home/<username>/caffe' >> ~/.bashrc
$ echo 'export PATH=$CAFFE_ROOT/build/tools:$PATH' >> ~/.bashrc
$ echo 'export PATH=$CAFFE_ROOT/include:$PATH' >> ~/.bashrc
$ echo 'export PYTHONPATH=$CAFFE_ROOT/python:$PYTHONPATH' >> ~/.bashrc
$ source ~/.bashrc
````
