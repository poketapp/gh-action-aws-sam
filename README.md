# AWS SAM CLI Github Action

This action allows you to build, package and deploy an AWS SAM application in one go. 

For example, you can use it to build, package and deploy a SAM application all in one workflow

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
        AWS_PARAMETERS: 'ParameterKey=KeyPairName ParameterValue=MyKey'
```

## Env

### `AWS_ACCESS_KEY_ID` **Required**
### `AWS_SECRET_ACCESS_KEY` **Required**
### `AWS_REGION` **Required**
### `AWS_DEPLOY_BUCKET` **Required**
### `AWS_STACK_NAME` **Required**
### `AWS_PARAMETERS` **Optional**

It is recommended to store access key id and secret access key in Github secrets.

---
### Attributes
Some of the elements of this project were borrowed from:
- [falnyr/aws-sam-deploy-action](https://github.com/falnyr/aws-sam-deploy-action) 
- [youyo/aws-sam-action](https://github.com/youyo/aws-sam-action)
