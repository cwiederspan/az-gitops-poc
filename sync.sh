#!/bin/bash

go-getter $GIT_REPO_URI /azgitops/src

# az login \
# --service-principal \
# --username $AZ_SP_APPID \
# --password $AZ_SP_PASSWORD \
# --tenant $AZ_SP_TENANTID

az login --identity

az deployment sub create \
--name AzureGitOps \
--location westus2 \
--template-file /azgitops/src/$GIT_BOOTSTRAP_PATH