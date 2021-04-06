#!/bin/bash

BASE_NAME=cdw-azgitops-20210405
LOCATION=westus2
SUBSCRIPTION_ID=$(az account show --query id --output tsv)

RG_SCOPE_ID=$(az group create \
 -n $BASE_NAME \
 -l $LOCATION \
 --query id \
 --output tsv)

IDENTITY_ID=$(az identity create \
 -n $BASE_NAME-msi \
 -g $BASE_NAME \
 -l $LOCATION \
 --query id \
 --output tsv)

IDENTITY_SP=$(az identity show \
 -n $BASE_NAME-msi \
 -g $BASE_NAME \
 --query principalId \
 --output tsv)

az role assignment create \
  --assignee $IDENTITY_SP \
  --scope $RG_SCOPE_ID \
  --role 'Contributor'

az container create \
-g $BASE_NAME \
-n $BASE_NAME-agent \
--image cwiederspan/azgitops:latest \
--cpu 0.5 \
--memory 0.5 \
--restart-policy Never \
--assign-identity $IDENTITY_ID \
--environment-variables \
  'AZ_RG_NAME'=$BASE_NAME \
  'GIT_REPO_URI'='github.com/cwiederspan/az-gitops-src-poc' \
  'GIT_BOOTSTRAP_PATH'='group/main.bicep'