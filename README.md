## AWS SAM Github Action
This action supports the following capabalities:
1. Build, package and deploy an AWS SAM application

### Build, package and deploy an AWS SAM application
In addition to the required environment variables, set the following environment variables in your job:
- **AWS_DEPLOYMENT_BUCKET**: This is the name of the S3 bucket which will contain the deployment package
- **AWS_STACK_NAME**: This is the name of your CloudFormation stack

Use the following workflow to build, package and deploy an AWS SAM application
```
name: Example CD workflow
on:
  push:
    branches: [ main ]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: sam build
      uses: poketapp/gh-action-aws-sam@v2
      env:
        AWS_REGION: 'eu-west-2'
        AWS_ACCESS_KEY_ID: ${{secrets.AWS_ACCESS_KEY_ID}}
        AWS_SECRET_ACCESS_KEY: ${{secrets.AWS_SECRET_ACCESS_KEY}}
        AWS_DEPLOYMENT_BUCKET: 'test-s3-bucket'
        AWS_STACK_NAME: 'Test-Stack'
        AWS_PARAMETER_OVERRIDES: 'KeyPairName=MyKey InstanceType=t1.micro'
```

### Environment variables
* `AWS_REGION`:This is a *required* property
* `AWS_ACCESS_KEY_ID`: This is a *required* property
* `AWS_SECRET_ACCESS_KEY`: This is a *required* property
* `DEBUG_MODE`: This is an *optional* property and setting it runs `sam build` in debug mode
* `AWS_PARAMETER_OVERRIDES`: This is an *optional* property and is passed in to the `--parameter-overrides` option in `sam deploy`
* `AWS_FAIL_ON_EMPTY_CHANGESET`: This is an *optional* property and setting it runs `sam deploy` with `--fail-on-empty-changeset`. The default behaviour is to run `sam deploy` with `--no-fail-on-empty-changeset`
* `BASE_DIR`: This is an *optional* property and setting it changes the base directory to the specified value

It is recommended to store access key id and secret access key in Github secrets.