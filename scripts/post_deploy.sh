#!/bin/bash
cd /home/ec2-user/Fastapi-Code-pipeline
git fetch --all
git reset --hard origin/main

pm2 delete fastapi-app || true
pm2 start venv/bin/uvicorn app:app --name fastapi-app --interpreter bash -- --host 0.0.0.0 --port 8000

pm2 save
