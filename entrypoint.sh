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

if [ -z "$INTEGRATION_TEST_MODE" ]; then
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

if [ -n "$AWS_PARAMETER_OVERRIDES" ]; then
    AWS_PARAMETER_OVERRIDES="--parameter-overrides $AWS_PARAMETER_OVERRIDES"
else
    AWS_PARAMETER_OVERRIDES=""
fi

if [ -n "$AWS_FAIL_ON_EMPTY_CHANGESET" ]; then
    AWS_FAIL_ON_EMPTY_CHANGESET="--no-fail-on-empty-changeset"
else
    AWS_FAIL_ON_EMPTY_CHANGESET="--fail-on-empty-changeset"
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
pip3 install setuptools wheel awscli aws-sam-cli pytest pytest-mock boto3 botocore >/dev/null 2>&1
if [ "${?}" -ne 0 ]; then
    echo "Failed to install dependencies"
else
    echo "Successfully installed dependencies"
fi

export PATH=$HOME/.local/bin:$PATH

if [ -n "$INTEGRATION_TEST_MODE" ]; then
    sam build $DEBUG_MODE
    sam local start-lambda $DEBUG_MODE &
    python3 -m pytest $PYTHON_TEST_DIR -v
else
    sam build $AWS_PARAMETER_OVERRIDES $DEBUG_MODE
    sam package --output-template-file packaged.yaml --s3-bucket $AWS_DEPLOY_BUCKET
    sam deploy --template-file packaged.yaml --no-fail-on-empty-changeset --stack-name $AWS_STACK_NAME $CAPABILITIES $AWS_PARAMETER_OVERRIDES $AWS_FAIL_ON_EMPTY_CHANGESET
fi