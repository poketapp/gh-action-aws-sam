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
        AWS_DEPLOY_BUCKET: ${{secrets.AWS_DEPLOY_BUCKET}}
        AWS_STACK_NAME: ${{secrets.AWS_STACK_NAME}}
```

## Env

### `AWS_ACCESS_KEY_ID` **Required**
### `AWS_SECRET_ACCESS_KEY` **Required**
### `AWS_REGION` **Required**
### `AWS_DEPLOY_BUCKET` **Required**
### `AWS_STACK_NAME` **Required**

It is recommended to store all of the environment variables in Github secrets.

---
This project was inspired by [falnyr/aws-sam-deploy-action](https://github.com/falnyr/aws-sam-deploy-action) which performed 2/3 SAM actions for our use case (`package` and `deploy`) but not `build`.