#!/bin/bash
echo 'after_install' >> /home/ec2-user/fastapi-codedeploy/deploy.log
cd /home/ec2-user/fastapi-codedeploy
python3 -m venv venv || true
source venv/bin/activate
pip install -r requirements.txt
