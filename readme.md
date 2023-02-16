# Download yace release binary

    curl -LO https://github.com/nerdswords/yet-another-cloudwatch-exporter/releases/download/v0.48.0-alpha/yet-another-cloudwatch-exporter_0.48.0-alpha_Linux_x86_64.tar.gz

## create config file and configuration directory

    touch config.yml
    sudo mkdir /etc/yace
    sudo chown ubuntu:ubuntu /etc/yace -R
    sudo mv config.yml /etc/yace/
    sudo mv yace /usr/local/bin/

## create systemd service unit file

    sudo vim /etc/systemd/system/yace.service

## yace.service

    [Unit]
    DescriptionYACE exporter
    Wantsnetwork-online.target
    Afternetwork-online.target

    [Service]
    Typesimple
    Userubuntu
    Groupubuntu
    ExecStart/usr/local/bin/yace \
      --config.file/etc/yace/config.yml 
    Restartalways

    [Install]
    WantedBymulti-user.target

## Restart systemd and enable yace service

    sudo systemctl daemon-reload
    sudo systemctl enable  yace
    sudo systemctl start  yace
    sudo systemctl status  yace

## check metrics

    curl localhost:5000/metrics

# Option 2
You can take the obtion of baking up the config.yml file together with a 

## Build image from the official  image:

    FROM ghcr.io/nerdswords/yet-another-cloudwatch-exporter:v0.44.0-alpha
    COPY config.yml /tmp/config.yml

## Create and Push to cloudessence ECR

    aws ecr create-repository --repository-name yace 
    docker build -t  account_id.dkr.ecr.us-east-1.amazonaws.com/yace:v1.0.0 .
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin account_id.dkr.ecr.us-east-1.amazonaws.com
    docker push  account_id.dkr.ecr.us-east-1.amazonaws.com/yace:v1.0.0 

## Create YACE-cluster
ECS cluster, service and task definition were all done using terraform

