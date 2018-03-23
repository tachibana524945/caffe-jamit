# Caffe��p�����摜����
�T���v���f�[�^�͗p�ӂ��Ă��܂���D�e�摜�f�[�^�̃p�X�ƃ��x�����L����train.txt��val.txt�͏������̎Q�l�܂łɃA�b�v���Ă��܂��D

## 0. �e��t�@�C���ɂ���
caffe/examples/imagenet�̃t�@�C������ɂ��Ă��܂�

## 1. ���ɂ���
�\�[�X�R�[�h�́C�ȉ��̂悤�ɔz�u���܂����D
���ω摜���g�p������@�ɂ��ẮC���ʂ̓s���㊄���������߁C�L���Ă��܂���D

caffe/
������ downloadData/
��   ������ CT/
��        ������ Brain/
��        ��   ������ TCGA-14-0783-0000.png
��        ��   ������ TCGA-14-0783-0001.png
��        ��                  ...
��        ������ Chest/
��        ��   ������ AMC-002-0000.png
��        ��   ������ AMC-002-0001.png
��        ��                  ...
��        ������ train.txt
��        ������ val.txt
������ examples/
     ������ jamit/
          ������ category.txt
          ������ classify.py
          ������ convert_binaryproto_to_npy.py
          ������ create_lmdb.sh
          ������ deploy.prototxt
          ������ deploy_vTL.prototxt
          ������ make_mean_image.sh
          ������ plot_training_log.py
          ������ solver.prototxt
          ������ solver_vTL.prototxt
          ������ train_val.prototxt
          ������ train_val_vTL.prototxt

## 2. �f�[�^�x�[�X�̍쐬
create_lmdb.sh�̃p�X�̐ݒ�C�摜�f�B���N�g���̎w��C�f�[�^�x�[�X���̎w��������̊��ɍ��킹�ď��������Ccaffe�����ňȉ��̃R�}���h�����s����D

`./examples/jamit/create_lmdb.sh`


## 3. �l�b�g���[�N��`�t�@�C���̏���
* train_val.prototxt���l�b�g���[�N��`�t�@�C���D
* ��`�t�@�C����"data_param"��"source"�̉ӏ����C�쐬�����f�[�^�x�[�X���ɕύX����D
* layer name "fc8"��"num_output"��2�Ƃ���D
* batch size���ݍ��ݑw�̃t�B���^�T�C�Y�Ȃǂ��C�l�b�g���[�N��`�t�@�C���Ŏw�肷��D

## 4. Solver�̏���
* solver.prototxt�Œ�`����
* �l�b�g���[�N��`�t�@�C���p�X���w�肵�C�e��p�����[�^��ݒ肷��D

## 5. ���f���̊w�K
caffe train�R�}���h�𗘗p���ă��f���̊w�K�����s����D
���f����ۑ�����models�f�B���N�g�����쐬���Ă��Ȃ��ꍇ�́C�쐬���Ă����D
`mkdir examples/jamit/models`

caffe�����ňȉ��̃R�}���h�����s����D

`caffe train --solver=./examples/jamit/solver.prototxt --gpu=0`

�w�K��e�X�g�̃O���t���쐬�������ꍇ�ɂ́C���O�t�@�C������ƃf�B���N�g���ɃR�s�[���Cplot_training_log.py��p���č쐬����D

`cd examples/jamit/`
`cp /tmp/caffe.INFO  ./`
`python plot_training_log.py 6 save.png caffe.INFO`

�����Ɏw�肵��6��"Train loss  vs. Iters"�̃O���t�^�C�v���쐬����I�v�V�����ł���D���̑��̃^�C�v��`python plot_training_log.py`�Ŋm�F�ł���D

## 6. �摜���ރe�X�g�̎��s
�N���X���x���ƃJ�e�S�������L�����e�L�X�g�t�@�C��(category.txt)�ƃe�X�g�摜(test.png)���������Cclassify.py��p���ĕ��ރe�X�g�����s����D

`python classify.py --model_def=deploy.prototxt --pretrained_model=./models/jamit_train_iter_5000.caffemodel test.png out.npy  category.txt`

## 7. �]�ڊw�K�ɂ���
�]�ڊw�K������ꍇ�ɂ́C�w�K�ς݃��f���̃��C���[���Əd�����Ȃ��悤�ɁC�Ō�̑S�����w�hfc8�h��ʂ̖��O�ɕύX����K�v������D�]�ڊw�K�p�Ɉꕔ�ύX�����t�@�C���̗�͈ȉ��̒ʂ�ł���D

* solver_vTL.prototxt (�Q�Ƃ����`�t�@�C���C���f������ύX)
* train_val_vTL.prototxt (fc8��fc8tl�ɕύX)
* deploy_vTL.prototxt (fc8��fc8tl�ɕύX)

�܂��C���s�͈ȉ��̒ʂ�ł���D
`caffe train --solver=./examples/jamit/solver_vTL.prototxt --weights=./models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel --gpu=0`

## 8. ���ω摜�̍쐬�Ǝg�p

���ʂł́C�y�[�W���̓s����C���ω摜�̍쐬�Ǝg�p�ɂ��Ă͊��������Ă����������D
���ω摜���g�p����ꍇ�́C�ȉ��̏�����K�X�ǉ�����΂悢�D
(1) make_mean_image.sh��p���āC���ω摜(binaryproto�`��)���쐬����(caffe/����)

`./examples/jamit/make_mean_image.sh `

(2) convert_binaryproto_to_npy.py��p���āCbinaryproto�`����npy�`���ɕύX����(examples/jamit/����)

`python convert_binaryproto_to_npy.py jamit_mean.binaryproto jamit_mean.npy`

(3) �l�b�g���[�N��`�t�@�C��train_val.prototxt�̕��ω摜�ւ̃t�@�C���p�X�̃R�����g���O��

(4) �w�K���s��C���ރe�X�g�Ŏg�p����classify.py�̕��ω摜�̓ǂݍ��ݖ��߂̃R�����g���O���C���s���ɕ��ω摜���w�肷��D(examples/jamit/����)

`python classify.py --model_def=deploy.prototxt --mean_file=jamit_mean.npy --pretrained_model=./models/jamit_train_iter_5000.caffemodel test.png out.npy  category.txt`