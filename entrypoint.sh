#!/bin/sh -l

if [ -z "$AWS_STACK_NAME" ]; then
    echo "Missing AWS Stack Name"
    exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo "Missing AWS Access Key Id"
    exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "Missing AWS Secret Access Key"
    exit 1
fi

if [ -z "$AWS_REGION" ]; then
    echo "Missing AWS Region"
    exit 1
fi

if [ -z "$AWS_DEPLOY_BUCKET" ]; then
    echo "Missing AWS Deploy Bucket"
    exit 1
fi

if [ -z "$CAPABILITIES" ]; then
    CAPABILITIES="--capabilities CAPABILITY_IAM"
else
    CAPABILITIES="--capabilities $CAPABILITIES"
fi

sudo chown -R `whoami` /github/home/.cache

mkdir ~/.aws
touch ~/.aws/credentials
touch ~/.aws/config

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
region = $AWS_REGION" > ~/.aws/credentials

echo "[default]
region = $AWS_REGION" > ~/.aws/config

echo "Install aws-cli"
pip3 install awscli >/dev/null 2>&1
if [ "${?}" -ne 0 ]; then
    echo "Failed to install aws-cli"
else
    echo "Successfully installed aws-cli"
fi

export PATH=$HOME/.local/bin:$PATH

aws --version

echo "Install aws-sam-cli"
pip3 install aws-sam-cli >/dev/null 2>&1
if [ "${?}" -ne 0 ]; then
    echo "Failed to install aws-sam-cli"
else
    echo "Successfully installed aws-sam-cli"
fi

sudo sam build --debug
sudo sam package --output-template-file packaged.yaml --s3-bucket $AWS_DEPLOY_BUCKET
sudo sam deploy --template-file packaged.yaml --stack-name $AWS_STACK_NAME $CAPABILITIES
