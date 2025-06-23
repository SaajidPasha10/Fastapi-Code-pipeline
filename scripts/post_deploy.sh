#!/bin/bash
cd /home/ec2-user/Fastapi-Code-pipeline
# Update code
git fetch --all
git reset --hard origin/main

# Activate environment
source venv/bin/activate

# Restart PM2 process
/usr/bin/pm2 delete fastapi-app || true
/usr/bin/pm2 start venv/bin/uvicorn app:app \
  --name fastapi-app --interpreter bash -- --host 0.0.0.0 --port 8000

/usr/bin/pm2 save
