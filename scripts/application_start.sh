#!/bin/bash
echo 'start app' >> /home/ec2-user/Fastapi-Code-pipeline/deploy.log
cd /home/ec2-user/Fastapi-Code-pipeline
source venv/bin/activate
nohup uvicorn app:app --host 0.0.0.0 --port 8000 >> deploy.log 2>&1 &
