# Training a Tensorflow model on AWS Ubuntu DeepLearning AMI
!! Repo is just for experimentaiton + learning. I have 0 training in machine learning !!

Train a ML model that detects individual playing cards in video.

Completely based off the follwoing guide and modified to work on Amazons Ubuntu DeepLearning AMI: <https://github.com/EdjeElectronics/TensorFlow-Object-Detection-API-Tutorial-Train-Multiple-Objects-Windows-10>

Training should all work just by copy and pasting the contents of train.sh into a SSH session.

To run the model you will need a computer with (No tutorial here):
- Camera
- Display
- Tensorflow installed
- python scripts from TensorFlow-Object-Detection-API-Tutorial-Train-Multiple-Objects-Windows-10 repository

## Create instance for training
- p2.xlarge = ~$1.50 p/h Sydney
- p2.xlarge = 1 GPU


`aws ec2 run-instances --region ap-southeast-2 --image-id ami-058bdf7c57f0d22a0 --subnet SUBNET_ID --instance-type p2.xlarge --key-name KEYNAME --profile PROFILE`

## Connect
ssh -i ~/.ssh/KEYNAME.pem ubuntu@52.65.45.18

## Start Training
Copy contents of train.sh into SSH session.

## Monitor Training
- Navigate to: http://SERVER_PUBLIC_IP:6006
- `htop`
- `screen -r`
- https://www.gnu.org/software/screen/manual/screen.html
