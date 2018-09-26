source activate tensorflow_p36

export PYTHONPATH=$PYTHONPATH=/home/ubuntu/tensorflow1/models:/home/ubuntu/tensorflow1/models/research:/home/ubuntu/tensorflow1/models/research/slim

cd ~/tensorflow1/models/research/object_detection

python export_inference_graph.py \
    --input_type image_tensor \
    --pipeline_config_path training/my_config.config \
    --trained_checkpoint_prefix training/model.ckpt-59759 \
    --output_directory inference_graph_ckpt-59759

aws s3 sync . s3://BUCKET/model.ckpt-59759
