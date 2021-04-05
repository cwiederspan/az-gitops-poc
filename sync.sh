#!/bin/bash

go-getter $GIT_REPO_URI /azgitops/src

# az login \
# --service-principal \
# --username $AZ_SP_APPID \
# --password $AZ_SP_PASSWORD \
# --tenant $AZ_SP_TENANTID

az login --identity

# az deployment group create \
# --name AzureGitOps \
# --location westus2 \
# --template-file /azgitops/src/$GIT_BOOTSTRAP_PATH

az deployment group create \
--name AzureGitOps \
--resource-group $AZ_RG_NAME \
--template-file /azgitops/src/$GIT_BOOTSTRAP_PATH