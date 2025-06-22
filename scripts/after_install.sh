version: 0.0
os: linux
files:
  - source: /
    destination: /home/ec2-user/fastapi-codedeploy
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
