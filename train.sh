###
# Training
###
source activate tensorflow_p36

sudo apt install htop

cd ~
rm -rf tensorflow1
mkdir tensorflow1
cd tensorflow1/
git clone https://github.com/tensorflow/models.git
cd models
git reset --hard 256b8ae622355ab13a2815af326387ba545d8d60
cd ..

wget http://download.tensorflow.org/models/object_detection/faster_rcnn_inception_v2_coco_2018_01_28.tar.gz
tar xvzf faster_rcnn_inception_v2_coco_2018_01_28.tar.gz
mv faster_rcnn_inception_v2_coco_2018_01_28 models/research/object_detection/

git clone https://github.com/EdjeElectronics/TensorFlow-Object-Detection-API-Tutorial-Train-Multiple-Objects-Windows-10.git
cd TensorFlow-Object-Detection-API-Tutorial-Train-Multiple-Objects-Windows-10
git reset --hard bf94ece8313c6176d9027670099fca9e4931a8ce
cd ..

mv TensorFlow-Object-Detection-API-Tutorial-Train-Multiple-Objects-Windows-10/* models/research/object_detection/

export PYTHONPATH=$PYTHONPATH=/home/ubuntu/tensorflow1/models:/home/ubuntu/tensorflow1/models/research:/home/ubuntu/tensorflow1/models/research/slim

cd ./models/research

protoc object_detection/protos/*.proto --python_out=.

cd ~/tensorflow1/models/research
python setup.py build
python setup.py install

# jupyter notebook --ip 0.0.0.0 --port 8888

cd ~/tensorflow1/models/research/object_detection
python xml_to_csv.py

python generate_tfrecord.py --csv_input=images/train_labels.csv --image_dir=images/train --output_path=train.record
python generate_tfrecord.py --csv_input=images/test_labels.csv --image_dir=images/test --output_path=test.record

cd ~/tensorflow1/models/research/object_detection/training
# vi faster_rcnn_inception_v2_pets.config

cp ~/tensorflow1/models/research/object_detection/samples/configs/faster_rcnn_inception_v2_pets.config my_config.config

sed -i -e '9s@.*@    num_classes: 6@' my_config.config

sed -i '106s@.*@fine_tune_checkpoint: "/home/ubuntu/tensorflow1/models/research/object_detection/faster_rcnn_inception_v2_coco_2018_01_28/model.ckpt"@' my_config.config

sed -i '123s@.*@    input_path: "/home/ubuntu/tensorflow1/models/research/object_detection/train.record"@' my_config.config

sed -i '125s@.*@  label_map_path: "/home/ubuntu/tensorflow1/models/research/object_detection/training/labelmap.pbtxt"@' my_config.config

sed -i '135s@.*@    input_path: "/home/ubuntu/tensorflow1/models/research/object_detection/train.record"@' my_config.config

sed -i '137s@.*@  label_map_path: "/home/ubuntu/tensorflow1/models/research/object_detection/training/labelmap.pbtxt"@' my_config.config


pip install pycocotools

cd ~/tensorflow1/models/research/object_detection

# https://github.com/tensorflow/models/issues/4780#issuecomment-405441448
sed -i 's@category_index.values()@list(category_index.values())@' model_lib.py

source deactivate

screen -d -m bash -c "source activate tensorflow_p36 ; export PYTHONPATH=$PYTHONPATH=/home/ubuntu/tensorflow1/models:/home/ubuntu/tensorflow1/models/research:/home/ubuntu/tensorflow1/models/research/slim ; python model_main.py --pipeline_config_path=training/my_config.config --model_dir=training/ --alsologtostderr"

cd ~/tensorflow1/models/research/object_detection

screen -d -m bash -c "source activate tensorflow_p36 ; export PYTHONPATH=$PYTHONPATH=/home/ubuntu/tensorflow1/models:/home/ubuntu/tensorflow1/models/research:/home/ubuntu/tensorflow1/models/research/slim ; tensorboard --logdir=training/"
