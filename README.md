# AWS SAM CLI Github Action

This action supports the following capabalities:
1. Build, package and deploy an AWS SAM application in one go
2. Build an AWS SAM application and start the Lambda functions for local invocations

### Build, package and deploy an AWS SAM application

Use the following workflow to build, package and deploy an AWS SAM application

```
name: Example CD workflow

on:
  push:
    branches: [ master ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: sam build
      uses: poketapp/gh-action-aws-sam@v1
      env:
        AWS_REGION: 'eu-west-2'
        AWS_ACCESS_KEY_ID: ${{secrets.AWS_ACCESS_KEY_ID}}
        AWS_SECRET_ACCESS_KEY: ${{secrets.AWS_SECRET_ACCESS_KEY}}
        AWS_DEPLOY_BUCKET: 'test-s3-bucket'
        AWS_STACK_NAME: 'Test-Stack'
```

### Invoke Lambda function(s) locally

Use the following workflow to invoke Lambda function(s) locally

```
name: Example CD workflow

on:
  push:
    branches: [ master ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: sam build
      uses: poketapp/gh-action-aws-sam@v1
      env:
        AWS_REGION: 'ca-central-1'
        AWS_ACCESS_KEY_ID: ${{secrets.AWS_ACCESS_KEY_ID}}
        AWS_SECRET_ACCESS_KEY: ${{secrets.AWS_SECRET_ACCESS_KEY}}
        AWS_LOCAL_START_LAMBDA: 'True'
```

It is recommended to store access key id and secret access key in Github secrets.

---
#### Attributes
Some of the elements of this project were inspired by:
- [falnyr/aws-sam-deploy-action](https://github.com/falnyr/aws-sam-deploy-action) 
- [youyo/aws-sam-action](https://github.com/youyo/aws-sam-action)
