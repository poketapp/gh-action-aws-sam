#!/bin/sh -l

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

if [ -z "$AWS_LOCAL_START_LAMBDA" ]; then
    if [ -z "$AWS_STACK_NAME" ]; then
        echo "Missing AWS Stack Name"
        exit 1
    fi

    if [ -z "$AWS_DEPLOY_BUCKET" ]; then
        echo "Missing AWS Deploy Bucket"
        exit 1
    fi
fi

if [ -z "$CAPABILITIES" ]; then
    CAPABILITIES="--capabilities CAPABILITY_IAM"
else
    CAPABILITIES="--capabilities $CAPABILITIES"
fi

if [ -n "$DEBUG_MODE" ]; then
    DEBUG_MODE="--debug"
else
    DEBUG_MODE=""
fi

mkdir ~/.aws
touch ~/.aws/credentials
touch ~/.aws/config

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
region = $AWS_REGION" > ~/.aws/credentials

echo "[default]
region = $AWS_REGION" > ~/.aws/config

echo "Install dependencies"
pip3 install awscli aws-sam-cli pytest pytest-mock boto3 botocore >/dev/null 2>&1
if [ "${?}" -ne 0 ]; then
    echo "Failed to install dependencies"
else
    echo "Successfully installed dependencies"
fi

export PATH=$HOME/.local/bin:$PATH

if [ -n "$AWS_LOCAL_START_LAMBDA" ]; then
    sam build $DEBUG_MODE
    sudo sam local start-lambda --docker-network host &
    python3 -m pytest $PYTHON_TEST_DIR -v
else
    sam build $DEBUG_MODE
    sam package --output-template-file packaged.yaml --s3-bucket $AWS_DEPLOY_BUCKET
    sam deploy --template-file packaged.yaml --stack-name $AWS_STACK_NAME $CAPABILITIES
fi