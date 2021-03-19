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
    AWS_FAIL_ON_EMPTY_CHANGESET="--fail-on-empty-changeset"
else
    AWS_FAIL_ON_EMPTY_CHANGESET="--no-fail-on-empty-changeset"
fi

if [ -n "$BASE_DIR" ]; then
    BASE_DIR="$BASE_DIR"
else
    BASE_DIR="./"
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

export PATH=$HOME/.local/bin:$PATH

cd $BASE_DIR

sam build $AWS_PARAMETER_OVERRIDES $DEBUG_MODE
sam package --output-template-file packaged.yaml --s3-bucket $AWS_DEPLOY_BUCKET
sam deploy --template-file packaged.yaml $AWS_FAIL_ON_EMPTY_CHANGESET --stack-name $AWS_STACK_NAME $CAPABILITIES $AWS_PARAMETER_OVERRIDES