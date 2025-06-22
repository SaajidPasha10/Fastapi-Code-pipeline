#!/bin/bash
echo 'after_install' >> /home/ec2-user/Fastapi-Code-pipeline/deploy.log
cd /home/ec2-user/Fastapi-Code-pipeline
python3 -m venv venv || true
source venv/bin/activate
pip install -r requirements.txt
