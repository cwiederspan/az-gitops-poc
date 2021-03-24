#!/bin/bash

echo "Using App ID: $AZ_SP_APPID..."

go get 
go-getter $GIT_REPO_URI /azgitops/src

# az login \
# --service-principal \
# --username $AZ_SP_APPID \
# --password $AZ_SP_PASSWORD \
# --tenant $AZ_SP_TENANTID

az login --identity

# az group update \
# -g $AZ_RG_NAME \
# --set tags.Environment='Test'

az deployment group create \
--name AzureGitOps \
--resource-group $AZ_RG_NAME \
--template-file /azgitops/src/$GIT_BOOTSTRAP_PATH