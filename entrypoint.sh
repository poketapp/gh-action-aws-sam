#!/bin/sh -l

if [ "${INPUT_SAM_CMD}" == "" ]; then
	echo "Input sam_cmd cannot be empty"
	exit 1
fi

if [[ -z "$AWS_STACK_NAME" ]]; then
    echo "Missing AWS Stack Name"
    exit 1
fi

if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
    echo "Missing AWS Access Key Id"
    exit 1
fi

if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
    echo "Missing AWS Secret Access Key"
    exit 1
fi

if [[ -z "$AWS_REGION" ]]; then
    echo "Missing AWS Region"
    exit 1
fi

if [[ -z "$AWS_DEPLOY_BUCKET" ]]; then
    echo "Missing AWS Deploy Bucket"
    exit 1
fi

if [[ -z "$CAPABILITIES" ]]; then
    CAPABILITIES="--capabilities CAPABILITY_IAM"
else
    CAPABILITIES="--capabilities $CAPABILITIES"
fi

# Install AWS SAM CLI
if [ "${INPUT_SAM_VERSION}" == "latest" ]; then
	pip install aws-sam-cli >/dev/null 2>&1
	if [ "${?}" -ne 0 ]; then
		echo "Failed to install aws-sam-cli ${INPUT_SAM_VERSION}"
	else
		echo "Successfully installed aws-sam-cli ${INPUT_SAM_VERSION}"
	fi
else
	pip install aws-sam-cli==${INPUT_SAM_VERSION} >/dev/null 2>&1
	if [ "${?}" -ne 0 ]; then
		echo "Failed to install aws-sam-cli ${INPUT_SAM_VERSION}"
	else
		echo "Successfully installed aws-sam-cli ${INPUT_SAM_VERSION}"
	fi
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

sam build --use-container
sam package --output-template-file packaged.yaml --s3-bucket $AWS_DEPLOY_BUCKET
sam deploy --template-file packaged.yaml --stack-name $AWS_STACK_NAME $CAPABILITIES