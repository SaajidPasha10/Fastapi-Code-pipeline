
For detailed tutorial visit this blog on Medium https://medium.com/@saajidshaik10/from-code-to-cloud-in-a-flash-fastapi-aws-codepipeline-codedeploy-e6187848d343

## 📦 Tech Stack
- **FastAPI** – Python Web Framework
- **AWS EC2** – App Hosting
- **AWS CodePipeline** – CI/CD Orchestration
- **AWS CodeDeploy** – App Deployment
- **PM2** – Process Manager for background runningFastapi-Code-pipeline/

---

🛠️ Step 1: Prepare Your EC2 Instance

1. Launch EC2 with Amazon Linux 2 and allow ports 22, 80, 443, 8000.
2. SSH into the instance:

```bash
sudo yum update -y
sudo yum install -y python3 python3-pip git nodejs
sudo npm install -g pm2

3. Clone the repo and set up the FastAPI app:
git clone <your-repo-url>
cd <repo-folder>
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

4. Run the FastAPI app manually:
uvicorn app:app --host 0.0.0.0 --port 8000

5. To keep it running after logout:
pm2 start "venv/bin/uvicorn app:app --host 0.0.0.0 --port 8000" --name fastapi-app
pm2 save
pm2 startup

Optional commands:
pm2 stop fastapi-app
pm2 delete fastapi-app

## 🔁 Step 2: Setup CodeDeploy
📄 appspec.yml
version: 0.0
os: linux
files:
  - source: /
    destination: /home/ec2-user/Fastapi-Code-pipeline
file_exists_behavior: OVERWRITE
hooks:
  BeforeInstall:
    - location: scripts/stop.sh
      runas: root
  AfterInstall:
    - location: scripts/after_install.sh
      runas: root
  ApplicationStart:
    - location: scripts/application_start.sh
      runas: root
  ValidateService:
    - location: scripts/post_deploy.sh
      runas: ec2-user

🧪 Deployment Scripts
📜 scripts/stop.sh
#!/bin/bash
pkill -f "uvicorn app:app" || true

📜 scripts/after_install.sh
#!/bin/bash
echo 'after_install' >> /home/ec2-user/Fastapi-Code-pipeline/deploy.log
cd /home/ec2-user/Fastapi-Code-pipeline
python3 -m venv venv || true
source venv/bin/activate
pip install -r requirements.txt

📜 scripts/application_start.sh
#!/bin/bash
echo 'start app' >> /home/ec2-user/Fastapi-Code-pipeline/deploy.log
cd /home/ec2-user/Fastapi-Code-pipeline
source venv/bin/activate
nohup uvicorn app:app --host 0.0.0.0 --port 8000 >> deploy.log 2>&1 &

📜 scripts/post_deploy.sh
#!/bin/bash
cd /home/ec2-user/Fastapi-Code-pipeline
git fetch --all
git reset --hard origin/main
source venv/bin/activate
/usr/bin/pm2 delete fastapi-app || true
/usr/bin/pm2 start venv/bin/uvicorn app:app --name fastapi-app --interpreter bash -- --host 0.0.0.0 --port 8000
/usr/bin/pm2 save

## 🛡️ Step 3: IAM Roles
You'll need 2 IAM Roles:

1. EC2 Role
Attach the following policies:

AmazonEC2RoleforAWSCodeDeploy

AmazonSSMManagedInstanceCore

2. CodeDeploy Role
Attach:

AWSCodeDeployRole

## 🟢 Step 4: Install CodeDeploy Agent on EC2
sudo yum install -y ruby wget
cd /home/ec2-user
wget https://aws-codedeploy-us-east-2.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo systemctl start codedeploy-agent
sudo systemctl status codedeploy-agent

## 🚀 Step 5: Create CodeDeploy Application & Group
Go to AWS CodeDeploy Console.

Create an Application (type: EC2/on-prem).

Create a Deployment Group:

Choose EC2 tags to target the instance.

Set deployment type to In-place.

Enable rollback.

Use CodeDeploy IAM Role created earlier.

## 🛠️ Step 6: Setup CodePipeline
Go to AWS CodePipeline.

Create a new pipeline:

Add name and select service role.

Source: GitHub (connect repo + branch).

Build: Skip or use CodeBuild if needed.

Deploy: Select CodeDeploy and link to your app/group.

Click "Create pipeline".

## ✅ Key Takeaways
🔄 Zero-Click Deployment: Push to GitHub = live FastAPI app.

⚙️ Repeatable & Consistent: No more manual EC2 updates.

🧱 PM2-Powered Uptime: Background service keeps your app alive.

🔐 Secured by IAM: Role-based access to deploy pipeline securely.

🔧 Easily Extendable: Add Docker, ECS, RDS, etc., anytime.

🧩 Conclusion
Setting up CI/CD for your FastAPI app might seem complex, but with AWS CodePipeline + CodeDeploy, you now have a clean, scalable, and automated deployment strategy.

From now on:

Git push 🚀 auto-triggers deployment

EC2 gets updated ✅

PM2 ensures uptime 🔁

